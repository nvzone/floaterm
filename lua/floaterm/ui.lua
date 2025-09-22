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
  local lines = {}

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
    table.insert(lines, voltui.hpad(line, 18))
  end

  -- 2 cuz 2 lines for help keymaps
  local empty_lines_to_fill = state.h - #lines - 2

  for _ = 1, empty_lines_to_fill, 1 do
    table.insert(lines, { })
  end

  table.insert(lines, voltui.separator("-", 18))
  table.insert(lines, { { "a - add", "comment" }, { "  e - edit", "comment" } })

  return lines
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
  }
  return {
    voltui.hpad(line, w),
  }
end

return M
