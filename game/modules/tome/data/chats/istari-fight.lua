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

local function void_portal_open(npc, player)
	-- Charred scar was succesfull
	if player:hasQuest("charred-scar") and player:hasQuest("charred-scar"):isCompleted("stopped") then return false end
	return true
end
local function aeryn_alive(npc, player)
	-- Charred scar was succesfull
	if player:hasQuest("charred-scar") and player:hasQuest("charred-scar"):isCompleted("stopped") then return true end

	-- Spared aeryn
	return player:isQuestStatus("high-peak", engine.Quest.COMPLETED, "spared-aeryn")
end
local function aeryn_dead(npc, player) return not aeryn_alive(npc, player) end

local function aeryn_comes(npc, player)
	local x, y = util.findFreeGrid(player.x, player.y, 1, true, {[engine.Map.ACTOR]=true})
	local aeryn = game.zone:makeEntityByName(game.level, "actor", "HIGH_SUN_PALADIN_AERYN")
	if aeryn then
		game.zone:addEntity(game.level, aeryn, "actor", x, y)
		game.player:setQuestStatus("high-peak", engine.Quest.COMPLETED, "aeryn-helps")
		game.logPlayer(player, "High Sun Paladin Aeryn appears next to you!")

		-- The istari focus her first
		for uid, e in pairs(game.level.entities) do
			if e.define_as and (e.define_as == "ALATAR" or e.define_as == "PALLANDO") then
				e:setTarget(aeryn)
			end
		end
	end
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*The two istari stands before you, shining like the sun.*#WHITE#
Ah! Our guest is finally here. I take it you found the peak entertaining?]],
	answers = {
		{"Spare me the small talk. I am here to stop you!", jump="explain"},
		{"Why are you doing all that? You were supposed to help people!", jump="explain"},
	}
}

newChat{ id="explain",
	text = [[Oh, but all we want is to help people. We have come to the self-evident conclusion that common people are just unfit to govern themselves, always bickering, arguing...
Since the fall of Sauron there is no threat to unite them!]],
	answers = {
		{"So you have decided to become the threat yourselves?", jump="explain2"},
	}
}

newChat{ id="explain2",
	text = [[Us? Ah no, we are merely instruments for the Master. We have planned for His return.]],
	answers = {
		{"And 'Him' would be?", jump="explain3"},
	}
}

if void_portal_open(nil, game.player) then
newChat{ id="explain3",
	text = [[Isn't it obvious? The greatest of them, the black foe of the world. Melkor the great, whom you may know as Morgoth!
The staff has allowed us to drain enough energy from this world to open the portal to the Void and summon him through!
We will bring forth the Last Battle, Dagor Dagorath, as was prophesied to happen when the world was made.
It is already too late. He is coming through as we speak -- it is only a matter of hours!]],
	answers = {
		{"I *WILL* stop you! The world will not end today!", jump="aeryn", action=aeryn_comes, cond=aeryn_alive},
		{"I *WILL* stop you! The world will not end today!", cond=aeryn_dead},
	}
}
else
newChat{ id="explain3",
	text = [[Isn't it obvious? The greatest of them, the black foe of the world. Melkor the great, whom you may know as Morgoth!
The staff will allow us to drain enough energy from this world to open the portal to the Void and summon him through!
We will bring forth the Last Battle, Dagor Dagorath, as was prophesied to happen when the world was made.
You cannot stop us now!]],
	answers = {
		{"I *WILL* stop you! The world will not end today!", jump="aeryn", action=aeryn_comes, cond=aeryn_alive},
		{"I *WILL* stop you! The world will not end today!", cond=aeryn_dead},
	}
}
end

newChat{ id="aeryn",
	text = [[#LIGHT_GREEN#*The air whirls at your side and suddently High Sun Paladin Aeryn appears!*#WHITE#
Then you shall not fight alone! Together we shall stop them, or die trying!]],
	answers = {
		{"I am glad to have you at my side, my Lady. Let's hunt some wizards!"},
	}
}

return "welcome"
