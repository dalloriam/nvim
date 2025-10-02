-- neoformat settings for python
vim.g.neoformat_enabled_python = { "ruff" }
vim.g.neoformat_python_black = {
  exe = "black",
  args = { "-q", "--line-length=120", "-" },
  stdin = 1,
}

-- run Neoformat for everything except rust
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "rust" then
      vim.cmd("undojoin | Neoformat")
    end
  end,
})

-- rust uses LSP formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

