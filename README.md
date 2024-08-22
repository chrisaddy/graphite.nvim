# graphite.nvim
Work with Graphite CLI in Telescope neovim


## Installation and Setup

### Lazy

```lua
return {
  'chrisaddy/graphite.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('graphite').setup()
  end,
}
```
