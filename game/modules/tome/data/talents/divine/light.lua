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

newTalent{
	name = "Healing Light",
	type = {"divine/light", 1},
	require = spells_req1,
	points = 5,
	cooldown = 40,
	positive = -10,
	tactical = {
		HEAL = 10,
	},
	action = function(self, t)
		self:heal(self:spellCrit(20 + self:combatSpellpower(0.5) * self:getTalentLevel(t)), self)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[An invigorating ray of sun shines on you, healing your body for %d life.
		The life healed will increase with the Magic stat]]):format(20 + self:combatSpellpower(0.5) * self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Bathe in Light",
	type = {"divine/light", 2},
	require = spells_req2,
	points = 5,
	cooldown = 10,
	positive = -20,
	tactical = {
		HEAL = 10,
	},
	action = function(self, t)
		local duration = self:getTalentLevel(t) + 2
		local radius = 3
		local dam = 5 + self:combatSpellpower(0.20) * self:getTalentLevel(t)
		local tg = {type="ball", range=self:getTalentRange(t), radius=radius}
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.HEAL, dam,
			radius,
			5, nil,
			{type="healing_vapour"},
			nil, false
		)
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[A magical zone of sunlight appears around you, healing all that stand within.
		The life healed will increase with the Magic stat]]):format(5 + self:combatSpellpower(0.20) * self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Barrier",
	type = {"divine/light", 3},
	require = spells_req3,
	points = 5,
--	mana = 30,
	positive = -20,
	cooldown = 60,
	action = function(self, t)
		self:setEffect(self.EFF_DAMAGE_SHIELD, 10, {power=(10 + self:getMag(30)) * self:getTalentLevel(t)})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		return ([[A protective shield forms around you, negating %d damage.]]):format((10 + self:getMag(30)) * self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Second Life",
	type = {"divine/light", 4},
	require = spells_req4,
	points = 5,
	cooldown = 100,
	positive = -30,
	tactical = {
		ATTACK = 10,
	},
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[NOT FINISHED]])
	end,
}
