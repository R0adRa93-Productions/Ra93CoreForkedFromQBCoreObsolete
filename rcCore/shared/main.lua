local stringCharset = {}
local numberCharset = {}

for k = 0, 165 do
 Ra93Shared.maleNoGloves[k] = true
 Ra93Shared.femaleNoGloves[k] = true
end
for i = 48, 57 do numberCharset[#numberCharset + 1] = string.char(i) end
for i = 65, 90 do stringCharset[#stringCharset + 1] = string.char(i) end
for i = 97, 122 do stringCharset[#stringCharset + 1] = string.char(i) end

Ra93Shared = {
 ["gangs"] = {},
 ["items"] = {},
 ["jobs"] = {},
 ["locations"] = {},
 ["vehicles"] = {},
 ["weapons"] = {},
 ["randomStr"] = function(length)
  if length <= 0 then return '' end
  return ("%d%s"):format(Ra93Shared.randomStr(length - 1), stringCharset[math.random(1, #stringCharset)])
 end,
 ["randomInt"] = function(length)
  if length <= 0 then return '' end
  return ("%d%d"):format(Ra93Shared.randomInt(length - 1), numberCharset[math.random(1, #numberCharset)])
 end,
 ["splitStr"] = function(str, delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(str, delimiter, from)
  while delim_from do
   result[#result + 1] = string.sub(str, from, delim_from - 1)
   from = delim_to + 1
   delim_from, delim_to = string.find(str, delimiter, from)
  end
  result[#result + 1] = string.sub(str, from)
  return result
 end,
 ["trim"] = function(value)
  if not value then return nil end
  return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
 end,
 ["firstToUpper"] = function(value)
  if not value then return nil end
  return (value:gsub("^%l", string.upper))
 end,
 ["round"] = function(value, numDecimalPlaces)
  if not numDecimalPlaces then return math.floor(value + 0.5) end
  local power = 10 ^ numDecimalPlaces
  return math.floor((value * power) + 0.5) / (power)
 end,
 ["copyTable"] = function(t)
  local u = {}
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
 end,
 ["concatenateTable"] = function(tab, template)
  template = template or "%s "
  local tt = {}
  for _, v in pairs(tab) do
   tt[#tt+1] = template:format(v)
  end
  return table.concat(tt)
 end,
 ["tableContains"] = function(tbl, val)
  for k, v in pairs(tbl) do
   if val == v then return k end
  end
  return false
 end,
 ["groupDigits"] = function(value, currency)
  local left, num, right = string.match(value, "^([^%d]*%d)(%d*)(.-)$")
  if currency then return ("%s%d%d"):format(Ra93Core.location.currency.symbol, left(num:reverse():gsub("(%d%d%d)","%1,"):reverse()), right) end
  return false
 end,
 ["setVehicleExtras"] = function(vehicle, extras)
  local ex
  for i = 0,20 do
   if DoesExtraExist(vehicle,i) then
 ex = 1
 if extras[i] then ex = extras[i] end
 SetVehicleExtra(vehicle, i, ex)
   end
  end
 end
}