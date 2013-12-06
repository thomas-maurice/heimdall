-- Test module, disabled.
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

test = {}
test.name = "test"

-- On load
function test.on_load()
	print(" `test` by Thomas Maurice loaded")
end

function test.on_privmsg(server, author, target, message)
  --print(author, message)
  if message == "!err" then
  	a = nil
  	a.test()
  end
end

table.insert(modules, test)
