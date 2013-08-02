-- heimdall.irc
-- A simple wrapper for an IRC server
--
-- Author : Thomas Maurice

require "socket"

-- heimdall.irc
heimdall.irc = {}
heimdall.irc.__index = heimdall.irc

-- heimdall.irc.server
heimdall.irc.server = {}
heimdall.irc.server.__index = heimdall.irc.server

-- sleep
function heimdall.sleep(sec)
    socket.select(nil, nil, sec)
end

-- heimdall.irc functions
-- a new server
function heimdall.irc.newServer(host, port)
  local t = {}
	
  t.socket = socket.tcp()
  t.nick = "LuaBot"
  t.user = "luabot"
  t.realname = "A bot written in Lua :)"
  t.host = host
  t.port = port
  t.buffer = ""
  
  t.waittime = 100 -- milliseconds
  
  t.connected = false
	
  setmetatable(t,heimdall.irc.server)
  return t
end

-- decompose a nick!user~host into 3 variables
function heimdall.irc.splituser(u)
  _,_, nick, user, host = string.find(u, "(%w*)!(%w*)@(.*)")
  return nick, user, host
end

function heimdall.irc.splitUser(u)
  _,_, nick, user, host = string.find(u, "(%w*)!(%w*)@(.*)")
  return nick, user, host
end

-- heimdall.irc.server
-- connects the socket
function heimdall.irc.server:connectServer()
	self.socket:settimeout(0.1)
  r, err = self.socket:connect(self.host, self.port)
  if r == nil then
  	self.connected = false
  	print("Impossible to connect: " .. err)
  else
  	self.connected = true
  end
end

-- are we connected
function heimdall.irc.server:isConnected()
  if self.socket ~= nil then
  	return self.connected
  else
  	return false
  end
end

-- get a line
function heimdall.irc.server:getLine()
	if self.socket == nil then return nil end
  return self.socket:receive("*l")
end

function heimdall.irc.server:getBufferedLine()
  if string.find(self.buffer, "\n") == nil then
    local res = self.buffer
    self.buffer = ""
    return res
  else
    local _,_,p= string.find(self.buffer, "(.[^\n]*)")
    
    self.buffer = string.sub(self.buffer, #p+2, #(self.buffer))
    return res
  end
end

-- parts from a chan
function heimdall.irc.server:part(chan, message)
  if message == nil then message = "" end
  self:send("PART " .. chan .. " " .. message)
end

-- kicks someone off a channel
function heimdall.irc.server:kick(chan, target, reason)
  if reason == nil then reason = "" end
  self:send("KICK " .. chan .. " " .. target .. " " .. reason)
end

-- quits the server
function heimdall.irc.server:quit(message)
  if message == nil then message = "" end
  self:send("QUIT " .. message)
end

-- sends a message
function heimdall.irc.server:privmsg(target, message)
  self:send("PRIVMSG " .. target .. " " .. message)
end

-- sends a notice
function heimdall.irc.server:notice(target, message)
  self:send("NOTICE " .. target .. " " .. message)
end

-- join a chan
function heimdall.irc.server:join(chan)
	self:send("JOIN "..chan)
end

-- send line
function heimdall.irc.server:send(str)
  if self.socket ~= nil then
    n, err = self.socket:send(str.."\n")
    if n == nil then
    	print("Error: " .. err)
    	self.connected = false
    end
  end
end

-- change modes
function heimdall.irc.server:mode(chan, modes, targets)
  if targets == nil then target = "" end
  self:send("MODE " .. chan .. " " .. modes .. " " .. targets)
end

-- Send the ident commands
function heimdall.irc.server:identify()
  self:send("NICK "..self.nick)
  self:send("USER " .. self.user .. " - - :" .. self.realname)
end

-- Whois a person
function heimdall.irc.server:whois(nick)
  self:send("WHOIS " .. nick)
  local end_whois = false
  local user = {}
  
  while not end_whois do
    local str = self:getLine()
    
    if str ~= nil then
      local author
      local command
      local param
      
      _, _, author, command, param = string.find(str, ":([%w@!-~.]+) ([%w.]+) :*(.+)")
      
      if command == "318" then
        end_whois = true
      elseif command == "401" then return nil
      elseif command == "311" then
        local _,_,_,n,u,h,_,r = string.find(param, "([%w_@!-~.]+) ([%w_@!-~.]+) ([%w_@!-~.]+) ([%w_@!-~.]+) (.[^:]+):(.+)")
        user.nick = n
        user.user = u
        user.host = h
        user.realname = r
      else
        self.buffer = self.buffer .. "\n" .. str
      end
    end
    heimdall.sleep(0.05)
  end
  
  return user
  
end

-- proceed the events
function heimdall.irc.server:proceed()
  local str = self:getLine()
  
  -- if no string is retrieved
  if str == nil then return nil end
  
  -- if it's a ping
  if string.find(str, "PING") ~= nil and string.find(str, "PING") == 1 then
    if self.on_ping ~= nil then
      self:on_ping(str)
      return nil
    end
  end
  
  -- anyway
  local author
  local command
  local param
  
  _, _, author, command, param = string.find(str, ":([%w_@!-~.]+) ([%w.]+) :*(.+)")
  
  -- Acknowledge the fact that we are connected
  if command == "376" then
  	if self.on_connect ~= nil then
  		self:on_connect()
  	end
  -- Any numeric command
  elseif string.find(command, "^%d+$") == 1 then
    	if self.on_numeric ~= nil then
		self:on_numeric(author, command, param)
	end
  -- A privmsg
  elseif command == "PRIVMSG" then
  	_, _, chan, message = string.find(param, "([%w#*]*) :(.*)") 
  	if self.on_privmsg ~= nil then
  		self:on_privmsg(author, chan, message)
  	end
  -- A notice
  elseif command == "NOTICE" then
  	_, _, target, message = string.find(param, "([%w#*]*) :(.*)") 
  	if self.on_notice ~= nil then
  		self:on_notice(author, target, message)
  	end
  -- A join
  elseif command == "JOIN" then
  	_, _, chan = string.find(param, "(.*)") 
  	if self.on_join ~= nil then
  		self:on_join(author, chan)
  	end
  -- A part
  elseif command == "PART" then
  	_, _, chan = string.find(param, "(#[%w]*)")
  	-- if no part message is provided, it's just a ""
  	_, _, _, message = string.find(param, "(#[%w]*) :*(.+)")
  	if message == nil then message = "" end
  	if self.on_part ~= nil then
  		self:on_part(author, chan, message)
  	end
  elseif command == "KICK" then
	_, _, chan, target = string.find(param, "(#%w+) (%w+)")
	_, _, _, _, message = string.find(param, ":(.+)")
	if message == nil then message = "" end
	if self.on_kick ~= nil then
		self:on_kick(author, chan, target, message)
	end
  elseif command == "QUIT" then
  	_, _, message = string.find(param, ":*(.+)")
  	if message == nil then message = "" end
  	if self.on_quit ~= nil then
  		self:on_quit(author, message)
  	end
  end
  
  -- anyway, let's send it to the raw parser
  if self.on_raw ~= nil then
  	self:on_raw(str)
  end

  heimdall.sleep(self.waittime)
end
