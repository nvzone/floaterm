local M = {
  ns = vim.api.nvim_create_namespace "Floaterm",
  terminals = nil,
  termbuf_session_timer = nil,
  bar_redraw_timeout = 10000,
  prev_win_focussed = 0,

  config = {
    border = false,
    size = { h = 60, w = 70 },
    -- must be functions
    mappings = { sidebar = nil, term = nil },
    terminals = {
      { name = "Terminal", cmd="fetch" },
      { name = "Git" },
      { name = "Terminal" , cmd='neofetch'},
    },
  },
}

return M
