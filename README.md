# Floaterm

A beautiful toggleable floating window for managing terminal buffers within Neovim

![floaterm-with-border](https://github.com/user-attachments/assets/8a51aeff-dcc5-477f-a282-9b48a1e5bf2b)
![floaterm-noborder](https://github.com/user-attachments/assets/15e19849-69e6-432b-8fd9-7ffaad872e28)

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
