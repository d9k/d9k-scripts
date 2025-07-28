require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map('n', '<C-e>', '<C-u>')

map('n', 'c', '"_c')
map('n', 'x', '"_x')

map('n', '<leader>d', 'kdd', { desc = 'delete line above'})

-- For this need to remap:
-- /home/d9k/.local/share/nvim/lazy/NvChad/lua/nvchad/configs/lspconfig.lua
-- map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
map('n', '<leader>D', 'jdd', { desc = 'delete line below'})

map('n', '<A-m>', '}}{j', { desc = 'next text block'})
map('n', '<A-n>', '{{j', { desc = 'previous text block'})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
