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

require "engine.class"
require "engine.World"
require "mod.class.interface.WorldAchievements"
local Savefile = require "engine.Savefile"

module(..., package.seeall, class.inherit(engine.World, mod.class.interface.WorldAchievements))

function _M:init()
	engine.World.init(self)
end

function _M:run()
	self:loadAchievements()
end

--- Requests the world to save
function _M:saveWorld(no_dialog)
	-- savefile_pipe is created as a global by the engine
	savefile_pipe:push("", "world", self)
end

--- Format an achievement source
-- @param src the actor who did it
function _M:achievementWho(src)
	return src.name.." the "..game.player.descriptor.subrace.." "..game.player.descriptor.subclass
end

--- Gain an achievement
-- @param id the achivement to gain
-- @param src who did it
function _M:gainAchievement(id, src, ...)
	local a = self.achiev_defs[id]
	-- Do not unlock things in easy mode
	if not a or (game.difficulty == game.DIFFICULTY_EASY and not a.tutorial) then return end

	if game.difficulty == game.DIFFICULTY_NIGHTMARE then id = "NIGHTMARE_"..id end
	if game.difficulty == game.DIFFICULTY_INSANE then id = "INSANE_"..id end

	mod.class.interface.WorldAchievements.gainAchievement(self, id, src, ...)
end
