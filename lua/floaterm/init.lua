local M = {}
local api = vim.api
local utils = require "floaterm.utils"
local state = require "floaterm.state"
local volt = require "volt"
local volt_redraw = require("volt").redraw
local layout = require "floaterm.layout"

M.setup = function(opts)
  state.config = vim.tbl_deep_extend("force", state.config, opts or {})
end

M.open = function()
  state.volt_set = true
  state.sidebuf = state.sidebuf or api.nvim_create_buf(false, true)
  state.barbuf = state.barbuf or api.nvim_create_buf(false, true)
  state.prev_win_focussed = api.nvim_get_current_win()

  local conf = state.config
  local bordered = conf.border
  local usr_terms = type(conf.terminals) == "table" and conf.terminals or conf.terminals()
  state.terminals = state.terminals or vim.tbl_deep_extend("force", {}, usr_terms)

  utils.gen_term_bufs()
  state.buf = state.buf or state.terminals[1].buf

  ----------- calculate h,w
  state.h = math.floor(vim.o.lines * (conf.size.h / 100))
  state.w = math.floor(vim.o.columns * (conf.size.w / 100))

  local sidebar_w = 20

  local sidebar_win_opts = {
    row = (vim.o.lines / 2 - state.h / 2) - 1,
    col = (vim.o.columns / 2 - state.w / 2),
    width = sidebar_w,
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

  local win_opts = {
    row = 2,
    col = sidebar_w + (bordered and 2 or 1),
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
    col = sidebar_w + (bordered and 2 or 1),
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
    { buf = state.barbuf, ns = state.ns, layout = layout.bar, xpad = 1 },
  }

  api.nvim_set_option_value("modifiable", true, { buf = state.sidebuf })
  api.nvim_set_option_value("modifiable", true, { buf = state.barbuf })

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

  require "floaterm.mappings"()
  require "floaterm.hl"()

  state.bar_redraw_timer = vim.uv.new_timer()

  state.bar_redraw_timer:start(
    0,
    state.bar_redraw_timeout,
    vim.schedule_wrap(function()
      volt_redraw(state.barbuf, "bar")
    end)
  )

  vim.bo[state.sidebuf].ft = "FloatermSidebar"
end

M.toggle = function()
  if state.volt_set then
    api.nvim_win_close(state.win, false)
    api.nvim_win_close(state.barwin, false)
    api.nvim_win_close(state.sidewin, false)
    utils.close_timers()
    state.volt_set = false
    api.nvim_set_current_win(state.prev_win_focussed)
  else
    M.open()
  end
end

return M
