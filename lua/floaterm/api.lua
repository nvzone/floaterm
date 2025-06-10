local state = require "floaterm.state"
local utils = require "floaterm.utils"
local volt_redraw = require("volt").redraw
local M = {}

M.edit_name = function()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  vim.ui.input({ prompt = "   Enter name: " }, function(input)
    state.terminals[row].name = input
    vim.api.nvim_echo({}, false, {})
    volt_redraw(state.sidebuf, "bufs")
  end)
end

M.new_term = function(opts)
  local name

  if opts and opts.name then
    vim.ui.input({ prompt = "   Enter name: " }, function(input)
      name = input
      vim.api.nvim_echo({}, false, {})
    end)
  end

  local details = utils.new_term(name)
  table.insert(state.terminals, details)
  utils.switch_buf(details.buf)
  utils.add_keymap(#state.terminals, details.buf)
end

M.switch_wins = function()
  local curwin = vim.api.nvim_get_current_win()

  local newwin = curwin == state.win and "sidewin" or "win"
  vim.api.nvim_set_current_win(state[newwin])
end

return M
