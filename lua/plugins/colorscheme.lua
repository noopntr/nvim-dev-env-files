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
    priority = 1001,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = function()
  --     return {
  --       transparent = true,
  --     }
  --   end,
  -- },
  -- {
  --   "oxfist/night-owl.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = function()
  --     return {
  --       transparent = true,
  --     }
  --   end,
  -- },
}
