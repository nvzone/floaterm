local api = vim.api
local get_hl = require("volt.utils").get_hl

return function()
  api.nvim_set_hl(0, "FloatSpecialBorder", { bg = get_hl("exdarkbg").bg, fg = get_hl("exred").fg })
end
