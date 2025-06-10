local map = vim.keymap.set
local state = require "floaterm.state"
local api = require "floaterm.api"

map("n", "e", api.edit_name, { buffer = state.sidebuf })
map("n", "a", api.new_term, { buffer = state.sidebuf })
map("t", "<C-x>", api.switch_wins, { buffer = state.buf })
map("n", "<C-x>", api.switch_wins, { buffer = state.sidebuf })
