--auto scroll for you
vim.opt.scrolloff = 8

--add line number
vim.opt.nu = true

--add relative number
vim.opt.relativenumber = true

--add tab to 4spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

--remove swapfile
vim.opt.swapfile = false

--open help page at the bottem
vim.opt.splitbelow = true

--new split windows pop on the right
vim.opt.splitright = true

--ignore case sensitive when surching for word
vim.opt.ignorecase = true

--fix visual block mode hl
vim.opt.virtualedit = "block"

--activate 24bit image
vim.opt.termguicolors = true

vim.opt.smartindent = true

--setting up leader key
--let mapleader = " "

-- n = normal mode
-- nore = no recursive execution
-- map = map this keys to
-- pv = project view
-- nnoremap <leader>pv :Vex<CR>
-- source vimrc
-- nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
