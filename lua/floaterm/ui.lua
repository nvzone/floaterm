local M = {}
local state = require "floaterm.state"
local utils = require "floaterm.utils"
local voltui = require "volt.ui"

local num_icons = {
  -- '󰎡',
  "󰎤",
  "󰎧",
  "󰎪",
  "󰎭",
  "󰎱",
  "󰎳",
  "󰎶",
  "󰎹",
  "󰎼",
}

M.items = function()
  local terms = {}

  for i, v in ipairs(state.terminals) do
    local icon = "" .. "  "
    local label = icon .. (v.name or "Terminal")
    local hl = state.buf == v.buf and "ExGreen" or "Comment"
    local actions = {
      click = function()
        utils.switch_buf(v.buf)
      end,
    }
    local line = { { label, hl, actions }, { "_pad_" }, { num_icons[i] or tostring(i), hl } }
    table.insert(terms, voltui.hpad(line, 18))
  end

  return terms
end

M.bar = function()
  local w = state.w - 20 - 2

  local active_term = utils.get_term_by_buf(state.buf)[2]
  local active_label = "  " .. active_term.name

  local bytes = vim.api.nvim_buf_get_offset(state.buf, vim.api.nvim_buf_line_count(state.buf)) - 1

  local line = {
    { active_label, "xdarkbg" },
    { "_pad_" },
    { string.format("   %.1f MB ", bytes / (1024 * 1024)), "exgreen" },
    { "   " .. active_term.time, "exred" },
    { "  " .. math.floor(active_term.secs / 60) .. " MIN", "" },
  }
  return {
    voltui.hpad(line, w),
  }
end

M.help = function()
  local lines = {
    voltui.separator("-", 18),
    { { "a - add", "comment" }, { "  e - edit", "comment" } },
  }

  local empty_lines_to_fill = state.h - #state.terminals - #lines

  for _ = 1, empty_lines_to_fill, 1 do
    table.insert(lines, 1, {})
  end

  return lines
end

return M
