return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
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
      ensure_installed = { "rust-analyzer", "stylua", "haskell-language-server" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust", "toml", "haskell", "ocaml", "ocaml_interface" })
      opts.auto_install = true
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    lazy = false,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {},
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
  },

  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    opts = {},
  },

  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPost",
    opts = {},
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require "rustaceanvim.neotest",
        },
      }
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = {},
  },

  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
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
