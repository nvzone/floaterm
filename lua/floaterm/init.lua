local M = {}
local api = vim.api
local state = require "floaterm.state"
local volt = require "volt"
local voltstate = require "volt.state"
local volt_events = require "volt.events"
local layout = require "floaterm.layout"

M.open = function()
  local buf = api.nvim_create_buf(false, true)
  local sidebuf = api.nvim_create_buf(false, true)

  ----------- calculate h,w

  state.h = math.floor(vim.o.lines * (state.size / 100))
  state.w = math.floor(vim.o.columns * (state.size / 100))

  vim.print((vim.o.columns/2)-state.w/2)
  
  local sidebar_win_opts = {
    row = vim.o.lines/2-  state.h/2 -1,
    col =vim.o.columns/2- state.w/2,
    width = 20,
    height = state.h,
    relative = "editor",
    style = "minimal",
    border = "single",
    zindex = 100,
  }


  local sidewin = api.nvim_open_win(sidebuf, true, sidebar_win_opts)

  local win_opts = {
    row=-1,col=20,

    win = sidewin,
    width = state.w-20,
    height = state.h,
    relative = "win",
    style = "minimal",
    border = "single",
    zindex = 100,
  }


  local win = api.nvim_open_win(buf, true, win_opts)

  vim.wo[win].winhl = "Normal:ExDarkbg,FloatBorder:ExDarkBorder"

  api.nvim_win_set_hl_ns(sidewin, state.ns)

  api.nvim_set_hl(state.ns, "FloatBorder", { link = "exblack2border" })
  api.nvim_set_hl(state.ns, "Normal", { link = "exblack2bg" })

  volt.gen_data {
    { buf = sidebuf, ns = state.ns, layout = layout, xpad = 2 },
  }

  volt.run(sidebuf, { h = sidebar_win_opts.height, w = sidebar_win_opts.width })
  volt.mappings { bufs = { buf, sidebuf } }
end

return M
