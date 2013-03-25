#!/usr/bin/lua

-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
-- Lua IRC bot
--
-- There is no need for a basic user to read this file, all you
-- need to change is in the conf.lua and users.lua files and obviously in the
-- plugins/ directory. Have fun :)

print("+------------------------------------------------+")
print("|                                                |")
print("|              Heimdall Bot v0.1                 |")
print("|                                                |")
print("+------------------------------------------------+\n")

print("Loading...")

bot = {}

-- Loads the modules
require 'luanet.irc'
require 'luanet.regex'
require 'heimdall.users'
require 'heimdall.handles'
require 'heimdall.modules'
-- Loads the conf
require 'conf'
require 'users'

print("Loading modules...")

-- Loads all the modules of the list
for _,v in ipairs(modlist) do
  loadmodule(v)
end

-- List users
print ("Loaded users :")
for k,v in pairs(users) do
  if type(v) == "table" then print(" - " .. k) end
end

-- Create the bot
print("Connecting " .. bot.host .. ":" .. bot.port)
b = luanet.irc.newServer(bot.host, bot.port)

-- Configure it
b.on_privmsg = on_privmsg
b.on_notice = on_notice
b.on_numeric = on_numeric
b.on_raw = on_raw
b.on_ping = on_ping
b.on_kick = on_kick
b.on_connect = on_connect
b.on_join = on_join
b.on_time = on_time

b.waittime = 25

b.nick = bot.nick
b.user = bot.user

-- Launch it and identify
b:connectServer()
b:identify()

-- Proceed :)
while b:isConnected() do
  b:proceed()
  b.on_time(b)
end

-- Why are you still reading ?
