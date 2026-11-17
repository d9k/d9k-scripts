require "nvchad.autocmds"

-- Visually highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = "YankHighlight", -- Группа подсветки (можно заменить на Visual или Search)
      -- higroup = "Todo", -- Группа подсветки (можно заменить на Visual или Search)
      timeout = 300,         -- Длительность вспышки в миллисекундах
    }
  end,
})
