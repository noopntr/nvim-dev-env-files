return {
  -- "sainnhe/sonokai",
  -- lazy = true,
  -- priority = 1000,
  -- config = function()
  --   vim.g.sonokai_transparent_background = "1"
  --   vim.g.sonokai_enable_italic = "1"
  --   vim.g.sonokai_style = "andromeda"
  --   vim.cmd.colorscheme("sonokai")
  -- end,
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
}
