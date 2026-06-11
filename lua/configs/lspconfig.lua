require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "rust_analyzer" }
vim.lsp.enable(servers)
