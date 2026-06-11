require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "hls", "ocamllsp" }
vim.lsp.enable(servers)

local augroup = vim.api.nvim_create_augroup("UserLsp", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if client:supports_method "textDocument/codeLens" then
      vim.lsp.codelens.refresh { bufnr = args.buf }
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
  group = augroup,
  callback = function(args)
    vim.lsp.codelens.refresh { bufnr = args.buf }
  end,
})
