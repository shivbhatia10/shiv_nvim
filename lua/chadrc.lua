-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "gruvbox",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }

-- Show the file's home-relative path in the statusline instead of just its name
M.ui = {
  statusline = {
    modules = {
      file = function()
        local stl = require "nvchad.stl.utils"
        local icon = stl.file()[1] -- reuse NvChad's devicon logic
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
