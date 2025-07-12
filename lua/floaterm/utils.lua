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
    cmd = { shell }
  end
  vim.fn.jobstart(cmd, { detach = false, term = true })
end

M.new_term = function(name)
  return {
    buf = api.nvim_create_buf(false, true),
    time = os.date "%H:%M",
    name = name or "Terminal",
    secs = 0,
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
  vim.schedule(function()
    api.nvim_set_current_win(state.win)
    api.nvim_set_current_buf(buf)

    local details = vim.tbl_filter(function(x)
      return x.buf == buf
    end, state.terminals)

    if vim.bo[buf].buftype ~= "terminal" then
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
        end,
      }

      if state.config.mappings.term then
        state.config.mappings.term(state.buf)
      end
    end

    M.add_term_buf_timer(buf)

    if state.config.autoinsert then
      vim.cmd.startinsert()
    end
  end)
end

M.get_term_by_buf = function(buf)
  for i, v in ipairs(state.terminals) do
    if buf == v.buf then
      return { i, v }
    end
  end
end

M.add_term_buf_timer = function(buf)
  if state.termbuf_session_timer then
    state.termbuf_session_timer:stop()
    state.termbuf_session_timer:close()
  end

  state.termbuf_session_timer = vim.uv.new_timer()

  local i = M.get_term_by_buf(buf)[1]

  state.termbuf_session_timer:start(
    0,
    1000,
    vim.schedule_wrap(function()
      state.terminals[i].secs = state.terminals[i].secs + 1
    end)
  )
end

M.close_timers = function()
  state.termbuf_session_timer:stop()
  state.termbuf_session_timer:close()
  state.termbuf_session_timer = nil
  state.bar_redraw_timer:stop()
  state.bar_redraw_timer:close()
  state.bar_redraw_timer = nil
end

return M
