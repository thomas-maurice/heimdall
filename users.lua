-- Users configuration
-- Author : Thomas Maurice <tmaurice59@gmail.com>
--
-- Create a sample user
-- A user is identified by a set of nick and hosts,
-- if a combination of those too is found in the list
-- bellow then the user is identifyed
-- The access is a set of flags which have the following
-- meaning :
-- O : Owner
-- M : Master
-- R : User class 3
-- Q : User class 2
-- P : User class 1
-- U : User class 0 (standard user)
-- N : User class -1 (no access)
-- With those implications :
-- O => OMRQPU and Q => QPU
-- Chan mode flags are also possible :
-- o : auto op on all channels
-- h : auto half op on all channels
-- v : auto voice on all channels
-- Those flags are used to set permissions of users on the bot.

users.thomas = {
	-- Svart!*@baz-81C52E6B should do it
	nicks = {"Svart", "Svartbergtroll"},
	hosts = {"baz-81C52E6B"},
	access = "Oohv"
}
