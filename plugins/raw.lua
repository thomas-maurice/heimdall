-- raw.lua
-- Prints the raw traffic of the server
-- can be pretty much annoying. Disabled by default.
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

raw = {}
raw.name = "raw"

function raw.on_unload()
	print("Unloading module `raw`")
end

-- On load
function raw.on_load()
	print(" `raw` by Thomas Maurice loaded")
end

function raw.on_raw(serv, str)
  print(str)
end

table.insert(modules, raw)
