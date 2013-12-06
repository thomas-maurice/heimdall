-- User management library
-- Do not modify this file !
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
--[[
	Those functions are stored in the global `users` variable. The functions
	are used to ensure if a user exists and is endowed with some privileges.
--]]

users = {}

-- Checks if the user is valid, returns the user, the access level or nil
function users.checkUser(self, n, h)
	for u, user in pairs(self) do
		if type(user) == "table" then
			for _, nick in ipairs(user.nicks) do
				for _, host in ipairs(user.hosts) do
					if nick == n and host == h then
						return u, user.access
					end
				end
			end
		end
	end
	return nil, nil
end

-- Has flag
function users.hasFlag(self, u, f)
  if self[u] ~= nil then
  	local flags = self[u].access
  	flags = string.gsub(flags, "P", "PU")
  	flags = string.gsub(flags, "Q", "QPU")
  	flags = string.gsub(flags, "R", "RQPU")
  	flags = string.gsub(flags, "M", "MRQPU")
  	flags = string.gsub(flags, "O", "OMRQPU")
  	
  	if string.find(flags, f) ~= nil then
  		return true
  	else
  		return false
  	end
  else
  	return false
  end
end

-- Deletes a user
function users.delete(self, u)
  self[u] = nil
end
