local helpers = {}

function helpers.h2d(n) return 0+('0x'..n) end
function helpers.H(c, bg) c = c:gsub('#','')
  -- since alpha is not implemented, convert RGBA to RGB
  -- assuming 0 is transparent and 255 is opaque
  -- based on http://stackoverflow.com/a/2645218/1442917
  local bg = bg and helpers.H(bg) or {255, 255, 255}
  local a = #c > 6 and helpers.h2d(c:sub(7,8))/255 or 1
  local r, g, b = helpers.h2d(c:sub(1,2)), helpers.h2d(c:sub(3,4)), helpers.h2d(c:sub(5,6))
  return {
    math.min(255, math.floor((1-a)*bg[1]+a*r)),
    math.min(255, math.floor((1-a)*bg[2]+a*g)),
    math.min(255, math.floor((1-a)*bg[3]+a*b))}
end


return helpers
