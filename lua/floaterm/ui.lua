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
}

M.items = function()
  local terms = {}

  for i, v in ipairs(state.terminals) do
    local icon = "" .. "  "
    local label = icon .. (v.name or "New terminal") .. "    " .. num_icons[i]
    local hl = state.buf == v.buf and "ExGreen" or "Comment"
    local actions = {
      click = function()
        utils.switch_buf(v.buf)
      end,
    }
    table.insert(terms, { { label, hl, actions } })
  end

  return terms
end

M.bar = function()
  local w = state.w - 10

  local active_term = utils.get_term_by_buf(state.buf)
  local active_label = "    " .. active_term.name

  local bufname = vim.api.nvim_buf_get_name(state.buf)

  local line = {
    { active_label, "exdarkbg" },
    { "  " .. bufname .. " ", "Comment" },
    { "_pad_" },
    { "  " .. active_term.time, "exred" },
  }
  return {
    {},
    voltui.hpad(line, w),
    voltui.separator("_", w),
    {},
  }
end

return M
