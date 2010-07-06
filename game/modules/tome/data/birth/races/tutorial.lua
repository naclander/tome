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

---------------------------------------------------------
--                       Humans                        --
---------------------------------------------------------
newBirthDescriptor{
	type = "race",
	name = "Tutorial Human",
	desc = {
		"A special tutorial race.",
	},
	descriptor_choices =
	{
		subrace =
		{
			["Tutorial Human"] = "allow",
			__ALL__ = "disallow",
		},
	},
	talents = {},
	experience = 1.0,
	copy = {
		faction = "reunited-kingdom",
		type = "humanoid", subtype="human",
	},
}

newBirthDescriptor
{
	type = "subrace",
	name = "Tutorial Human",
	desc = {
		"Humans hailing from the northen town of Bree. A common kind of man, unremarkable in all respects.",
	},
	copy = {
		default_wilderness = {1, 1, "wilderness-tutorial"},
		starting_zone = "tutorial",
		starting_quest = "tutorial",
		starting_intro = "tutorial",
	},
}
