vim.cmd 'augroup fmt'
  vim.cmd 'autocmd!'
  vim.cmd 'autocmd BufWritePre * undojoin | Neoformat'
vim.cmd 'augroup END'

vim.g.neoformat_enabled_python = { "black" }
vim.g.neoformat_python_black = {
  exe = "black",
  args = { "-q", "--line-length=100", "-"},
  stdin = 1,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
