-- Autocmds are automatically loaded on the VeryLazy event
-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Prevent SIGABRT crash on exit: plugins that schedule nvim_buf_delete
-- during shutdown trigger a libuv assertion when autocommands try to
-- poll the event loop after it has begun tearing down.
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.api.nvim_buf_delete = function() end
  end,
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})
