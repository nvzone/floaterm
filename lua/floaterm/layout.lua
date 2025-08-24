local M = {}

M.sidebar = {
  {
    lines = require("floaterm.ui").items,
    name = "bufs",
  },
}

M.bar = {
  {
    lines = require("floaterm.ui").bar,
    name = "bar",
  },
}

return M
