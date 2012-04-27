-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012 Nicolas Casalini
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
	define_as = "BASE_TOTEM",
	slot = "TOOL",
	type = "charm", subtype="totem",
	unided_name = "totem", id_by_type = true,
	display = "-", color=colors.WHITE, image = resolvers.image_material("wand", "wood"),
	encumber = 2,
	rarity = 9,
	add_name = "#CHARM# #CHARGES#",
	use_sound = "talents/spell_generic",
	is_magic_device = true,
	elec_destroy = {{20,1}, {30,2}, {60,5}, {90,10}, {170,20}},
	desc = [[Natural totems are made by powerful wilders to store nature power.]],
	egos = "/data/general/objects/egos/totems.lua", egos_chance = { prefix=resolvers.mbonus(20, 5), suffix=100 }, ego_first_type = "suffix",
	power_source = {nature=true},
	talent_cooldown = "T_GLOBAL_CD",
}

newEntity{ base = "BASE_TOTEM",
	name = "elm totem",
	color = colors.UMBER,
	level_range = {1, 10},
	cost = 1,
	material_level = 1,
	charm_power = resolvers.mbonus_material(15, 10),
}

newEntity{ base = "BASE_TOTEM",
	name = "ash totem",
	color = colors.UMBER,
	level_range = {10, 20},
	cost = 2,
	material_level = 2,
	charm_power = resolvers.mbonus_material(20, 20),
}

newEntity{ base = "BASE_TOTEM",
	name = "yew totem",
	color = colors.UMBER,
	level_range = {20, 30},
	cost = 3,
	material_level = 3,
	charm_power = resolvers.mbonus_material(25, 30),
}

newEntity{ base = "BASE_TOTEM",
	name = "elven-wood totem",
	color = colors.UMBER,
	level_range = {30, 40},
	cost = 4,
	material_level = 4,
	charm_power = resolvers.mbonus_material(30, 40),
}

newEntity{ base = "BASE_TOTEM",
	name = "dragonbone totem",
	color = colors.UMBER,
	level_range = {40, 50},
	cost = 5,
	material_level = 5,
	charm_power = resolvers.mbonus_material(35, 50),
}