-- Focus modes.
-- :ZenMode  → current buffer in a centered floating window, everything else dimmed
-- :Twilight → dim all code except the function/block you're inside
-- Hotkeys: <leader>z (zen), <leader>tw (twilight)
return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = 100, -- absolute cols, or a fraction like 0.85
        height = 1, -- fraction of screen
        options = {
          signcolumn = "no",
          number = true,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          list = false,
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
        },
        twilight = { enabled = true }, -- enable Twilight inside ZenMode
        gitsigns = { enabled = false },
        tmux = { enabled = true }, -- hide tmux status bar while zen
      },
    },
  },
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    keys = {
      { "<leader>tw", "<cmd>Twilight<CR>", desc = "Twilight (dim outside scope)" },
    },
    opts = {
      dimming = {
        alpha = 0.25, -- how dim the outside-scope text gets (0..1)
        inactive = false,
      },
      context = 10, -- lines of context around current scope
      treesitter = true,
      expand = { -- node types to consider "in scope"
        "function",
        "method",
        "table",
        "if_statement",
        "class",
      },
    },
  },
}
