require "nvchad.mappings"

local map = vim.keymap.set

map("i", "jk", "<ESC>")

map("n", "<leader>ff", function()
  require("telescope.builtin").find_files { hidden = true, file_ignore_patterns = { "%.git/" } }
end, { desc = "telescope find files (incl. hidden)" })

map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "telescope find keymaps" })

map("n", "<leader>gb", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-blame" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd "Gitsigns blame"
end, { desc = "git blame current file (toggle)" })

map("n", "<leader>dd", "<cmd>Trouble diagnostics toggle<CR>", { desc = "trouble diagnostics (workspace)" })
map("n", "<leader>db", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "trouble diagnostics (buffer)" })

map("n", "<leader>o", "<cmd>Outline<CR>", { desc = "toggle symbol outline" })

map("n", "<leader>ih", function()
  local b = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = b }, { bufnr = b })
end, { desc = "toggle inlay hints" })

map("n", "<leader>tr", function()
  require("neotest").output_panel.clear()
  require("neotest").run.run()
end, { desc = "test: run nearest" })

map("n", "<leader>tf", function()
  require("neotest").output_panel.clear()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "test: run file" })

map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "test: toggle summary" })

map("n", "<leader>to", function()
  require("neotest").output.open { enter = true }
end, { desc = "test: output (float)" })

map("n", "<leader>tO", function()
  require("neotest").output_panel.toggle()
end, { desc = "test: output panel" })

map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "diffview: open" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "diffview: file history" })

map("n", "<leader>sr", "<cmd>GrugFar<CR>", { desc = "search & replace (grug-far)" })
