local M = {
  ns = vim.api.nvim_create_namespace "Floaterm",
  terminals = {},
  termbuf_session_timer = nil,
  bar_redraw_timeout = 10000,

  config = {
    border = false,
    size_h = 60,
    size_w = 70,

    terminals = {
      { name = "SSH term" },
      { name = "terminal" },
      { name = "terminal", cmd = "neofetch" },
    },
  },
}

return M
