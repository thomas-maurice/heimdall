-- Modules management
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
--[[
	Here comes the modules management file ! This is used to easien the loading
	and the unloading of all the modules (aka plugins) of the bot.
--]]
modlist = {}
modules = {}

-- Loads a module (alias for the conf file)
function loadmod(mod)
  table.insert(modlist, mod)
end

-- Loads a module
function loadmodule(mod)
  require("plugins."..mod)
  local i = #modules
  if modules[i].on_load ~= nil then
  	modules[i].on_load()
  end
end

-- Unloads a module, it's functions will be unavailable.
function unloadmodule(mod)
  package.loaded["plugins." .. mod] = nil
  for k,v in ipairs(modules) do
    if v.name == mod then
    	if modules[k].on_unload ~= nil then
  			modules[k].on_unload()
  		end
      table.remove(modules, k)
    end
  end
end

-- Reloads a module
function reloadmodule(mod)
  unloadmodule(mod)
  reloadmodule(mod)
end
