-- ping.lua
-- A simple module that answers to pings
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

ping = {}
ping.name = "ping"

-- On load
function ping.on_load()
	print(" `ping` by Thomas Maurice loaded")
end

-- Answer the pings
function ping.on_ping(server, str)
  server:send(string.gsub(str, "PING", "PONG"))
end

table.insert(modules, ping)
