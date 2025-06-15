local M = {
  ns = vim.api.nvim_create_namespace "Floaterm",
  terminals = nil,
  termbuf_session_timer = nil,
  bar_redraw_timeout = 10000,

  config = {
    border = false,
    size = { h = 60, w = 70 },

    terminals = {
      { name = "Terminal" },
      { name = "Terminal" },
      { name = "Terminal", cmd = "neofetch" },
    },
  },
}

return M
