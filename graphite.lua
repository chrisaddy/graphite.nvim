return {
  'chrisaddy/graphite.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('graphite').setup()
  end,
}
