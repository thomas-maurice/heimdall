-- mods.lua
-- A module used to load other modules
-- The syntax is simple :
-- !modules [un|re]load <module>
-- !modules list
-- Later on, some permissions will be required to
-- perform those operations.
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

mods = {}
mods.name = "mods"
table.insert(modules, mods)

-- On load
function mods.on_load()
	print(" `mods` by Thomas Maurice loaded")
end

-- Is a module loaded ?
function mods.is_loaded(mod)
	if package.loaded["plugins." .. mod] ~= nil and package.loaded["plugins." .. mod] == true then
		return true
	else
		return false
	end
end

-- Make an error string with \n more suitable to IRC
function mods.err_toirc(err)
	return string.gsub(err, "\n", " - ")
end	

function mods.on_privmsg(server, author, target, message)
	local n,u,h = luanet.irc.splitUser(author)
	local u = users:checkUser(n,h)
	-- If the user is not entitled to perform those actions
	-- quit
	if not users:hasFlag(u, "O") then
		return
	end
	-- Let's try to load a module
	if string.find(message, "!modules load") == 1 then
		local _, _, mod = string.find(message, "!modules load (%w+)")
		if mod ~= nil then
			-- Protected call just in case the module does not exist
			local s, err = pcall(loadmodule, mod)
			if s then
				server:privmsg(target, "Module " .. mod .. " loaded !")
			else
				server:privmsg(target, "Module " .. mod .. " failed to load (" .. mods.err_toirc(err) .. ")")
			end
		end
	-- Reload a module
	elseif string.find(message, "!modules reload") == 1 then
		local _, _, mod = string.find(message, "!modules reload (%w+)")
		if mod ~= nil then
			-- Protect call just in case the module does not exist
			local s, err = pcall(unloadmodule, mod)
			local s, err = pcall(loadmodule, mod)
			if s then
				server:privmsg(target, "Module " .. mod .. " reloaded !")
			else
				server:privmsg(target, "Module " .. mod .. " failed to reload (" .. mods.err_toirc(err) .. ")")
			end
		end
	-- Unload a module
	elseif string.find(message, "!modules unload") == 1 then
		local _, _, mod = string.find(message, "!modules unload (%w+)")
		if mod ~= nil then
			-- Protect call just in case the module does not exist
			local s, err = pcall(unloadmodule, mod)
			if s then
				server:privmsg(target, "Module " .. mod .. " unloaded !")
			else
				server:privmsg(target, "Module " .. mod .. " failed to unload (" .. mods.err_toirc(err) .. ")")
			end
		end
	-- List all the loaded modules
	elseif string.find(message, "!modules list") == 1 then
		for k, v in ipairs(modules) do
			server:privmsg(target, " * " .. v.name)
		end
	end
end
