newEntity{
	define_as = "BASE_POTION",
	type = "potion", subtype="potion",
	display = "!", color=colors.WHITE,
	encumber = 0.2,
	stacking = true,
	desc = [[Magical potions can have wildly different effects, from healing to killing you, beware! Most of them function better with a high Magic score]],
}

-------------------------------------------------------
-- Healing
-------------------------------------------------------
newEntity{ base = "BASE_POTION",
	name = "potion of lesser healing",
	color = colors.LIGHT_RED,
	level_range = {1, 20},
	rarity = 3,
	cost = 3,

	use_simple = { name="heal some life", use = function(self, who)
		who:heal(40 + who:getMag())
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

newEntity{ base = "BASE_POTION",
	name = "potion of healing",
	color = colors.LIGHT_RED,
	level_range = {15, 35},
	rarity = 4,
	cost = 5,

	use_simple = { name="heal a good part of your life", use = function(self, who)
		who:heal(140 + who:getMag())
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

newEntity{ base = "BASE_POTION",
	name = "potion of greater healing",
	color = colors.LIGHT_RED,
	level_range = {30, 50},
	rarity = 5,
	cost = 7,

	use_simple = { name="heal a lot", use = function(self, who)
		who:heal(240 + who:getMag())
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

newEntity{ base = "BASE_POTION",
	name = "potion of full healing",
	color = colors.LIGHT_RED,
	level_range = {45, 50},
	rarity = 14,
	cost = 50,

	use_simple = { name="fully heal", use = function(self, who)
		who:heal(1000000)
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

-------------------------------------------------------
-- Mana
-------------------------------------------------------
newEntity{ base = "BASE_POTION",
	name = "potion of lesser mana",
	color = colors.LIGHT_BLUE,
	level_range = {1, 20},
	rarity = 3,
	cost = 3,

	use_simple = { name="restore some mana", use = function(self, who)
		who:incMana(40 + who:getMag())
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

newEntity{ base = "BASE_POTION",
	name = "potion of mana",
	color = colors.LIGHT_BLUE,
	level_range = {15, 35},
	rarity = 4,
	cost = 5,

	use_simple = { name="restore a good part of your mana", use = function(self, who)
		who:incMana(140 + who:getMag())
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

newEntity{ base = "BASE_POTION",
	name = "potion of greater mana",
	color = colors.LIGHT_BLUE,
	level_range = {30, 50},
	rarity = 5,
	cost = 7,

	use_simple = { name="restore a lot of mana", use = function(self, who)
		who:incMana(240 + who:getMag())
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

newEntity{ base = "BASE_POTION",
	name = "potion of full mana",
	color = colors.LIGHT_BLUE,
	level_range = {45, 50},
	rarity = 14,
	cost = 50,

	use_simple = { name="fully restore mana", use = function(self, who)
		who:incMana(1000000)
		game.logSeen(who, "%s quaffs a %s!", who.name:capitalize(), self:getName())
		return "destroy", true
	end}
}

-------------------------------------------------------
-- Curing
-------------------------------------------------------
newEntity{ base = "BASE_POTION",
	name = "potion of cure poison",
	color = colors.LIGHT_GREEN,
	level_range = {1, 50},
	rarity = 7,
	cost = 3,

	use_simple = { name="cures poison", use = function(self, who)
		if who:hasEffect(who.EFF_POISONED) then
			who:removeEffect(who.EFF_POISONED)
			game.logSeen(who, "%s cures %s from poisoning!", self:getName(), who.name:capitalize())
			return "destroy", true
		end
		return "destroy", false
	end}
}

