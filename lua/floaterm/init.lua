local M = {}
local api = vim.api
local utils = require "floaterm.utils"
local state = require "floaterm.state"
local volt = require "volt"
local volt_events = require "volt.events"
local volt_redraw = require("volt").redraw
local layout = require "floaterm.layout"

M.open = function()
  state.volt_set = true
  state.sidebuf = api.nvim_create_buf(false, true)
  state.barbuf = api.nvim_create_buf(false, true)

  local conf = state.config
  state.terminals = conf.terminals

  utils.gen_term_bufs()
  state.buf = state.buf or state.terminals[1].buf

  ----------- calculate h,w
  state.h = math.floor(vim.o.lines * (conf.size_h / 100))
  state.w = math.floor(vim.o.columns * (conf.size_w / 100))

  local sidebar_win_opts = {
    row = (vim.o.lines / 2 - state.h / 2) - 1,
    col = (vim.o.columns / 2 - state.w / 2),
    width = 20,
    height = state.h,
    relative = "editor",
    style = "minimal",
    border = "single",
    zindex = 100,
  }

  state.sidewin = api.nvim_open_win(state.sidebuf, true, sidebar_win_opts)

  local win_opts = {
    row = 3,
    col = 20 + 1,
    win = state.sidewin,
    width = state.w - 20,
    height = state.h - 2,
    relative = "win",
    style = "minimal",
    border = "none",
    zindex = 100,
  }

  api.nvim_win_set_hl_ns(state.sidewin, state.ns)

  local bar_win_opts = {
    row = -1,
    col = 20 + 1,
    win = state.sidewin,
    width = state.w - 20,
    height = 4,
    relative = "win",
    style = "minimal",
    border = "none",
    zindex = 100,
  }

  state.barwin = api.nvim_open_win(state.barbuf, false, bar_win_opts)
  vim.wo[state.barwin].winhl = "Normal:exdarkbg,FloatBorder:Exdarkborder"

  api.nvim_set_hl(state.ns, "FloatBorder", { link = "exblack2border" })
  api.nvim_set_hl(state.ns, "Normal", { link = "exblack2bg" })

  volt.gen_data {
    { buf = state.sidebuf, ns = state.ns, layout = layout.sidebar, xpad = 2 },
    { buf = state.barbuf, ns = state.ns, layout = layout.bar, xpad = 0 },
  }

  volt.run(state.sidebuf, { h = sidebar_win_opts.height, w = sidebar_win_opts.width })
  volt.run(state.barbuf, { h = 3, w = bar_win_opts.width })

  state.win = api.nvim_open_win(state.buf, true, win_opts)
  vim.wo[state.win].winhl = "Normal:ExDarkbg,FloatBorder:ExDarkBorder"
  utils.switch_buf(state.buf)

  volt_redraw(state.barbuf, "bar")

  volt.mappings { bufs = { state.buf, state.sidebuf, state.barbuf } }
  volt_events.add(state.sidebuf)

  require "floaterm.mappings"
end

M.toggle = function()
  if state.volt_set then
    api.nvim_win_close(state.win, false)
    api.nvim_win_close(state.barwin, false)
    api.nvim_win_close(state.sidewin, false)
    state.volt_set=false
  else
    M.open()
  end
end

return M
