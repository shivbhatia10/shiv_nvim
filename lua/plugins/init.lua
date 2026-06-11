return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "rust-analyzer", "stylua" },
    },
  },

  {
    "pocco81/auto-save.nvim",
    lazy = false,
  },
  {
    "arnamak/stay-centered.nvim",
    config = function()
      require("stay-centered").setup()
    end,
    lazy = false,
  },
  {
    "Aasim-A/scrollEOF.nvim",
    event = { "CursorMoved", "WinScrolled" },
    opts = {},
  },
}
