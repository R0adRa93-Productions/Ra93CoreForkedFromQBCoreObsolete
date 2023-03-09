local tPrint = function(tbl, indent)
 indent = indent or 0
 local tableTypeList = {
  ["table"] = function(formatting, v)
   print(formatting)
   tPrint(v, indent + 1)
  end,
  ["boolean"] = function(formatting, v) print(("%s^1 %s ^0"):format(formatting, v)) end,
  ["function"] = function(formatting, v) print(("%s^9 %s ^0"):format(formatting, v)) end,
  ["number"] = function(formatting, v) print(("%s^5 %s ^0"):format(formatting, v)) end,
  ["string"] = function(formatting, v) print(("%s ^2'%s' ^0"):format(formatting, v)) end,
  ["thread"] = function(formatting, v) print(("%s ^2'%s' ^0"):format(formatting, v)) end,
  ["userdata"] = function(formatting, v) print(("%s ^2'%s' ^0"):format(formatting, v)) end,
  ["nil"] = function(formatting, v) print(("%s ^2'%s' ^0"):format(formatting, v)) end
 }
 if type(tbl) == "table" then
  for k, v in pairs(tbl) do
   local tblType = type(v)
   local formatting = ("%s ^3%s:^0"):format(string.rep("  ", indent), k)
   tableTypeList[tblType](formatting, v)
  end
 else print(("%s ^0%s"):format(string.rep("  ", indent), tbl)) end
end

Ra93Core.showError = function(resource, msg) print(("\x1b[31m[%s:ERROR]\x1b[0m %s"):format(resource, msg)) end
Ra93Core.showSuccess = function(resource, msg) print(("\x1b[32m[%s:LOG]\x1b[0m %s"):format(resource, msg)) end
Ra93Core.debug = function(tbl, indent, resource)
 resource = resource or "rcCore"
 print(("\x1b[4m\x1b[36m[ %s : DEBUG]\x1b[0m"):format(resource))
 tPrint(tbl, indent)
 print("\x1b[4m\x1b[36m[ END DEBUG ]\x1b[0m")
 TriggerEvent("Ra93Core:debugSomething", tbl, indent)
end

RegisterServerEvent("Ra93Core:debugSomething", function(tbl, indent)
 if GetResourceState(GetInvokingResource()) ~= "started" then return false end
 local resource = GetInvokingResource() or "rcCore"
 Ra93Core.debug(tbl, indent, resource)
end)