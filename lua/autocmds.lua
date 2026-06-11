require "nvchad.autocmds"

vim.opt.autowriteall = true

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("autosave", { clear = true }),
  desc = "autosave modified file buffers",
  callback = function(args)
    local bo = vim.bo[args.buf]
    if bo.buftype == "" and bo.modifiable and not bo.readonly and vim.api.nvim_buf_get_name(args.buf) ~= "" then
      vim.cmd "silent! update"
    end
  end,
})
