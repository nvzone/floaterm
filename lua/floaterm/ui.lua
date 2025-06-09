local M = {}
local state = require "floaterm.state"
local utils = require "floaterm.utils"

M.items = function()
  local terms = {}

  for _, v in ipairs(state.terminals) do
    local icon = "" .. "  "
    local label = icon .. (v.name or "New terminal")
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

return M
