-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

setAuto("subclass", false)
setAuto("subrace", false)

setStepNames{
	world = "Campaign",
	race = "Race Category",
	subrace = "Race",
	class = "Class Category",
	subclass = "Class",
}

newBirthDescriptor{
	type = "base",
	name = "base",
	desc = {
	},
	descriptor_choices =
	{
		world =
		{
			Tutorial = "disallow",
			["Maj'Eyal"] = "allow",
			Infinite = function() return profile.mod.allow_build.campaign_infinite_dungeon and "allow" or "disallow" end,
			Ents = "disallow",
			Spydre = "disallow",
			Orcs = "disallow",
			Trolls = "disallow",
			Nagas = "disallow",
			Undeads = "disallow",
			Faeros = "disallow",
		},
		subclass =
		{
			-- Nobdoy can be a sun paladin but humans & elves
			['Sun Paladin'] = "disallow",
			-- Nobdoy can be a sun paladin but elves
			['Anorithil'] = "disallow",
		},
	},
	talents = {},
	experience = 1.0,
	body = { INVEN = 1000, QS_MAINHAND = 1, QS_OFFHAND = 1, MAINHAND = 1, OFFHAND = 1, FINGER = 2, NECK = 1, LITE = 1, BODY = 1, HEAD = 1, CLOAK = 1, HANDS = 1, BELT = 1, FEET = 1, TOOL = 1, QUIVER = 1, MOUNT = 1 },

	copy = {
		-- Mages are unheard of at first, nobody but them regenerates mana
		mana_rating = 6,
		mana_regen = 0,

		max_level = 50,
		money = 10,
		resolvers.equip{ id=true,
			{type="lite", subtype="lite", name="brass lantern"},
		},
		resolvers.inventory{ id=true,
			{type="scroll", name="healing infusion", ego_chance=-1000},
			{type="scroll", name="wild infusion", ego_chance=-1000},
			{type="scroll", name="movement infusion", ego_chance=-1000},
			{type="scroll", name="sun infusion", ego_chance=-1000},
			{type="scroll", name="strength infusion", ego_chance=-1000},
			{type="scroll", name="will infusion", ego_chance=-1000},
			{type="scroll", name="vision", ego_chance=-1000},
			{type="scroll", name="speed rune", ego_chance=-1000},
			{type="scroll", name="controlled phase door rune", ego_chance=-1000},
			{type="scroll", name="phase door rune", ego_chance=-1000},
			{type="scroll", name="teleportation rune", ego_chance=-1000},
			{type="scroll", name="shielding rune", ego_chance=-1000},
			{type="scroll", name="invisibility rune", ego_chance=-1000},
		},
		resolvers.inscription("INFUSION:_HEALING", {cooldown=10, heal=50}),
		resolvers.inscription("INFUSION:_WILD", {cooldown=12, what={poison=true}, dur=4, power=20}),
	},
}


--------------- Difficulties
newBirthDescriptor{
	type = "difficulty",
	name = "Tutorial",
	selection_default = not profile.mod.allow_build.tutorial_done,
	desc =
	{
		"Tutorial mode, start with a simplified character and discover the game in a simple quest.",
		"You will be guided by a helpful spirit while learning.",
		"All damage done to the player reduced by 20%",
		"All healing for the player increased by 10%",
		"No achievements possible.",
	},
	descriptor_choices =
	{
		world =
		{
			__ALL__ = "disallow",
			Tutorial = "allow",
		}
	},
	copy = {
		no_birth_levelup = true,
		easy_mode_lifes = 99999,
		resolvers.generic(function() game.difficulty = game.DIFFICULTY_EASY end)
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Easy",
	display_name = "Discovery",
	desc =
	{
		"Discovery game mode",
		"All damage done to the player decreased by 30%",
		"All healing for the player increased by 10%",
		"At level 1,2,3,5,7,10,14,18,24,30,40 get one more 'life' that allows to resurrect at the start of the level.",
		"Achievements are not granted.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = {
		resolvers.generic(function() game.difficulty = game.DIFFICULTY_EASY end),
		easy_mode_lifes = 1,
	},
}
newBirthDescriptor{
	type = "difficulty",
	name = "Normal",
	selection_default = profile.mod.allow_build.tutorial_done,
	desc =
	{
		"Normal game setting",
		"No changes to the rules.",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = { resolvers.generic(function() game.difficulty = game.DIFFICULTY_NORMAL end) },
}
newBirthDescriptor{
	type = "difficulty",
	name = "Nightmare",
	desc =
	{
		"Hard game setting",
		"All damage done to the player increased by 30%",
		"All damage done by the player decreased by 30%",
		"All healing for the player decreased by 20%",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = { resolvers.generic(function() game.difficulty = game.DIFFICULTY_NIGHTMARE end) },
}
newBirthDescriptor{
	type = "difficulty",
	name = "Insane",
	desc =
	{
		"Absolutely unfair game setting",
		"All damage done to the player increased by 50%",
		"All damage done by the player decreased by 50%",
		"All healing for the player decreased by 40%",
		"Player rank is normal instead of elite",
	},
	descriptor_choices =
	{
		race = { ["Tutorial Human"] = "forbid", },
		class = { ["Tutorial Adventurer"] = "forbid", },
	},
	copy = { resolvers.generic(function() game.difficulty = game.DIFFICULTY_INSANE end), rank=2 },
}


-- Worlds
load("/data/birth/worlds.lua")

-- Races
load("/data/birth/races/tutorial.lua")
load("/data/birth/races/human.lua")
load("/data/birth/races/elf.lua")
load("/data/birth/races/halfling.lua")
load("/data/birth/races/dwarf.lua")
load("/data/birth/races/orc.lua")
load("/data/birth/races/troll.lua")
--load("/data/birth/races/spider.lua")
load("/data/birth/races/undead.lua")

-- Sexes
load("/data/birth/sexes.lua")

-- Classes
load("/data/birth/classes/tutorial.lua")
load("/data/birth/classes/warrior.lua")
load("/data/birth/classes/archer.lua")
load("/data/birth/classes/rogue.lua")
load("/data/birth/classes/mage.lua")
load("/data/birth/classes/wilder.lua")
load("/data/birth/classes/divine.lua")
load("/data/birth/classes/corrupted.lua")
load("/data/birth/classes/afflicted.lua")
load("/data/birth/classes/chronomancer.lua")
