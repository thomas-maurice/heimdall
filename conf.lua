-- Configuration file for the bot
-- don't forget to edit users.lua too
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

-- Host of the server
bot.host = "localhost"
-- Port of the server
bot.port = 6667

-- Nick and user of the bot :
-- nick!user@host.....
bot.nick = "HeimdallBot"
bot.user = "heim"

-- Modules to load :
-- loadmod("<module>")
-- Where <module> is a plugins/<modules>.lua
loadmod("ping")
loadmod("raw")
loadmod("autorejoin")
loadmod("mods")
loadmod("autojoin")
loadmod("automode")
loadmod("timekickban")
