vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  -- USER ADDITIONS

  -- https://vi.stackexchange.com/questions/45151/how-do-i-resolve-no-parser-for-vimdoc-language-or-clean-my-installation/47108#47108
  -- { performance = { rtp = { reset = false } } }, -- turn runtime path reset off, this prevents runtime path messing }},

  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        --     keymaps = {
        -- -- `S{` - surround with {} with spaces
        -- -- `S}` - surround with {} without spaces
        --             visual = "S",
        })
    end
  },
  
  -- END USER ADDITIONS

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- USER ADDITIONS:

-- use OS clipboard
vim.g.clipboard = {
  name = 'xclip',
  copy = {
    ['+'] = {'xclip', '-selection', 'clipboard'},
    ['*'] = {'xclip', '-selection', 'primary'},
  },
  paste = {
    ['+'] = {'xclip', '-selection', 'clipboard', '-o'},
    ['*'] = {'xclip', '-selection', 'primary', '-o'},
  },
  cache_enabled = 1,
}

local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)
