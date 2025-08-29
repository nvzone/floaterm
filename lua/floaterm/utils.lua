local M = {}
local api = vim.api
local map = vim.keymap.set
local state = require "floaterm.state"
local volt_redraw = require("volt").redraw
local shell = vim.o.shell

M.convert_buf2term = function(cmd)
  if cmd then
    cmd = type(cmd) == "function" and cmd() or cmd
    cmd = { shell, "-c", cmd .. "; " .. shell }
  else
    cmd = { shell, "-i" }
  end
  vim.fn.jobstart(cmd, { term = true })
end

M.new_term = function(name)
  return {
    buf = api.nvim_create_buf(false, true),
    time = os.date "%H:%M",
    name = name or "Terminal",
  }
end

M.add_keymap = function(key, buf)
  map("n", tostring(key), function()
    M.switch_buf(buf)
  end, { buffer = state.sidebuf })
end

M.gen_term_bufs = function()
  for i, _ in ipairs(state.terminals) do
    state.terminals[i] = vim.tbl_extend("force", M.new_term(), state.terminals[i])
    local buf = state.terminals[i].buf
    M.add_keymap(i, buf)
  end
end

M.switch_buf = function(buf)
  state.buf = buf

  volt_redraw(state.sidebuf, "bufs")
  volt_redraw(state.barbuf, "bar")

  if not api.nvim_win_is_valid(state.win) then
    -- state.win = api.nvim_open_win(state.buf, true, state.term_win_opts)
  end

  api.nvim_set_current_win(state.win)
  api.nvim_set_current_buf(buf)

  local details = vim.tbl_filter(function(x)
    return x.buf == buf
  end, state.terminals)

  if vim.bo[buf].buftype ~= "terminal" then
    vim.bo[buf].ft = "Floaterm"
    M.convert_buf2term(details[1].cmd)
    volt_redraw(state.barbuf, "bar")

    map({ "t", "n" }, "<C-h>", function()
      require("floaterm.api").switch_wins()
    end, { buffer = state.buf })

    map({ "n", "t" }, "<C-j>", function()
      require("floaterm.api").cycle_term_bufs "next"
    end, { buffer = state.buf })

    map({ "n", "t" }, "<C-k>", function()
      require("floaterm.api").cycle_term_bufs "prev"
    end, { buffer = state.buf })

    require("volt").mappings {
      bufs = { state.buf, state.sidebuf, state.barbuf },
      after_close = function()
        M.close_timers()
        state.volt_set = false
        state.terminals = nil
        state.buf = nil
        state.sidebuf = nil
        state.barbuf = nil
        state.lastevent = nil
        api.nvim_del_augroup_by_name "FloatermAu"
      end,
    }

    api.nvim_create_autocmd("WinClosed", {
      buffer = state.buf,
      callback = function()
        state.lastevent = "winclosed"
      end,
    })

    if state.config.mappings.term then
      state.config.mappings.term(state.buf)
    end
  end

  vim.cmd.startinsert()
end

M.get_term_by_buf = function(buf)
  for i, v in ipairs(state.terminals) do
    if buf == v.buf then
      return { i, v }
    end
  end
end

M.get_buf_on_cursor = function()
  local row = vim.api.nvim_win_get_cursor(0)[1]

  if not state.terminals[row] then
    vim.notify("please place cursor on a valid terminal name!", vim.log.levels.WARN)
    return
  end

  return row
end

M.close_timers = function()
  state.bar_redraw_timer:stop()
  state.bar_redraw_timer:close()
  state.bar_redraw_timer = nil
end

return M
