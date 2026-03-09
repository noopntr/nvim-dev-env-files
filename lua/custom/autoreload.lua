vim.o.autoread = true

vim.api.nvim_create_autocmd({
  "FocusGained", "BufEnter", "WinEnter",
  "TermLeave", "CursorHold", "CursorHoldI",
}, {
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Shorter CursorHold delay so it triggers faster
vim.o.updatetime = 1000
