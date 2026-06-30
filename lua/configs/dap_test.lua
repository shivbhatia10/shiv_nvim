-- vim-test → nvim-dap bridge for Rust.
--
-- Registered as a vim-test custom strategy ("dap") in the vim-test plugin spec.
-- vim-test works out the nearest test / file scope and hands us the cargo
-- command it would have run; we translate that into a codelldb launch:
--   * parse out --package / --bin / the test filter / --exact
--   * `cargo test --no-run` to compile the test binary (scoped to that package/bin)
--   * pick the executable whose target matches the current file
--   * launch it under the debugger with the same filter
local M = {}

-- Run `cargo test --no-run` and return the test executables it built.
-- extra_args scopes the build (e.g. { "--package", "foo" }); nil builds all.
-- Each artifact: { exe = <path>, src_path = <crate-root .rs>, is_lib = <bool> }.
function M.build_test_artifacts(extra_args)
  vim.notify "Building test binary (cargo test --no-run)…"
  local cmd = { "cargo", "test", "--no-run", "--message-format=json" }
  if extra_args then
    vim.list_extend(cmd, extra_args)
  end
  local arts = {}
  for _, line in ipairs(vim.fn.systemlist(cmd)) do
    local ok, msg = pcall(vim.json.decode, line)
    if
      ok
      and type(msg) == "table"
      and msg.reason == "compiler-artifact"
      and msg.profile
      and msg.profile.test
      and type(msg.executable) == "string"
    then
      arts[#arts + 1] = {
        exe = msg.executable,
        src_path = msg.target and msg.target.src_path or "",
        is_lib = msg.target and vim.tbl_contains(msg.target.kind or {}, "lib") or false,
      }
    end
  end
  return arts
end

-- Choose the executable whose target best matches `file`: an exact source match
-- wins; otherwise the target whose source directory is the longest prefix of the
-- file (lib breaks ties, e.g. a module shared between lib.rs and main.rs).
local function pick_exe(arts, file)
  local best, best_score = nil, -1
  for _, a in ipairs(arts) do
    local score = -1
    if a.src_path == file then
      score = math.huge
    else
      local dir = vim.fn.fnamemodify(a.src_path, ":h")
      if file:sub(1, #dir + 1) == dir .. "/" then
        score = #dir * 2 + (a.is_lib and 1 or 0)
      end
    end
    if score > best_score then
      best, best_score = a.exe, score
    end
  end
  return best
end

-- vim-test custom strategy entry point. `cmd` is the full cargo command string
-- vim-test assembled, e.g. "cargo test --package foo 'a::b::it_works' -- --exact".
function M.run(cmd)
  local file = vim.fn.expand "%:p"
  local pkg = cmd:match "%-%-package%s+(%S+)"
  local bin = cmd:match "%-%-bin%s+(%S+)"
  local filter = cmd:match "'([^']*)'" -- shellescaped test path; '' for whole-file at crate root
  local exact = cmd:find("--exact", 1, true) ~= nil

  local extra = {}
  if pkg then
    vim.list_extend(extra, { "--package", pkg })
  end
  if bin then
    vim.list_extend(extra, { "--bin", bin })
  end

  local arts = M.build_test_artifacts(extra)
  if #arts == 0 then
    vim.notify("No test binary built — does `cargo test` compile?", vim.log.levels.ERROR)
    return
  end

  local exe = pick_exe(arts, file)
  if not exe then
    if #arts == 1 then
      exe = arts[1].exe
    else
      local items = { "Select test binary:" }
      for i, a in ipairs(arts) do
        items[i + 1] = i .. ". " .. vim.fn.fnamemodify(a.exe, ":t")
      end
      local idx = vim.fn.inputlist(items)
      exe = arts[idx] and arts[idx].exe
    end
  end
  if not exe then
    return
  end

  local args = {}
  if filter and filter ~= "" then
    args[#args + 1] = filter
  end
  if exact then
    args[#args + 1] = "--exact"
  end
  vim.list_extend(args, { "--nocapture", "--test-threads=1" })

  require("dap").run {
    name = "vim-test: debug",
    type = "codelldb",
    request = "launch",
    program = exe,
    args = args,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  }
end

return M
