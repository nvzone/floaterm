local M = {}

M.sidebar = {
  {
    lines = require("floaterm.ui").items,
    name = "bufs",
  },

  {
    lines = require("floaterm.ui").help,
    name = "help",
  }
}

M.bar = {
  {
    lines = require("floaterm.ui").bar,
    name = "bar",
  },
}

return M
