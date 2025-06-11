local M = {}
local api = vim.api
local utils = require "floaterm.utils"
local state = require "floaterm.state"
local volt = require "volt"
local volt_redraw = require("volt").redraw
local layout = require "floaterm.layout"

M.open = function()
  state.volt_set = true
  state.sidebuf = api.nvim_create_buf(false, true)
  state.barbuf = api.nvim_create_buf(false, true)

  local conf = state.config
  local bordered = conf.border
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

  local colored_border = {
    { " ", "exdarkborder" },
    { "‾", "FloatSpecialBorder" },
    { " ", "exdarkborder" },
    { " ", "exdarkborder" },
    { " ", "exdarkborder" },
    { " ", "exdarkborder" },
    { " ", "exdarkborder" },
    { " ", "exdarkborder" },
  }

  local sidebar_w = 22

  local win_opts = {
    row = 2,
    col = sidebar_w + (bordered and 0 or -1),
    win = state.sidewin,
    width = state.w - sidebar_w,
    height = state.h - 3,
    relative = "win",
    style = "minimal",
    border = bordered and "single" or colored_border,
    zindex = 100,
  }

  api.nvim_win_set_hl_ns(state.sidewin, state.ns)

  local bar_win_opts = {
    row = -1,
    col = sidebar_w + (bordered and 0 or -1),
    win = state.sidewin,
    width = state.w - sidebar_w,
    height = 1,
    relative = "win",
    style = "minimal",
    border = "single",
    zindex = 100,
  }

  state.barwin = api.nvim_open_win(state.barbuf, false, bar_win_opts)

  if bordered then
    vim.wo[state.barwin].winhl = "Normal:normal,floatBorder:exred"
  else
    vim.wo[state.barwin].winhl = "Normal:exdarkbg,floatBorder:exdarkborder"
  end

  api.nvim_set_hl(state.ns, "floatBorder", { link = bordered and "comment" or "exblack2border" })
  api.nvim_set_hl(state.ns, "Normal", { link = bordered and "normal" or "exblack2bg" })

  volt.gen_data {
    { buf = state.sidebuf, ns = state.ns, layout = layout.sidebar, xpad = 1 },
    { buf = state.barbuf, ns = state.ns, layout = layout.bar, xpad = 0 },
  }

  volt.run(state.sidebuf, { h = sidebar_win_opts.height, w = sidebar_win_opts.width })
  volt.run(state.barbuf, { h = 1, w = bar_win_opts.width })

  state.win = api.nvim_open_win(state.buf, true, win_opts)

  if bordered then
    vim.wo[state.win].winhl = bordered and "Normal:normal,floatborder:comment"
  else
    vim.wo[state.win].winhl = "Normal:exdarkbg,floatBorder:exdarkborder"
  end

  utils.switch_buf(state.buf)

  volt_redraw(state.barbuf, "bar")

  volt.mappings { bufs = { state.buf, state.sidebuf, state.barbuf } }

  require "floaterm.mappings"
  require "floaterm.hl"()
end

M.toggle = function()
  if state.volt_set then
    api.nvim_win_close(state.win, false)
    api.nvim_win_close(state.barwin, false)
    api.nvim_win_close(state.sidewin, false)
    state.volt_set = false
  else
    M.open()
  end
end

return M
