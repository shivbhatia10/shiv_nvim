require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("i", "jk", "<ESC>")

-- find files including hidden/dotfiles (e.g. .gitignore), but skip the .git/ dir
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files { hidden = true, file_ignore_patterns = { "%.git/" } }
end, { desc = "telescope find files (incl. hidden)" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
