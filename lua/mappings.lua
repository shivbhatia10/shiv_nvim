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
