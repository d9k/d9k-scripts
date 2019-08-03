-- Please CHECK Textadept version > 9.0 before apply config!

-- additional hotkeys:
--
--  alt + C :  copy file name (ctrl + alt + C too)
-- ctrl + L :  delete current line
-- ctrl + Y :  redo
-- ctrl + p :  switch buffer

if not CURSES then
  --   buffer:set_theme('base16-ocean-dark-mod', {
  ui.set_theme('base16-ocean-dark-mod', {
-- use  something like `fc-list | grep Terminus`
    font="Terminus", fontface="Regular", fontsize=10
--    font="Terminus (TTF)", fontface="Medium", fontsize=10
--    font="Terminus (TTF)", fontface="Medium", fontsize=12
  })
--, {
-- ['style.linenumber'] = 'fore:%(color.base07),back:%(color.base02)',
--}
  ui.size = {850, 550}
end

-- Deletes the lines spanned by the selection or delete current line if no selection.
function delete_lines()
  buffer:begin_undo_action()
  if buffer.selection_empty then
    buffer:line_delete()
  else
    local start_line = buffer:line_from_position(buffer.selection_start)
    local end_line = buffer:line_from_position(buffer.selection_end)
    local start_pos = buffer:position_from_line(start_line)
    local end_pos = buffer:position_from_line(end_line + 1)
    buffer:delete_range(start_pos, end_pos - start_pos)
  end
  buffer:end_undo_action()
end

-- keys.cy=delete_lines
-- ctrl+shift+z doesn't work on cinnamon!! why??

--keys['cq']=delete_lines
keys['cq']=ui.switch_buffer
keys['cy']=buffer.redo

keys['cp']=ui.switch_buffer

keys['ac'] = function()
  ui.clipboard_text=buffer.filename
end
keys['cac'] = keys['ac']

keys['cr'] = buffer.line_delete
keys['cl'] = textadept.file_types.select_lexer
keys['cj'] = textadept.editing.goto_line

textadept.editing.strip_trailing_spaces = true

events.connect(events.LEXER_LOADED, function(lexer)
  --if lexer == 'text' then buffer.wrap_mode = buffer.WRAP_CHAR end
  -- TODO test for crashes! recipe from http://narkive.com/RQaLA9Cb:5.990.120
  buffer.wrap_mode = buffer.WRAP_CHAR

--  buffer.tab_width = 4
  buffer.use_tabs = false
end)


-- layout-invariant shortcuts for russian layout
-- https://foicica.com/lists/code/201609/3325.html
local ru_codes = {
  1734, 1737, 1747, 1751, 1749, 1729,
  1744, 1746, 1755, 1743, 1740, 1732,
  1752, 1748, 1757, 1754, 1738, 1739,
  1753, 1733, 1735, 1741, 1731, 1758,
  1742, 1745
}

local en_code = 97

for k,v in pairs(ru_codes) do
  keys.KEYSYMS[v] = string.char(en_code)
  en_code = en_code + 1
end

events.connect(events.INITIALIZED, function()
 textadept.session.load(textadept.session.default_session)
end, 1)

-- moon lexer error!
--textadept.file_types.extensions.moon = nil
-- from https://github.com/leafo/moonscript-textadept
textadept.file_types.extensions.moon = "moonscript"
textadept.file_types.extensions.rockspec = "lua"

textadept.file_types.extensions.aliases = "bash"

textadept.editing.auto_pairs = nil

--textadept.menu.menubar[_L['_Tools']][_L['Command _Entry']][2] = function()
   --ui.command_entry.enter_mode('lua_command', 'lua', 2)
--end

events.connect(events.SUSPEND, function()
  buffer:undo()
  return true
end, 1)
