vim.api.nvim_create_user_command("FloatermToggle", function()
  require("floaterm").toggle()
end, {})
