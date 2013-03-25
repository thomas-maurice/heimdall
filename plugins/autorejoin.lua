-- autorejoin.lua
-- Automatically rejoins a channel when kicked
-- out of it. With a little message for the kicker.
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
autorejoin = {}
autorejoin.name = "autorejoin"
-- The message :
autorejoin.message = "Stoil kick :noel:"

-- On load
function autorejoin.on_load()
	print(" `autorejoin` by Thomas Maurice loaded")
end

-- On a kick
function autorejoin.on_kick(server, author, chan, target, reason)
	nick, user, host = luanet.irc.splituser(author)
	-- If we are the target of the kick, we rejoin the channel
	if target == bot.nick then
		server:join(chan)
		if autorejoin.message ~= nil and autorejoin.message ~= "" then
			server:notice(nick, autorejoin.message)
		end
	end
end

table.insert(modules, autorejoin)
