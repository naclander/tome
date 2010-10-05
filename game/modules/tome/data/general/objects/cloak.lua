-- ToME - Tales of Middle-Earth
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

newEntity{
	define_as = "BASE_CLOAK",
	slot = "CLOAK",
	type = "armor", subtype="cloak",
	add_name = " (#ARMOR#)",
	display = "(", color=colors.UMBER, image = resolvers.image_material("cloak", "cloth"),
	encumber = 2,
	rarity = 6,
	desc = [[A cloth coat typically worn as a loose outer garment. It is spacious enough to be worn even over bulky metal armour.]],
	egos = "/data/general/objects/egos/cloak.lua", egos_chance = { prefix=resolvers.mbonus(40, 5), suffix=resolvers.mbonus(40, 5) },
}

newEntity{ base = "BASE_CLOAK",
	name = "linen cloak",
	level_range = {1, 20},
	cost = 2,
	material_level = 1,
	wielder = {
		combat_def = 1,
	},
}

newEntity{ base = "BASE_CLOAK",
	name = "cashmere cloak",
	level_range = {20, 40},
	cost = 4,
	material_level = 3,
	wielder = {
		combat_def = 2,
	},
}

newEntity{ base = "BASE_CLOAK",
	name = "elven-silk cloak",
	level_range = {40, 50},
	cost = 7,
	material_level = 5,
	wielder = {
		combat_def = 3,
	},
}
