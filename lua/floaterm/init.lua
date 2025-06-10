local M = {}
local api = vim.api
local utils = require "floaterm.utils"
local state = require "floaterm.state"
local volt = require "volt"
local volt_events = require "volt.events"
local layout = require "floaterm.layout"

M.open = function()
  state.sidebuf = api.nvim_create_buf(false, true)
  state.barbuf = api.nvim_create_buf(false, true)

  local conf = state.config
  state.terminals = conf.terminals

  utils.gen_term_bufs()
  state.buf = state.terminals[1].buf

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

  local sidewin = api.nvim_open_win(state.sidebuf, true, sidebar_win_opts)

  local win_opts = {
    row = 2,
    col = 20 + 1,
    win = sidewin,
    width = state.w - 20,
    height = state.h - 3,
    relative = "win",
    style = "minimal",
    border = "single",
    zindex = 100,
  }

  api.nvim_win_set_hl_ns(sidewin, state.ns)

  local bar_win_opts = {
    row = -1,
    col = 20 + 1,
    win = sidewin,
    width = state.w - 18,
    height = 3,
    relative = "win",
    style = "minimal",
    border = "none",
    zindex = 100,
  }

  local bar_win = api.nvim_open_win(state.barbuf, false, bar_win_opts)
  vim.wo[bar_win].winhl = "Normal:exblack2bg,FloatBorder:Exblack2border"

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
  vim.cmd.startinsert()

  volt.mappings { bufs = { state.buf, state.sidebuf, state.barbuf } }
  volt_events.add(state.sidebuf)
end

return M
