-- Handles for the bot
-- Do not touch
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
--[[
		Those functions are provided to handle various events that can
		occure onto the IRC server,for instance a privmsg, a join, a
		kick and so on... Each function is not forced to be defined in the
		plugin's file.
--]]

-- Privmsg handling function
function on_privmsg(server, author, target, message)
  for _, v in ipairs(modules) do
    if v.on_privmsg ~= nil then
      local status, err = pcall(v.on_privmsg, server, author, target, message)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- Numeric handling function
function on_numeric(server, author, command, param)
  for _, v in ipairs(modules) do
    if v.on_numeric ~= nil then
      local status, err = pcall(v.on_numeric, server, author, command, param)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- Notice handling function
function on_notice(server, author, target, message)
  for _, v in ipairs(modules) do
    if v.on_notice ~= nil then
      local status, err = pcall(v.on_notice, server, author, target, message)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- Kick handling function
function on_kick(server, author, chan, target, message)
  for _, v in ipairs(modules) do
    if v.on_kick ~= nil then
      local status, err = pcall(v.on_kick, server, author, chan, target, message)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- Raw handling function
function on_raw(server, str)
  for _, v in ipairs(modules) do
    if v.on_raw ~= nil then
      local status, err = pcall(v.on_raw, server, str)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- Ping handling function
function on_ping(server, str)
  for _, v in ipairs(modules) do
    if v.on_ping ~= nil then
      local status, err = pcall(v.on_ping, server, str)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- Connect handling function
function on_connect(server)
  for _, v in ipairs(modules) do
    if v.on_connect ~= nil then
      local status, err = pcall(v.on_connect, server)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- On join handle function
function on_join(server, author, chan)
  for _, v in ipairs(modules) do
    if v.on_join ~= nil then
      local status, err = pcall(v.on_join, server, author, chan)
      if not status then
      	print("Error in `" .. v.name .. "` : " .. err)
      end
    end
  end
end

-- On time handle function
function on_time(server)
	if last_ontime_call == nil then last_ontime_call = os.time() end
	if os.difftime(os.time(), last_ontime_call) >= 2 then
		for _, v in ipairs(modules) do
		  if v.on_time ~= nil then
		    local status, err = pcall(v.on_time, server, author, chan)
		    if not status then
		    	print("Error in `" .. v.name .. "` : " .. err)
		    end
		  end
		end
		last_ontime_call = os.time()
	end
end

