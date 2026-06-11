require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")

-- find files including hidden/dotfiles (e.g. .gitignore), but skip the .git/ dir
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files { hidden = true, file_ignore_patterns = { "%.git/" } }
end, { desc = "telescope find files (incl. hidden)" })

-- command-palette style: fuzzy-search every keymap by its description and run it
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "telescope find keymaps" })

-- toggle the full-file git blame panel (discoverable via <leader>fk -> search "blame")
map("n", "<leader>gb", function()
  -- if the blame panel is already open in this tab, close it; otherwise open it
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "gitsigns-blame" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd "Gitsigns blame"
end, { desc = "git blame current file (toggle)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
