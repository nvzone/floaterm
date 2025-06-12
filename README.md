# Floaterm

A toggleable floating window for managing terminal buffers within Neovim

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
