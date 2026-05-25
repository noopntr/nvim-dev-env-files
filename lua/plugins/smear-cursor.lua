-- Smooth, async cursor animation for every move (including hjkl).
-- https://github.com/sphamba/smear-cursor.nvim
return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Fast cursor + visible white trail, low render cost
      stiffness = 0.9,
      trailing_stiffness = 0.5,         -- moderate trail (was 0.25 = too heavy to render)
      stiffness_insert_mode = 0.9,
      trailing_stiffness_insert_mode = 0.6,
      damping = 0.85,
      damping_insert_mode = 0.85,
      distance_stop_animating = 0.3,
      hide_target_hack = false,

      -- Visual — white trail
      cursor_color = "#ffffff",
      transparent_bg_fallback_color = "#1a1a2e",
      legacy_computing_symbols_support = false,  -- tmux doesn't render these well
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = false,         -- don't smear while typing (was causing lag)
      gamma = 2.2,
      -- max_kept_writes removed — was forcing 100 trail cells per frame
    },
  },
}
