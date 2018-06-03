--[[--
  Use this file to specify **User** preferences.
  Review [examples](+/opt/zbstudio/cfg/user-sample.lua) or check [online documentation](http://studio.zerobrane.com/documentation.html) for details.
--]]--

-- TODO why not required?
-- require 'luarocks.loader'

-- DO luarocks install penlight
-- see https://stevedonovan.github.io/Penlight/api/libraries/pl.path.html
local pl_path = require 'pl.path'

script_path = debug.getinfo(1,'S').source
script_name = pl_path.basename (script_path)
if string.sub(script_path, 1, 1) == '@' then
    script_path = string.sub(script_path, 2)
end
script_path = pl_path.abspath(script_path)
script_dir = pl_path.dirname(script_path)
package.path = script_dir..'/?.lua;'..package.path
package.cpath = script_dir..'/сmodules/?.dll;'..script_dir..'./сmodules/?.so;'..package.cpath

local helpers = require 'config_helpers'
local H = require 'config_helpers'.H


styles = loadfile('cfg/tomorrow.lua')('TomorrowNight')
stylesoutshell = styles -- apply the same scheme to Output/Console windows
styles.auxwindow = styles.text -- apply text colors to auxiliary windows
styles.calltip = styles.text -- apply text colors to tooltips

styles.sel.bg = H'5A446C'
--style.text.fg = H'c5c8c6'
styles.text.fg = H'D8DBDA'
--styles.sel = {bg = 0x392B48} -- reverse 16 bit order

--styles.sel = {bg = H'482B39'} -- selection color

-- to change font size to 12
editor.fontsize = 12 -- this is mapped to ide.config.editor.fontsize
editor.fontname = "Terminus (TTF)"
editor.autoactivate = true
filehistorylength = 100 -- this is mapped to ide.config.filehistorylength

-- https://github.com/pkulchenko/ZeroBraneStudio/blob/master/src/editor/keymap.lua
keymap[ID.STEP] = "F11"
keymap[ID.STEPOVER] = "F10"
keymap[ID.COMMENT] = "Ctrl-/"
-- prevent exit on accidental Ctrl-Q press
keymap[ID.EXIT] = "Ctrl-Shift-Q"

-- see https://github.com/pkulchenko/ZeroBraneStudio/issues/855
-- filetree.confirm_mousemove
package {
  onFiletreeFilePreRename = function(self, tree, itemsrc, source, target)
    return wx.wxMessageBox(("Do you want to move '%s' to '%s'?"):format(source, target),
      "Move/Rename file", wx.wxYES_NO + wx.wxCENTRE, ide:GetMainFrame()) == wx.wxYES
  end
};

(...).colorize = function (lexer_name)
  lexer_name = lexer_name or 'lua'
  ide:GetEditor():SetupKeywords(lexer_name)
end
