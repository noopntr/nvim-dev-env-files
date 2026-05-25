-- Idle screensaver: kicks in after 2 minutes of no activity.
-- Wakes on any keypress. Cycles between matrix rain and dvd bouncer.
-- https://github.com/tamton-aquib/zone.nvim
return {
  {
    "tamton-aquib/zone.nvim",
    event = "VeryLazy",
    opts = {
      style = "epilepsy", -- "epilepsy" | "treadmill" | "dvd" | "vanish"
      after = 30, -- seconds of inactivity before zoning out
      exclude_filetypes = {
        "TelescopePrompt",
        "NvimTree",
        "neo-tree",
        "lazy",
        "mason",
        "lspinfo",
        "checkhealth",
        "help",
      },
      treadmill = {
        direction = "left", -- "left" or "right"
        headache = true, -- adds a subtle flicker
      },
      dvd = {
        text = { " N E O V I M ", "(idle)" },
      },
    },
  },
}
