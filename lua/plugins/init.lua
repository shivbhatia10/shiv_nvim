return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- auto-install LSP servers / tools so a fresh clone just works
  {
    "mason-org/mason.nvim",
    event = "VeryLazy",
    opts = { ensure_installed = { "rust-analyzer" } },
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

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
