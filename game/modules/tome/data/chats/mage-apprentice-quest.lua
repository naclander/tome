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

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*Before you stands a young man, a novice mage by his looks*#WHITE#
Good day to you, fellow traveler!]],
	answers = {
		{"What brings an apprentice mage out into the wilds?", jump="quest", cond=function(npc, player) return not player:hasQuest("mage-apprentice") end},
		{"I have something for you!",
			jump="welcome",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):can_offer(player) end,
			action=function(npc, player, dialog) player:hasQuest("mage-apprentice"):collect_staff(npc, player, dialog) end
		},
		{"I found this staff; it looks powerful. Maybe it would be enough?",
			jump="kor_fall",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):can_offer_kor(player) end,
			action=function(npc, player, dialog) player:hasQuest("mage-apprentice"):collect_staff_kor(player, dialog) end
		},
		-- Reward for non-mages: access to Angolwen
		{"So you have enough magical items now?",
			jump="thanks",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):isCompleted() and not player:knowTalent(player.T_TELEPORT_ANGOLWEN) end,
		},
		-- Reward for mages: upgrade a talent mastery
		{"So you have enough magical items now?",
			jump="thanks_mage",
			cond=function(npc, player) return player:hasQuest("mage-apprentice") and player:hasQuest("mage-apprentice"):isCompleted() and player:knowTalent(player.T_TELEPORT_ANGOLWEN) end,
		},
--		{"Do you have any items to sell?", jump="store"},
		{"Sorry I have to go!"},
	}
}

newChat{ id="quest",
	text = [[Ahh, my story is a sad one ... I should not trouble you with it, my friend.]],
	answers = {
		{"It is no trouble at all! Please tell me!", jump="quest2"},
		{"Ok, bye then!"},
	}
}
newChat{ id="quest2",
	text = [[Well, if you insist...
I am a novice mage, as you might have noticed, and my goal is to be accepted by the elves of Angolwen and be taught the secrets of the arcane.]],
	answers = {
		{"Who are the elves of Angolwen?", jump="quest3", cond=function(npc, player) return player.faction ~= "angolwen" end,},
		{"Ah yes, Angolwen, I have called it home for many years...", jump="quest3_mage", cond=function(npc, player) return player.faction == "angolwen" end,},
		{"Well, good luck, bye!"},
	}
}
newChat{ id="quest3",
	text = [[The keepers of ar... err, I do not think I am supposed to talk about them ... sorry, my friend...
In any case, I must collect 15 magic staves, rings or amulets, and I have yet to find one. I would be grateful if you could bring me some should you find any!]],
	answers = {
		{"I will keep that in mind!", action=function(npc, player) player:grantQuest("mage-apprentice") end},
		{"No way, bye!"},
	}
}
newChat{ id="quest3_mage",
	text = [[I hope I will too ...
In any case, I must collect 15 magic staves, rings or amulets and I have yet to find one. I would be grateful if you could bring me some should you find any!]],
	answers = {
		{"I will keep that in mind!", action=function(npc, player) player:grantQuest("mage-apprentice") end},
		{"No way, bye!"},
	}
}

newChat{ id="kor_fall",
	text = [[Let me examine it.
Oh yes, my friend, this is indeed a powerful staff! I think that it alone should suffice to complete my quest! Many thanks!]],
	answers = {
		{"Well, I can not use it anyway.", jump="welcome"},
	}
}

newChat{ id="thanks",
	text = [[Ah yes! I am so glad! I will be able to go back to Angolw...err... Oh well, I guess I can tell you; you deserve it for helping me.
During the dark years of the Spellhunt, many thousands years ago, Linaniil, the great mage of the Kor'Krul worried that magic might disappear with her generation and be lost to mortals should they need it again.
So she set a secret plan into action and built a secret place where magic would be kept alive.
Her plan worked and the group built a town called Angolwen in the western mountains. #LIGHT_GREEN#*He marks it on your map, along with a portal to access it*#WHITE#
Not many people are accepted there but I will arrange for you to be allowed inside.]],
	answers = {
		{"Oh! How could such a place be kept secret for so long... This is interesting indeed, thank you for your trust!",
			action = function(npc, player)
				player:hasQuest("mage-apprentice"):access_angolwen(player)
				npc:die()
			end,
		},
	}
}

newChat{ id="thanks_mage",
	text = [[Ah yes! I am so glad! I will be able to go back to Angolwen now, and perhaps we will meet there.
Please take this ring; it has served me well.]],
	answers = {
		{"Thanks, and best luck in your studies!",
			action = function(npc, player)
				player:hasQuest("mage-apprentice"):ring_gift(player)
				npc:die()
			end,
		},
	}
}

return "welcome"
