-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

autojoin = {}
autojoin.name = "autojoin"
table.insert(modules, autojoin)

-- On load
function autojoin.on_load()
	print(" `autojoin` by Thomas Maurice loaded")
end

-- As soon as we are connected let's join channels !
function autojoin.on_connect(server)
	print("Connected, joining channels :")
	for chan in io.lines("data/autojoin") do
		server:join(chan)
		print(" " .. chan)
	end
end
