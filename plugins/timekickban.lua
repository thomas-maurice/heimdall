-- tkb.lua
-- Time kick-bans a user. The bans are stored into
-- data/tkb.lst and users are automatically unbanned
-- after the given delay.
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

timekickban = {}
timekickban.name = "timekickban"
table.insert(modules, timekickban)

-- On load
function timekickban.on_load()
	timekickban.lastcall = os.time()
	-- Create or just touch the ban file
	local f = io.open("data/tkb.lst", "a")
	f:close()
	print(" `timekickban` by Thomas Maurice loaded")
end

-- Liste les bans encore en cours et construit les tables et les met dans un
-- array :
-- ban
--  |- chan
--  |- nick
--  |- user
--  |- host
--  `- expire
--
function timekickban.read()
	local bans = {}
	for l in io.lines("data/tkb.lst") do
		_, _, exp, c, n, u, h = string.find(l, "([0-9]+) ([^ ]+) ([^ ]+) ([^ ]+) ([^ ]+)")
		exp = tonumber(exp)
		if exp ~= nil and c ~= nil and n ~= nil and u ~= nil and h ~= nil then
			local b = {
						expire = exp,
						nick = n,
						user = u,
						host = h,
						chan = c
					}
			table.insert(bans, b)
		end
	end
	io.close()
	return bans
end

-- Ici ban est une table qui contient le
-- nick,user et host en plus de l'expire
function timekickban.ban(server, ban)
	server:mode(ban.chan, "+b", ban.nick .. "!*@*")
	server:mode(ban.chan, "+b", ban.nick .. "!" .. ban.user .. "@*")
	server:mode(ban.chan, "+b", ban.nick .. "!" .. ban.user .. "@" .. ban.host)
	server:mode(ban.chan, "+b", "*!" .. ban.user .. "@" .. ban.host)
end

-- Ici ban est une table qui contient le
-- nick,user et host en plus de l'expire
function timekickban.unban(server, ban)
	server:mode(ban.chan, "-b", ban.nick .. "!*@*")
	server:mode(ban.chan, "-b", ban.nick .. "!" .. ban.user .. "@*")
	server:mode(ban.chan, "-b", ban.nick .. "!" .. ban.user .. "@" .. ban.host)
	server:mode(ban.chan, "-b", "*!" .. ban.user .. "@" .. ban.host)
end

-- Sauvegarde les banissements sous ce format :
-- timestamp_expiration chan nick user host
function timekickban.save(list)
	local f = io.open("data/tkb.lst", "w+")
	for i=1,#list do
		if list[i] ~= nil then
			f:write(tostring(list[i].expire) .. " " .. list[i].chan .. " " .. list[i].nick .. " " .. list[i].user .. " " .. list[i].host .. "\n")
		end
	end
	f:close() -- useless ?
end

-- Guette les évènements temporels pour les débans automatiques
function timekickban.on_time(server)
	if os.difftime(os.time(), timekickban.lastcall) < 5 then return end
	timekickban.lastcall = os.time()
	local bans = timekickban.read()
	for i=1,#bans do -- Pour chaque banissement,voir s'il a expiré
		if os.difftime(bans[i].expire, os.time()) <= 0 then
			print("Débanissement de " .. bans[i].nick)
			timekickban.unban(server, bans[i])
			bans[i] = nil
		end
	end
	-- sauve les banissements
	timekickban.save(bans)
end

-- Guette les évènements de messages, genre si on demande le banissement d'un
-- utilisateur du canal
function timekickban.on_privmsg(server, author, target, message)
	local n,u,h = heimdall.irc.splitUser(author)
	local u = users:checkUser(n,h)
	-- If the user is not entitled to perform those actions
	-- quit
	if not users:hasFlag(u, "M") then
		return
	end
	-- A ce stade, l'utilisateur est identifié et a les droits
	-- On parse les commandes
	if string.find(message, "!tkb ban") == 1 then
		-- On récupère la cible et la durée
		local _, _, targ = string.find(message, "!tkb ban ([%w_-]+)")
		local _, _, _, dur = string.find(message, "!tkb ban ([%w_-]+) ([0-9]+)")
		if targ ~= nil then
			targ = server:whois(targ)
			dur = tonumber(dur)
			-- Si aucune durée n'est donnée, on la fixe à 10mn
			if dur == nil then dur = 600 end
			if targ ~= nil then
				-- Ajout du ban à la liste existante
				local bans = timekickban.read()
				local ban = {}
				ban.expire = os.time() + dur
				ban.nick = targ.nick
				ban.user = targ.user
				ban.host = targ.host
				ban.chan = target
				table.insert(bans, ban)
				
				print("Banissement de ".. ban.nick .. " de " .. ban.chan .. " par " .. u .. " pour " .. tostring(dur) .. " secondes")
				
				-- Kaaaaa
				server:privmsg(chan, "Attention " .. ban.nick .. ", impact dans 3...")
				heimdall.sleep(1000) -- mehaaaaaaaa
				server:privmsg(chan, "2...")
				heimdall.sleep(1000) -- mehaaaaaaaa
				server:privmsg(chan, "1...")
				heimdall.sleep(1000)
				timekickban.ban(server, ban) -- MEHAAAAAAAAAAAAAA
				server:kick(chan, ban.nick, "zéro - banni pour " .. tostring(dur) .. " secondes") -- Boom.
				
				-- Fatality.
				
				timekickban.save(bans)
			end
		end
	end
end
