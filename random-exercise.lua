#!/usr/bin/env lua
-- needs luacoket module:
-- `sudo luarocks install luasocket`

exercises=[[
отжимания, 5 раз
мостик, 8 секунд
приседания, 5 раз
пресс, 6 раз
подтягивания, 2 раза
берёзка, 8 секунд
]]

function split(str)
  local result = {}
  for line in str:gmatch("[^\r\n]+") do
    table.insert(result, line)
  end
  -- return string.gmatch(str, "%S+")
  return result
end

-- for debug
-- https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
function print_r (t)
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

local exercisesTable = split(exercises)
-- for debug:
-- print_r(exercisesTable)

local socket = require("socket")
local time = socket.gettime()*10000

math.randomseed(time)
print(exercisesTable[math.random(#exercisesTable)])
