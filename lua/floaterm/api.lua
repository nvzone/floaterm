local state = require "floaterm.state"
local utils = require "floaterm.utils"
local volt_redraw = require("volt").redraw
local M = {}

M.edit_name = function()
  local row = utils.get_buf_on_cursor()

  if row then
    vim.ui.input({ prompt = "   Enter name: " }, function(input)
      state.terminals[row].name = input
      vim.api.nvim_echo({}, false, {})
      volt_redraw(state.sidebuf, "bufs")
    end)
  end
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

M.cycle_term_bufs = function(direction)
  if not state.terminals or #state.terminals == 0 then
    return
  end

  local cur_index = utils.get_term_by_buf(state.buf)

  if not cur_index then
    -- If not in a terminal, switch to the first one
    utils.switch_buf(state.terminals[1].buf)
    return
  end

  local new_index = (cur_index[1] + (direction == "prev" and -2 or 0)) % #state.terminals
  utils.switch_buf(state.terminals[new_index + 1].buf)
end

M.delete_term = function(buf)
  local method = buf and "automatic" or "manual"

  if not buf then
    if #state.terminals == 1 then
      vim.notify "Close the whole window by pressing q in normal mode!"
      return
    end

    local i = utils.get_buf_on_cursor()
    if i then
      buf = state.terminals[i].buf
    end
  end

  if buf then
    local index = utils.get_term_by_buf(buf)[1]
    local newbuf_i = (index == 1 and index + 1) or index - 1
    utils.switch_buf(state.terminals[newbuf_i].buf)

    table.remove(state.terminals, index)

    if method == "manual" then
      vim.api.nvim_buf_delete(buf, { })
    end

    local total_lines = vim.api.nvim_buf_get_lines(state.sidebuf, 0, -1, false)

    vim.api.nvim_set_option_value("modifiable", true, { buf = state.sidebuf })
    require("volt").set_empty_lines(state.sidebuf, #total_lines, 20)
    vim.api.nvim_set_option_value("modifiable", true, { buf = state.sidebuf })

    volt_redraw(state.sidebuf, "all")
  end
end

return M
