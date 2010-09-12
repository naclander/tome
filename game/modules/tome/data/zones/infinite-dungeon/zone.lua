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

return {
	name = "Infinite Dungeon",
	level_range = {1, 1},
	level_scheme = "player",
	max_level = 1000000000,
	decay = {300, 800},
	actor_adjust_level = function(zone, level, e) return math.floor((zone.base_level + level.level-1) * 1.7) + e:getRankLevelAdjust() + rng.range(-1,2) end,
	width = 100, height = 100,
	all_remembered = true,
	all_lited = true,
--	persistant = "zone",
	ambiant_music = "Swashing the buck.ogg",
	generator =  {
		map = {
			class = "engine.generator.map.Roomer",
			nb_rooms = 10,
--			rooms = {"simple", "pilar", {"money_vault",5}},
			rooms = {"simple", "greater_vault"},
			rooms_config = {pit={filters={{type="undead"}}}},
			vaults_list = {"double-t","crypt","treasure1","diggers"},
			lite_room_chance = 50,
			['.'] = "FLOOR",
			['#'] = "WALL",
			up = "UP",
			down = "DOWN",
			door = "DOOR",
		},
		actor = {
			class = "engine.generator.actor.Random",
			nb_npc = {20, 30},
		},
		object = {
			class = "engine.generator.object.Random",
			nb_object = {6, 9},
		},
		trap = {
			class = "engine.generator.trap.Random",
			nb_trap = {6, 9},
		},
	},
	levels =
	{
		[1] = {
			generator = { map = {
				up = "UP_WILDERNESS",
			}, },
		},
	},
}
