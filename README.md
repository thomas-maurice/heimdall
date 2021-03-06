heimdall
========

Heimdall is an IRC bot written in [Lua](http://lua.org).
It's very easy to use and extand.

## Dependencies
You need to install `lua-socket` in order to get the bot running.
Of course, you need Lua, but not worth saying it ;)

## Install
To install Heimdall, just clone the Git repository :
```
	git clone git://svartbergtroll.fr/heimdall.git
	# or the other one
	git clone https://github.com/svartbergtroll/heimdall
```

Then you can launch it
```
	./Heimdall.lua
	# or
	lua Heimdall.lua
```

Tadaa !

## Configuring Heimdall
The two main configuration files you need to know are `users.lua` and
`conf.lua`, both situated in the root directory of the project.
They are written in Lua and evaluated everytime the robot starts up.
That is to say  that you can write all the Lua code into them to enrich
the configuration abilities of the bot and enhance it's dynamism.

### conf.lua
This is the main configuration file of the program, it is used to specify
which server we will connect, which port, username
information and stuff like that. Here it is just for an example. I think the
comments are self-explanatories.
```
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
loadmod("automode")
loadmod("timekickban")
```

Note that it is not yet password-supported, maybe it will come later with
a module, or a system, core option.

### users.lua
This file is used to add users to the robot. With users you can add some
*permission flags* which will determine what the given user is allowed to
do on the bot. There are some permission levels :
 
 * O : Owner
 * M : Master
 * R : User class 3
 * Q : User class 2
 * P : User class 1
 * U : User class 0 (standard user)
 * N : User class -1 (no access)

One flag can imply others. That means that a user flagged as "Owner" will
automatically benefit all the privileges of all the acces levels below him.
For exemple, we have the following implications :

 * O => OMRQPU
 * Q => QPU

Channel mode flags are also possible to specify :

 * o : auto op on all channels
 * h : auto half op on all channels
 * v : auto voice on all channels

These channel flags mode are used by the `automode` module, there are no
implications between the chan modes.

To add a user, use the following syntax :
```
users.<username> = {
	nicks = {"nickname1", "nickname2", ...},
	hosts = {"host1", "host2", ...},
	access = "R" -- access flags
}
```
You can add any hosts/nicks as you want, the user will be recognized and
given his access as soon as a pair user/host is matched. Wildcards cannot
be used to desctibe the user's host/nick.

For example, you want to add a user named "thomas", which will own the bot,
this should do it :
```
users.thomas = {
	-- Svart!*@baz-81C52E6B should do it
	nicks = {"Svart", "Svartbergtroll"},
	hosts = {"baz-81C52E6B"},
	access = "Oohv"
}
```

## Creating a module

### The basics
To create a module, there is a skeleton to follow, the module we will
study will be called `tesmodule` and will be saved as
`plugins/testmodule.lua`. All modules shall be saved as
`plugins/<name>.lua`.

Now for the exemple :
```
-- testmodule
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--

testmodule = {}
testmodule.name = "testmodule"

-- On load
function testmodule.on_load()
	print(" `testmodule` by Thomas Maurice loaded")
end

function testmodule.on_privmsg(server, author, target, message)
  print(author, message)
end

table.insert(modules, testmodule)
```

So this example is easy. First let's look at the skeleton. You have to
define a table for your module, and name it, that's why
`testmodule.name = "testmodule"` is for. Then you have to add all
the callback functions to the module, for exemple `on_load` or
`on_privmsg` but there are many more ! Each one with a specific
prototype. Then you have to insert your module into the robot's module
table : `teble.insert(modules, testmodule).

It's that easy. Next, the callback functions !

### Callback functions
More to come
