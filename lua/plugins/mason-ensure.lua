-- Ensure Mason installs the LSP servers / tools we depend on
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- C / C++
        "clangd",
        "clang-format",
        -- Python
        "basedpyright",
        "ruff",
        -- Ruby / Rails (skip — install via `gem install ruby-lsp` in your project)
      })
    end,
  },
}
