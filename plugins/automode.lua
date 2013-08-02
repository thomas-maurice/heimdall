-- automode.lua
-- Automatically modes a user when he joins a channel
-- The mode ate based on the user's flags
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
automode = {}
automode.name = "automode"
table.insert(modules, automode)

-- On load
function automode.on_load()
  print(" `automode` by Thomas Maurice loaded")
end

function automode.on_join(server, author, chan)
  local n,u,h = luanet.irc.splitUser(author)
  local u = users:checkUser(n,h)
  
  if users:hasFlag(u, "v") then
    server:mode(chan, "+v", n)
  end
  if users:hasFlag(u, "h") then
    server:mode(chan, "+h", n)
  end
  if users:hasFlag(u, "o") then
    server:mode(chan, "+o", n)
  end
end
