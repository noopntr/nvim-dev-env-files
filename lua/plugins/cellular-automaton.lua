-- Make your code rain. Or simulate life.
-- :CellularAutomaton make_it_rain   → buffer dissolves into falling particles
-- :CellularAutomaton game_of_life   → Conway's game on your code
-- https://github.com/eandrju/cellular-automaton.nvim
return {
  {
    "eandrju/cellular-automaton.nvim",
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
      { "<leader>fgl", "<cmd>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },
}
