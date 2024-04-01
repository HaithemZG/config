return {
  "navarasu/onedark.nvim",
  config = function()
    require('onedark').setup({
      style = 'warm',
      colors = {
        fg = "#fcfdff",
        light_grey = "#fcfdff",
      },
    })
        vim.cmd("colorscheme onedark")
  end
}
