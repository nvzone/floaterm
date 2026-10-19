# Floaterm

A beautiful toggleable floating window for managing terminal buffers within Neovim

![floaterm-with-border](https://github.com/user-attachments/assets/8a51aeff-dcc5-477f-a282-9b48a1e5bf2b)
![floaterm-noborder](https://github.com/user-attachments/assets/15e19849-69e6-432b-8fd9-7ffaad872e28)


- Youtube video showcasing it : 

[![Watch on YouTube](https://markdown-videos-api.jorgenkh.no/url?url=https://www.youtube.com/watch?v=B8Ope3JbQ0I)](https://www.youtube.com/watch?v=B8Ope3JbQ0I)


## Install 

```lua 
{
    "nvzone/floaterm",
    dependencies = "nvzone/volt",
    opts = {},
    cmd = "FloatermToggle",
}          
```

## Default config

```lua
 {
    border = false,
    size = { h = 60, w = 70 },

    -- to use, make this func(buf)
    mappings = { sidebar = nil, term = nil},

    -- Default sets of terminals you'd like to open
    terminals = {
      { name = "Terminal" },
      -- cmd can be function too
      { name = "Terminal", cmd = "neofetch" },
      -- More terminals
    },
}
```

## Mappings

This are the mappings for sidebar 
- <kbd>a</kbd> -> add new terminal
- <kbd>e</kbd> -> edit terminal name
- Pressing any number within sidebar will switch to that terminal


Must be pressed in main terminal buffer
- <kbd>Ctrl + h</kbd> -> Switch to sidebar
- <kbd>Ctrl + j</kbd> -> Cycle to prev terminal
- <kbd>Ctrl + k</kbd> -> Cycle to next terminal

Add new mapping

```lua 
  {
     mappings = {
       term = function(buf)
         vim.keymap.set({ "n", "t" }, "<C-p>", function()
           require("floaterm.api").cycle_term_bufs "prev"
         end, { buffer = buf })
       end,
     },
  },
```
