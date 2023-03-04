ra93Core = {}
ra93Core.playerData = {}
ra93Core.config = ra93Config
ra93Core.shared = ra93Config
ra93Core.clientCallBacks = {}
ra93Core.serverCallbacks = {}

exports('getCoreObject', function()
 return ra93Core
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local ra93Core = exports["rcCore"]:getCoreObject()
