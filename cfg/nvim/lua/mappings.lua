require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map('n', '<C-e>', '<C-u>')

map('n', 'c', '"_c')
map('n', 'x', '"_x')

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
