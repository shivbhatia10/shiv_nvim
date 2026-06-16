---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox_light",
  hl_override = {
    -- darken comments: @comment (treesitter) is what colors code comments;
    -- Comment covers non-treesitter buffers. -10 = 10% darker, more negative = darker.
    Comment = { fg = { "grey_fg", -10 } },
    ["@comment"] = { fg = { "grey_fg", -10 } },
  },
}

M.ui = {
  statusline = {
    modules = {
      file = function()
        local stl = require "nvchad.stl.utils"
        local icon = stl.file()[1]
        local path = vim.api.nvim_buf_get_name(stl.stbufnr())
        local name = (path == "" and "Empty") or vim.fn.fnamemodify(path, ":~")

        local sep_style = require("nvconfig").ui.statusline.separator_style
        local separators = (type(sep_style) == "table" and sep_style) or stl.separators[sep_style]
        local pad = sep_style == "default" and " " or ""

        return "%#St_file# " .. icon .. " " .. name .. pad .. "%#St_file_sep#" .. separators.right
      end,
    },
  },
}

return M
