# Floaterm (WIP)

A toggleable floating window for managing terminal buffers within Neovim

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
    size_h = 60,
    size_w = 70,

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

- <kbd>a</kbd> -> add new terminal
- <kbd>e</kbd> -> edit terminal name
- <kbd>Ctrl + h</kbd> -> Switch to sidebar (which has terminal names listed)
- Pressing any number within sidebar will switch to that terminal
