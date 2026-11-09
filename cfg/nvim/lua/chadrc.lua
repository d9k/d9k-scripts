-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	-- theme = "onedark",
  theme = "chadtain",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },

    changed_themes = {
        ["chadtain"] = {
      base_30 = {
        -- sun = "#FF0000"
      },
			base_16 = {
        -- back
				base00 = "#000000",
        -- keys, vars
         base08 = "#c38a8c",
        -- numeric
        --base09 = "#ff0000",
        -- operators
        -- base05 = "#ff0000",
        -- brown ids
        base0A = "#d0a06a",
        -- base05 = "#050507"
				-- base01 = "#000000",
				-- base02 = "#000000",
			},
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
-- }

return M
