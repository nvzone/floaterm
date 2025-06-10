local M = {}
local state = require "floaterm.state"
local utils = require "floaterm.utils"

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
  local w = state.w - 18

  local active_term = utils.get_term_by_buf(state.buf)

  local active_index = vim.fn.index( state.terminals, active_term)

  local active_numicon =   "  " .. num_icons[active_index+1] .. "  "
  local active_label = "    " .. active_term.name ..  active_numicon


  local active_w = vim.api.nvim_strwidth(active_label)

  local empty_line = {
    { string.rep(" ", active_w), "exdarkbg" },
    { string.rep(" ", w - active_w), "exblack2bg" },
  }

  return {
    empty_line,
    {
      { active_label, "exdarkbg" },
    },
    empty_line,
  }
end

return M
