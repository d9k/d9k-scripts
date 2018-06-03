#!env lua

local require_or_install = function (require_string, package_name, package_version)
  package_name = package_name or require_string

  -- TODO multiple returns (require_string as array)

  result, err_or_result = pcall(function()
    return require(require_string)
  end)

  if result then
    return err_or_result
  end

  local install_command = 'luarocks install ' .. package_name

  if package_version then
    install_command = install_command .. ' ' .. package_version
  end

  print('Installing missing rock ' .. package_name .. '...')
  print('+ ' .. install_command)
  --local command_output = os.execute(install_command)
  local process_handle = io.popen(install_command)
  local command_output = process_handle:read("*a")
  process_handle:close()
  print(command_output)

  return require(require_string)
end

local requests = require_or_install('requests', 'lua-requests')
local url_encode = require_or_install('net.url', 'net-url').buildQuery
local argparse = require_or_install('argparse')
--local pretty_format = require_or_install('inspect')
local pretty_format = require_or_install('serpent').block

local json = require_or_install('cjson', 'lua-cjson')

local _pretty_json = require_or_install('resty.prettycjson', 'lua-resty-prettycjson')

local pretty_json = function (object)
  return _pretty_json(object, "\n", "  ")
end

local URL_GOOGLE_TRANSLATE_API = 'https://translation.googleapis.com/language/translate/v2'
local GOOGLE_API_KEY_FILENAME = '.google_translate_api_key'

local debug_print_enabled  = false

local debug_print = function (...)
  if debug_print_enabled then
    print(...)
  end
end

local parse_args = function ()
  local args_parser = argparse()
  args_parser:argument('from_language')
  args_parser:argument('to_language')
  args_parser:argument('string_to_translate'):args('1+')
  args_parser:flag('-d --debug')
  return args_parser:parse()
end

local args = parse_args()

debug_print_enabled = args.debug

--print(pretty_format(args_parser))

for arg_name, _arg in pairs(args) do debug_print(arg_name .. ': ' .. pretty_json(_arg)) end

local string_to_translate = table.concat(args.string_to_translate, ' ')

debug_print('string to translate: ' .. string_to_translate)

local get_api_key_file_path = function ()
  local home_dir_path = os.getenv('HOME')
  if not home_dir_path then
    print("home path can't be detected!")
  end
  local api_key_file_path = home_dir_path .. '/' .. GOOGLE_API_KEY_FILENAME
  return api_key_file_path
end

local get_api_key = function ()
  local api_key_file_path = get_api_key_file_path()

end

local api_key = get_api_key()

local function try_parse_json_result (json_result, url)
  url = url or ''
  local status, err_or_result = pcall(function ()
    return json.decode(json_result)
  end)

  if not status then
    print('Error: ' .. err_or_result)
    print("\n" .. 'Request result text:' .. "\n")
    print(json_result)
    print('Url requested: ' .. url)
    error('Result is not json!' .. "\n")
    os.exit(1)
  end

  return err_or_result
end

local do_json_request = function (url_args, verb)
  verb = verb or 'get'

  local url = URL_GOOGLE_TRANSLATE_API .. '/?' .. url_encode(url_args)

  local requests_function_args = {
    url = url,
  }

  local response = requests[verb](requests_function_args)

  local result = try_parse_json_result(response.text, url)

  return result, url
end

-- @see https://cloud.google.com/translate/docs/reference/translate
local url_args = {
  -- The input text to translate.
  q = string_to_translate,
  -- The language to use for translation of the input text
  target = args.to_language,
  -- The language of the source text
  source = args.from_language,
}

local request_result = do_json_request(url_args, 'post')
print(pretty_json(request_result))


