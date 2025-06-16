local map = vim.keymap.set
local state = require "floaterm.state"
local api = require "floaterm.api"

return function()
  map("n", "e", api.edit_name, { buffer = state.sidebuf })
  map("n", "a", api.new_term, { buffer = state.sidebuf })

  if state.config.mappings.sidebar then
    state.config.mappings.sidebar(state.sidebuf)
  end
end
