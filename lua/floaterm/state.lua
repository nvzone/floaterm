local M = {
  ns = vim.api.nvim_create_namespace "Floaterm",
  terminals = {},

  config = {
    size_h = 60,
    size_w = 70,

    terminals = {
      { name = "terminal" },
      { name = "terminal" },
      { name = "terminal", cmd = "neofetch" },
    },
  },
}

return M
