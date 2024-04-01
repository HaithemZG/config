require("blackrock.set")
require("blackrock.remap")
require("blackrock.lazy_init")

--remove auto comment newline
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})


--autocommand, variable, groups
local augroup = vim.api.nvim_create_augroup
local TheBlackrockGroup = augroup('Blackrock', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

--flash any text when you yank it
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

--Every time you're about to save a file
--It removes any trailing whitespace at the end of each line.
autocmd({"BufWritePre"}, {
    group = TheBlackrockGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})


--means this code executes automatically when
--a Language Server Protocol client attaches to a buffer
autocmd('LspAttach', {
    group = TheBlackrockGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        --Jumping to definitions
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        --Displays a floating window with documentation or type information about the symbol
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        --Allows you to search for symbols (functions, classes, etc.) across your entire project or workspace.
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        --Shows a floating window with detailed information about errors or warnings reported by your language server.
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        --Opens a context menu with suggested fixes, refactorings, or other actions provided by your language server.
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        --if your cursor is on a function name, pressing this keybind will list all places in your code where that function is used.
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        --this will allow you to rename the symbol under your cursor everywhere it's used within the scope
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        --show a popup with information about the function's parameters, their types, and the function's return type.
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        --Jumps to the next error or warning location reported by the language server.
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        --jumps to the previous error or warning location.
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

