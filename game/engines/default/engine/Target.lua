-- TE4 - T-Engine 4
-- Copyright (C) 2009, 2010, 2011 Nicolas Casalini
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
local Map = require "engine.Map"

--- handles targetting
module(..., package.seeall, class.make)

function _M:init(map, source_actor)
	self.display_x, self.display_y = map.display_x, map.display_y
	self.w, self.h = map.viewport.width, map.viewport.height
	self.tile_w, self.tile_h = map.tile_w, map.tile_h
	self.active = false
	self.target_type = {}

	self.cursor = engine.Tiles:loadImage("target_cursor.png"):glTexture()

	--Use power of two (pot) width and height, rounded up
	local pot_width = math.pow(2, math.ceil(math.log(map.tile_w-0.1) / math.log(2.0)))
	local pot_height = math.pow(2, math.ceil(math.log(map.tile_h-0.1) / math.log(2.0)))
	self.sr = core.display.newSurface(pot_width, pot_height)
	self.sr:erase(255, 0, 0, 90)
	self.sr = self.sr:glTexture()
	self.sb = core.display.newSurface(pot_width, pot_height)
	self.sb:erase(0, 0, 255, 90)
	self.sb = self.sb:glTexture()
	self.sg = core.display.newSurface(pot_width, pot_height)
	self.sg:erase(0, 255, 0, 90)
	self.sg = self.sg:glTexture()
	self.sy = core.display.newSurface(pot_width, pot_height)
	self.sy:erase(255, 255, 0, 90)
	self.sy = self.sy:glTexture()
	self.syg = core.display.newSurface(pot_width, pot_height)
	self.syg:erase(153, 204, 50, 90)
	self.syg = self.syg:glTexture()

	self.source_actor = source_actor

	-- Setup the tracking target table
	-- Notice its values are set to weak references, this has no effects on the number for x and y
	-- but it means if the entity field is set to an entity, when it disappears this link wont prevent
	-- the garbage collection
	self.target = {x=self.source_actor.x, y=self.source_actor.y, entity=nil}
--	setmetatable(self.target, {__mode='v'})
end

function _M:display(dispx, dispy)
	-- Make sure we have a source
	if not self.target_type.source_actor then
		self.target_type.source_actor = self.source_actor
	end
	-- Entity tracking, if possible and if visible
	if self.target.entity and self.target.entity.x and self.target.entity.y and game.level.map.seens(self.target.entity.x, self.target.entity.y) then
		self.target.x, self.target.y = self.target.entity.x, self.target.entity.y
	end
	self.target.x = self.target.x or self.source_actor.x
	self.target.y = self.target.y or self.source_actor.y

	local ox, oy = self.display_x, self.display_y
	self.display_x, self.display_y = dispx or self.display_x, dispy or self.display_y

--	self.cursor:toScreen(self.display_x + (self.target.x - game.level.map.mx) * self.tile_w * Map.zoom, self.display_y + (self.target.y - game.level.map.my) * self.tile_h * Map.zoom, self.tile_w * Map.zoom, self.tile_h * Map.zoom)

	-- Do not display if not requested
	if not self.active then return end

	local s = self.sb
	local l = line.new(self.source_actor.x, self.source_actor.y, self.target.x, self.target.y)
	local lx, ly = l()
	local initial_dir = lx and coord_to_dir[lx - self.source_actor.x][ly - self.source_actor.y] or 5
	local stop_x, stop_y = self.source_actor.x, self.source_actor.y
	local stop_radius_x, stop_radius_y = self.source_actor.x, self.source_actor.y
	local stopped = false
	while lx and ly do
		local block, hit, hit_radius = false, true, true
		if self.target_type.block_path then
			block, hit, hit_radius = self.target_type:block_path(lx, ly, true)
		end

		-- Update coordinates and set color
		if hit and not stopped then
			stop_x, stop_y = lx, ly
			if not block and hit == "unknown" then s = self.sy end
		else
			s = self.sr
		end
		if hit_radius and not stopped then
			stop_radius_x, stop_radius_y = lx, ly
		end
		if self.target_type.min_range and not stopped then
			-- Check if we should be "red"
			if core.fov.distance(self.source_actor.x, self.source_actor.y, lx, ly) < self.target_type.min_range then
				s = self.sr
			-- Check if we were only "red" because of minimum distance
			elseif s == self.sr then
				s = self.sb
			end
		end
		s:toScreen(self.display_x + (lx - game.level.map.mx) * self.tile_w * Map.zoom, self.display_y + (ly - game.level.map.my) * self.tile_h * Map.zoom, self.tile_w * Map.zoom, self.tile_h * Map.zoom)
		if block then
			s = self.sr
			stopped = true
		end

		lx, ly = l()
	end
	self.cursor:toScreen(self.display_x + (self.target.x - game.level.map.mx) * self.tile_w * Map.zoom, self.display_y + (self.target.y - game.level.map.my) * self.tile_h * Map.zoom, self.tile_w * Map.zoom, self.tile_h * Map.zoom)

	if self.target_type.ball and self.target_type.ball > 0 then
		core.fov.calc_circle(
			stop_radius_x,
			stop_radius_y,
			game.level.map.w,
			game.level.map.h,
			self.target_type.ball,
			function(_, px, py)
				if self.target_type.block_radius and self.target_type:block_radius(px, py, true) then return true end
			end,
			function(_, px, py)
				if not self.target_type.no_restrict and not game.level.map.remembers(px, py) and not game.level.map.seens(px, py) then
					self.syg:toScreen(self.display_x + (px - game.level.map.mx) * self.tile_w * Map.zoom,
					self.display_y + (py - game.level.map.my) * self.tile_h * Map.zoom,
					self.tile_w * Map.zoom,
					self.tile_h * Map.zoom)
				else
					self.sg:toScreen(self.display_x + (px - game.level.map.mx) * self.tile_w * Map.zoom,
					self.display_y + (py - game.level.map.my) * self.tile_h * Map.zoom,
					self.tile_w * Map.zoom,
					self.tile_h * Map.zoom)
				end
			end,
		nil)
	elseif self.target_type.cone and self.target_type.cone > 0 then
		local dir_angle = math.deg(math.atan2(self.target.y - self.source_actor.y, self.target.x - self.source_actor.x))
		core.fov.calc_beam_any_angle(
			stop_radius_x,
			stop_radius_y,
			game.level.map.w,
			game.level.map.h,
			self.target_type.cone,
			dir_angle,
			self.target_type.cone_angle,
			function(_, px, py)
				if self.target_type.block_radius and self.target_type:block_radius(px, py, true) then return true end
			end,
			function(_, px, py)
				if not self.target_type.no_restrict and not game.level.map.remembers(px, py) and not game.level.map.seens(px, py) then
					self.syg:toScreen(self.display_x + (px - game.level.map.mx) * self.tile_w * Map.zoom,
					self.display_y + (py - game.level.map.my) * self.tile_h * Map.zoom,
					self.tile_w * Map.zoom,
					self.tile_h * Map.zoom)
				else
					self.sg:toScreen(self.display_x + (px - game.level.map.mx) * self.tile_w * Map.zoom,
					self.display_y + (py - game.level.map.my) * self.tile_h * Map.zoom,
					self.tile_w * Map.zoom,
					self.tile_h * Map.zoom)
				end
			end,
		nil)
	end

	self.display_x, self.display_y = ox, oy
end

-- @return t The target table used by ActorProject, Projectile, GameTargeting, etc.
-- @param t Target table used to generate the
-- @param t.type The engine-defined type, populates other more complex variables (see below)
-- Hit: simple project in LOS<br/>
-- Beam: hits everything in LOS<br/>
-- Bolt: hits first thing in path<br/>
-- Ball: hits everything in a ball around the target<br/>
-- Cone: hits everything in a cone in the direction<br/>
-- @param t.radius The radius of the ball/cone AoE
-- @param t.cone_angle The angle for the cone AoE (default 55°)
-- @param t.no_restrict Boolean that removes all restrictions in the t.type defined block functions.
-- @param t.stop_block Boolean that stops the target on the first tile that has an entity that blocks move.
-- @param t.range The range the target can be from the origin.
-- @param t.pass_terrain Boolean that allows the target to pass through terrain to remembered tiles on the other side.
-- @param t.block_path(typ, lx, ly) Function called on each tile to determine if the targeting is blocked.  Automatically set when using t.typ, but the user can provide their own if they know what they are doing.  It should return three arguments: block, hit, hit_radius
-- @param t.block_radius(typ, lx, ly) Function called on each tile when projecting the radius to determine if the radius projection is blocked.  Automatically set when using t.typ, but the user can provide their own if they know what they are doing.
function _M:getType(t)
	if not t then return {} end
	-- Add the default values
	t = table.clone(t)
	-- Default type def
	local target_type = {
		range=20,
		selffire=true,
		friendlyfire=true,
		block_path = function(typ, lx, ly, for_highlights)
			if not typ.no_restrict then
				if typ.range and typ.start_x then
					local dist = core.fov.distance(typ.start_x, typ.start_y, lx, ly)
					if math.floor(dist - typ.range + 0.5) > 0 then return true, false, false end
				elseif typ.range and typ.source_actor and typ.source_actor.x then
					local dist = core.fov.distance(typ.source_actor.x, typ.source_actor.y, lx, ly)
					if math.floor(dist - typ.range + 0.5) > 0 then return true, false, false end
				end
				local is_known =  game.level.map.remembers(lx, ly) or game.level.map.seens(lx, ly)
				if typ.requires_knowledge and not is_known then
					return true, false, false
				end
				if not typ.pass_terrain and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") and not game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "pass_projectile") then
					if for_highlights and not is_known then
						return false, "unknown", true
					else
						return true, true, false
					end
				-- If we explode due to something other than terrain, then we should explode ON the tile, not before it
				elseif typ.stop_block then
					local nb = game.level.map:checkAllEntitiesCount(lx, ly, "block_move")
					if nb > 1 or (nb == 1 and game.level.map:checkAllEntities(lx, ly, "block_move") and not game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "pass_projectile")) then
						if for_highlights and not is_known then
							return false, "unknown", true
						else
							return true, true, true
						end
					end
				end
				if for_highlights and not is_known then
					return false, "unknown", true
				end
			end
			-- If we don't block the path, then the explode point should be here
			return false, true, true
		end,
		block_radius=function(typ, lx, ly, for_highlights)
			return not typ.no_restrict and game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "block_move") and not game.level.map:checkEntity(lx, ly, engine.Map.TERRAIN, "pass_projectile") and not (for_highlights and not (game.level.map.remembers(lx, ly) or game.level.map.seens(lx, ly)))
		end
	}

	-- And now modify for the default types
	if t.type then
		if t.type:find("ball") then
			target_type.ball = t.radius
		end
		if t.type:find("cone") then
			target_type.cone = t.radius
			target_type.cone_angle = t.cone_angle or 55
			target_type.selffire = false
		end
		if t.type:find("bolt") then
			target_type.stop_block = true
		elseif t.type:find("beam") then
			target_type.line = true
		end
	end
	table.update(t, target_type)
	return t
end

function _M:setActive(v, type)
	if v == nil then
		return self.active
	else
		self.active = v
		if v and type then
			self.target_type = self:getType(type)
			-- Targeting will generally want to stop at unseen/remembered tiles
--			table.update(self.target_type, {requires_knowledge=true})
		else
			self.target_type = {}
		end
	end
end

function _M:freemove(dir)
	local d = dir_to_coord[dir]
	self.target.x = self.target.x + d[1]
	self.target.y = self.target.y + d[2]
	self.target.entity = game.level.map(self.target.x, self.target.y, engine.Map.ACTOR)
	if self.on_set_target then self:on_set_target("freemove") end
end

function _M:setDirFrom(dir, src)
	local d = dir_to_coord[dir]
	self.target.x = src.x + d[1]
	self.target.y = src.y + d[2]
	self.target.entity = game.level.map(self.target.x, self.target.y, engine.Map.ACTOR)
	if self.on_set_target then self:on_set_target("dir_from") end
end

function _M:setSpot(x, y, how)
	self.target.x = x
	self.target.y = y
	self.target.entity = game.level.map(self.target.x, self.target.y, engine.Map.ACTOR)
end

function _M:setSpotInMotion(x, y, how)
	if self.on_set_target then self:on_set_target(how) end
end

function _M:scan(dir, radius, sx, sy, filter)
	sx = sx or self.target.x
	sy = sy or self.target.y
	radius = radius or 20
	local actors = {}
	local checker = function(_, x, y)
		if sx == x and sy == y then return false end
		if game.level.map.seens(x, y) and game.level.map(x, y, engine.Map.ACTOR) then
			local a = game.level.map(x, y, engine.Map.ACTOR)

			if (not self.source_actor or self.source_actor:canSee(a)) and (not filter or filter(a)) then
				table.insert(actors, {
					a = a,
					dist = math.abs(sx - x)*math.abs(sx - x) + math.abs(sy - y)*math.abs(sy - y)
				})
				actors[a] = true
			end
		end
		return false
	end

	if dir ~= 5 then
		-- Get a list of actors in the direction given
		core.fov.calc_beam(sx, sy, game.level.map.w, game.level.map.h, radius, dir, 55, checker, function()end, nil)
	else
		-- Get a list of actors all around
		core.fov.calc_circle(sx, sy, game.level.map.w, game.level.map.h, radius, checker, function()end, nil)
	end

	table.sort(actors, function(a,b) return a.dist<b.dist end)
	if #actors > 0 then
		self.target.entity = actors[1].a
		self.target.x = self.target.entity.x
		self.target.y = self.target.entity.y
		if self.on_set_target then self:on_set_target("scan") end
	end
end

--- Returns the point at distance from the source on a line to the destination
function _M:pointAtRange(srcx, srcy, destx, desty, dist)
	local l = line.new(srcx, srcy, destx, desty)
	local lx, ly = l()
	while lx and ly do
		if core.fov.distance(srcx, srcy, lx, ly) >= dist then break end
		lx, ly = l()
	end
	if not lx then
		return destx, desty
	else
		return lx, ly
	end
end
