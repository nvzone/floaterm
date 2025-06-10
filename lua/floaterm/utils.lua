local M = {}
local api = vim.api
local state = require "floaterm.state"
local volt_redraw = require("volt").redraw
local shell = vim.o.shell

M.convert_buf2term = function(cmd)
  if cmd then
    cmd = { shell, "-c", cmd .. "; " .. shell }
  else
    cmd = { shell }
  end
  vim.fn.jobstart(cmd, { detach = false, term = true })
end

M.new_term = function(name)
  return {
    buf = api.nvim_create_buf(false, true),
    time = os.date "%H:%M",
    name = name or "Terminal",
  }
end

M.gen_term_bufs = function()
  for i, _ in ipairs(state.terminals) do
    state.terminals[i] = vim.tbl_extend("force", M.new_term(), state.terminals[i])
  end
end

M.switch_buf = function(buf)
  state.buf = buf
  volt_redraw(state.sidebuf, "bufs")
  volt_redraw(state.barbuf, "bar")
  api.nvim_set_current_win(state.win)
  api.nvim_set_current_buf(buf)

  local details = vim.tbl_filter(function(x)
    return x.buf == buf
  end, state.terminals)

  if vim.bo[buf].buftype ~= "terminal" then
    M.convert_buf2term(details[1].cmd)
  end

  vim.wo.scl = "yes"
end

M.get_term_by_buf = function(buf)
  for _, v in ipairs(state.terminals) do
    if buf == v.buf then
      return v
    end
  end
end

return M
