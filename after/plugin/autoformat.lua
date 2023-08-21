vim.cmd 'augroup fmt'
  vim.cmd 'autocmd!'
  vim.cmd 'autocmd BufWritePre * undojoin | Neoformat'
vim.cmd 'augroup END'

vim.g.rustfmt_autosave = 1
