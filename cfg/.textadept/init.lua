-- TODO read https://notabug.org/reback00/ta-config/src/master/init.lua
--
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

keys['cao']=ui.switch_buffer
keys['cp']=io.open_recent_file

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
 -- textadept.session.load(textadept.session.default_session)

 local default_session = textadept.session.default_session
 if not default_session then
   default_session = _USERHOME .. (not CURSES and '/session' or '/session_term')
 end

-- TODO fix crash!
-- textadept.session.load(default_session)
end, 1)

-- # File associations with lexers
-- moon lexer error!
--textadept.file_types.extensions.moon = nil
-- from https://github.com/leafo/moonscript-textadept
textadept.file_types.extensions.moon = "moonscript"
textadept.file_types.extensions.rockspec = "lua"

textadept.file_types.extensions.aliases = "bash"
textadept.file_types.extensions.zshrc = "bash"

textadept.editing.auto_pairs = nil
-- keys.csup = buffer.move_selected_lines_up
-- keys.csdown = buffer.move_selected_lines_down

keys.aR = { function()
  local events = events
  local gui = gui
  local KEYSYMS = _m.textadept.keys.KEYSYMS
    gui.statusbar_text = 'Rectangular selection'
    events.emit('update_ui')
    rselect = events.connect('keypress',
      function(code, shift, control, alt)
        if alt and KEYSYMS[code] == 'left' then
          buffer:char_left_rect_extend()
          return true
        elseif alt and KEYSYMS[code] == 'up' then
          buffer:line_up_rect_extend()
          return true
        elseif alt and KEYSYMS[code] == 'right' then
          buffer:char_right_rect_extend()
          return true
        elseif alt and KEYSYMS[code] == 'down' then
          buffer:line_down_rect_extend()
          return true
        else
          events.disconnect('keypress', rselect)
          gui.statusbar_text = ''
          events.emit('update_ui')
          return
         end
      end, 1)
end
}

--textadept.menu.menubar[_L['_Tools']][_L['Command _Entry']][2] = function()
   --ui.command_entry.enter_mode('lua_command', 'lua', 2)
--end

-- no ctrl+Z in cli mode
events.connect(events.SUSPEND, function()
  buffer:undo()
  return true
end, 1)

function table_keys(t)
  local result = {}

  for k, _ in pairs(t) do
    table.insert(result, k)
  end

  return result
end

function array_filter(ar)
  local result = {}
  for _, v in ipairs(ar) do
    if v then
      local new_index = #result+1
      result[new_index] = v
    end
  end
  return result
end

-- https://github.com/DracoBlue/DModule/blob/master/core/lua/utils.lua
function file_put_contents(path, content)
	local file = io.open(path,"w+")
	if (file) then
		file:write(content)
		file:close()
		return true
	end
	return false
end

-- https://stackoverflow.com/a/326715
function shell_cmd_run_and_get_output(cmd, raw)
  if type(cmd) == 'table' then
    cmd = table.concat(cmd, ' ')
  end

  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function require_selected_text()
  local sel_text, sel_text_len = buffer:get_sel_text()

  if sel_text_len < 1 then
    error({text= 'No selection'})
  end

  return sel_text
  end

function ensure_file_put_contents(filename, text)
  local saved = file_put_contents(filename, text)

  if not saved then
    error({text = "Can't save to " .. filename, filename = filename})
  end

  return saved
end

function statusbar_set_text_fn_factory(log_prefix)
  return function(text)
    ui.statusbar_text = table.concat(array_filter({log_prefix or false, text}), ": ")
end
end

function fn_error_to_status_bar(log_prefix, fn)
  local out = statusbar_set_text_fn_factory(log_prefix)

  local status, err = pcall(fn)

  if (err) then
    local error_text = type(err) == 'string' and err or err.text

    out(error_text)
  end
  end

function tmp_file_create(content)
  local tmp_filename = os.tmpname()
  ensure_file_put_contents(tmp_filename, content)
  return tmp_filename
end

function tmp_file_autoremove_callback(content, fn)
  local tmp_filename = tmp_file_create(content)
  fn(tmp_filename)
  os.remove(tmp_filename)
  return tmp_filename
end

function action_json_pp()
  fn_error_to_status_bar('json pp', function ()
    --local json_pp_script_path = '/home/d9k/scripts/php-json-pretty-deprecated'
    local jq_location = '/usr/bin/jq'

    local sel_text = require_selected_text()

    tmp_file_autoremove_callback(sel_text, function(tmp_filename)

      local cmd_output_text = shell_cmd_run_and_get_output(
        --{json_pp_script_path, tmp_filename},
        {jq_location, '"."', tmp_filename},
        true
      )

      buffer:replace_sel(cmd_output_text)
    end)
  end)
end

function action_sort_lines()
  fn_error_to_status_bar('sort_lines', function ()
    local script_path = '/home/d9k/scripts/php-sort-lines.php'

    local sel_text = require_selected_text()

    tmp_file_autoremove_callback(sel_text, function(tmp_filename)

      local cmd_output_text = shell_cmd_run_and_get_output(
        {script_path, tmp_filename},
        true
      )

      buffer:replace_sel(cmd_output_text)
    end)
  end)
end


function action_url_decode()
  fn_error_to_status_bar('url decode', function ()
    local script_path = '/home/d9k/scripts/php-url-decode'

    local sel_text = require_selected_text()

    tmp_file_autoremove_callback(sel_text, function(tmp_filename)

      local cmd_output_text = shell_cmd_run_and_get_output(
        {script_path, tmp_filename},
        true
      )

    buffer:replace_sel(cmd_output_text)
    end)
  end)
  end


function action_enclose_backticks()
  fn_error_to_status_bar('enclose backticks', function()
    local sel_text = require_selected_text()

  buffer:replace_sel('`' .. sel_text .. '`')
  end)
end

function action_enclose_backticks_multiline()
  fn_error_to_status_bar('enclose backticks multiline', function()
    local sel_text = require_selected_text()

    buffer:replace_sel("```\n" .. sel_text .. "\n```")
  end)
end

function action_add_demarcation_line()
  local _prefix = 'add_demarcation_line: '
  buffer:home()

  local AT_CARET = -1
  buffer:insert_text(AT_CARET, "\n" .. string.rep('-', 45) .. "\n\n")
  --buffer:replace_sel("```\n" .. sel_text .. "\n```")
end

local menu_tools = textadept.menu.menubar[_L['_Tools']]

local SEPARATOR = {''}

menu_tools[#menu_tools + 1] = SEPARATOR
menu_tools[#menu_tools + 1] = {'Add demarcation ----- line before', action_add_demarcation_line}
menu_tools[#menu_tools + 1] = {'JSON pretty print', action_json_pp}
menu_tools[#menu_tools + 1] = {'Enclose backticks', action_enclose_backticks}
menu_tools[#menu_tools + 1] = {'Enclose backticks multiline', action_enclose_backticks_multiline}
menu_tools[#menu_tools + 1] = {'Sort lines', action_sort_lines}
menu_tools[#menu_tools + 1] = {'Url decode', action_url_decode}

--keys.ad = enclose_backticks
--keys.aD = enclose_backticks_multiline
-- alt + x
keys.aq = action_enclose_backticks

-- alt + shift + x
--keys.aQ = enclose_backticks_multiline
keys.aa = action_enclose_backticks_multiline

--next view
keys.an = function()
  ui.goto_view(1)
end

keys.aw = function()
  ui.goto_view(1)
end

-- ctrl + shift + =
keys['c+'] = action_add_demarcation_line
