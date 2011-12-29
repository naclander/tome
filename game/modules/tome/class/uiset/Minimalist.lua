-- ToME - Tales of Maj'Eyal
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
local UISet = require "mod.class.uiset.UISet"
local DebugConsole = require "engine.DebugConsole"
local PlayerDisplay = require "mod.class.PlayerDisplay"
local HotkeysDisplay = require "engine.HotkeysDisplay"
local HotkeysIconsDisplay = require "engine.HotkeysIconsDisplay"
local ActorsSeenDisplay = require "engine.ActorsSeenDisplay"
local LogDisplay = require "engine.LogDisplay"
local LogFlasher = require "engine.LogFlasher"
local FlyingText = require "engine.FlyingText"
local Shader = require "engine.Shader"
local Tooltip = require "mod.class.Tooltip"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(UISet))

function _M:init()
	UISet.init(self)

	self.res = {}
	self.party = {}
	self.tbuff = {}
	self.pbuff = {}

	self.side_4 = 0
	self.side_6 = 0
end

function _M:activate()
	local size, size_mono, font, font_mono, font_mono_h, font_h
	if config.settings.tome.fonts.type == "fantasy" then
		size = ({normal=16, small=14, big=18})[config.settings.tome.fonts.size]
		size_mono = ({normal=14, small=10, big=16})[config.settings.tome.fonts.size]
		font = "/data/font/USENET_.ttf"
		font_mono = "/data/font/SVBasicManual.ttf"
	else
		size = ({normal=12, small=10, big=14})[config.settings.tome.fonts.size]
		size_mono = ({normal=12, small=10, big=14})[config.settings.tome.fonts.size]
		font = "/data/font/Vera.ttf"
		font_mono = "/data/font/VeraMono.ttf"
	end
	local f = core.display.newFont(font, size)
	font_h = f:lineSkip()
	f = core.display.newFont(font_mono, size_mono)
	font_mono_h = f:lineSkip()
	self.init_font = font
	self.init_size_font = size
	self.init_font_h = font_h
	self.init_font_mono = font_mono
	self.init_size_mono = size_mono
	self.init_font_mono_h = font_mono_h

	self.buff_font = core.display.newFont(font_mono, size_mono * 2, true)

	self.hotkeys_display_text = HotkeysDisplay.new(nil, 0, game.h - 52, game.w, 52, "/data/gfx/ui/talents-list.png", font_mono, size_mono)
	self.hotkeys_display_text:enableShadow(0.6)
	self.hotkeys_display_text:setColumns(3)
	self:resizeIconsHotkeysToolbar()

	self.logdisplay = LogDisplay.new(0, self.map_h_stop - font_h * config.settings.tome.log_lines -16, (game.w) / 2, font_h * config.settings.tome.log_lines, nil, font, size, nil, nil)
	self.logdisplay.resizeToLines = function() self.logdisplay:resize(0, self.map_h_stop - font_h * config.settings.tome.log_lines -16, (game.w) / 2, font_h * config.settings.tome.log_lines) end
	self.logdisplay:enableShadow(1)
	self.logdisplay:enableFading(config.settings.tome.log_fade or 3)

	profile.chat:resize(0 + (game.w) / 2, self.map_h_stop - font_h * config.settings.tome.log_lines -16, (game.w) / 2, font_h * config.settings.tome.log_lines, font, size, nil, nil)
	profile.chat.resizeToLines = function() profile.chat:resize(0 + (game.w) / 2, self.map_h_stop - font_h * config.settings.tome.log_lines -16, (game.w) / 2, font_h * config.settings.tome.log_lines) end
	profile.chat:enableShadow(1)
	profile.chat:enableFading(config.settings.tome.log_fade or 3)
	profile.chat:enableDisplayChans(false)

	self.npcs_display = ActorsSeenDisplay.new(nil, 0, game.h - font_mono_h * 4.2, game.w, font_mono_h * 4.2, "/data/gfx/ui/talents-list.png", font_mono, size_mono)
	self.npcs_display:setColumns(3)

	self.minimap_bg, self.minimap_bg_w, self.minimap_bg_h = core.display.loadImage("/data/gfx/ui/minimap.png"):glTexture()
	self:createSeparators()

	game.log = function(style, ...) if type(style) == "number" then game.uiset.logdisplay(...) else game.uiset.logdisplay(style, ...) end end
	game.logChat = function(style, ...)
		if true or not config.settings.tome.chat_log then return end
		if type(style) == "number" then
		local old = game.uiset.logdisplay.changed
		game.uiset.logdisplay(...) else game.uiset.logdisplay(style, ...) end
		if game.uiset.show_userchat then game.uiset.logdisplay.changed = old end
	end
	game.logSeen = function(e, style, ...) if e and e.x and e.y and game.level.map.seens(e.x, e.y) then game.log(style, ...) end end
	game.logPlayer = function(e, style, ...) if e == game.player or e == game.party then game.log(style, ...) end end
end

function _M:resizeIconsHotkeysToolbar()
	local h = 52
	if config.settings.tome.hotkey_icons then h = (4 + config.settings.tome.hotkey_icons_size) * config.settings.tome.hotkey_icons_rows end

	local oldstop = self.map_h_stop or (game.h - h)
	self.map_h_stop = game.h - h

	self.hotkeys_display_icons = HotkeysIconsDisplay.new(nil, 0, game.h - h, game.w, h, "/data/gfx/ui/talents-list.png", self.init_font_mono, self.init_size_mono, config.settings.tome.hotkey_icons_size, config.settings.tome.hotkey_icons_size)
	self.hotkeys_display_icons:enableShadow(0.6)

	if game.inited then
		game:resizeMapViewport(game.w, self.map_h_stop - 16)
		self.logdisplay.display_y = self.logdisplay.display_y + self.map_h_stop - oldstop
		profile.chat.display_y = profile.chat.display_y + self.map_h_stop - oldstop
		game:setupMouse()
	end

	self.hotkeys_display = config.settings.tome.hotkey_icons and self.hotkeys_display_icons or self.hotkeys_display_text
	self.hotkeys_display.actor = game.player
end


function _M:getMapSize()
	local w, h = core.display.size()
	return 0, 0, w, (self.map_h_stop or 80) - 16
end

--------------------------------------------------------------
-- UI stuff
--------------------------------------------------------------

local _sep_horiz = {core.display.loadImage("/data/gfx/ui/separator-hori.png")} _sep_horiz.tex = {_sep_horiz[1]:glTexture()}

local _log_icon, _log_icon_w, _log_icon_h = core.display.loadImage("/data/gfx/ui/log-icon.png"):glTexture()
local _chat_icon, _chat_icon_w, _chat_icon_h = core.display.loadImage("/data/gfx/ui/chat-icon.png"):glTexture()
local _talents_icon, _talents_icon_w, _talents_icon_h = core.display.loadImage("/data/gfx/ui/talents-icon.png"):glTexture()
local _actors_icon, _actors_icon_w, _actors_icon_h = core.display.loadImage("/data/gfx/ui/actors-icon.png"):glTexture()
local _main_menu_icon, _main_menu_icon_w, _main_menu_icon_h = core.display.loadImage("/data/gfx/ui/main-menu-icon.png"):glTexture()
local _inventory_icon, _inventory_icon_w, _inventory_icon_h = core.display.loadImage("/data/gfx/ui/inventory-icon.png"):glTexture()
local _charsheet_icon, _charsheet_icon_w, _charsheet_icon_h = core.display.loadImage("/data/gfx/ui/charsheet-icon.png"):glTexture()
local _mm_aggressive_icon, _mm_aggressive_icon_w, _mm_aggressive_icon_h = core.display.loadImage("/data/gfx/ui/aggressive-icon.png"):glTexture()
local _mm_passive_icon, _mm_passive_icon_w, _mm_passive_icon_h = core.display.loadImage("/data/gfx/ui/passive-icon.png"):glTexture()

function _M:displayUI()
	local middle = game.w * 0.5
	local bottom = game.h * 0.8
	local bottom_h = game.h * 0.2
	local icon_x = 0
	local icon_y = game.h - (_talents_icon_h * 1)
	local glow = (1+math.sin(core.game.getTime() / 500)) / 2 * 100 + 77
--[[
	-- Icons
	local x, y = icon_x, icon_y
	if (not self.show_npc_list) then
		_talents_icon:toScreenFull(x, y, _talents_icon_w, _talents_icon_h, _talents_icon_w, _talents_icon_h)
	else
		_actors_icon:toScreenFull(x, y, _actors_icon_w, _actors_icon_h, _actors_icon_w, _actors_icon_h)
	end
	x = x + _talents_icon_w

	_inventory_icon:toScreenFull(x, y, _inventory_icon_w, _inventory_icon_h, _inventory_icon_w, _inventory_icon_h)
	x = x + _talents_icon_w
	_charsheet_icon:toScreenFull(x, y, _charsheet_icon_w, _charsheet_icon_h, _charsheet_icon_w, _charsheet_icon_h)
	x = x + _talents_icon_w
	_main_menu_icon:toScreenFull(x, y, _main_menu_icon_w, _main_menu_icon_h, _main_menu_icon_w, _main_menu_icon_h)
	x = x + _talents_icon_w
	_log_icon:toScreenFull(x, y, _log_icon_w, _log_icon_h, _log_icon_w, _log_icon_h)
	x = x + _talents_icon_w
	if (not config.settings.tome.actor_based_movement_mode and not self.bump_attack_disabled) or (config.settings.tome.actor_based_movement_mode and not game.player.bump_attack_disabled) then
		_mm_aggressive_icon:toScreenFull(x, y, _mm_aggressive_icon_w, _mm_aggressive_icon_h, _mm_aggressive_icon_w, _mm_aggressive_icon_h)
	else
		_mm_passive_icon:toScreenFull(x, y, _mm_passive_icon_w, _mm_passive_icon_h, _mm_passive_icon_w, _mm_passive_icon_h)
	end
]]
	-- Separators
	_sep_horiz.tex[1]:toScreenFull(0, self.map_h_stop - _sep_horiz[3], game.w, _sep_horiz[3], _sep_horiz.tex[2], _sep_horiz.tex[3])
end

function _M:createSeparators()
	local icon_x = 0
	local icon_y = game.h - (_talents_icon_h * 1)
	self.icons = {
		display_x = icon_x,
		display_y = icon_y,
		w = 200,
		h = game.h - icon_y,
	}
end

function _M:clickIcon(bx, by)
	if bx < _talents_icon_w then
		game.key:triggerVirtual("TOGGLE_NPC_LIST")
	elseif bx < 2*_talents_icon_w then
		game.key:triggerVirtual("SHOW_INVENTORY")
	elseif bx < 3*_talents_icon_w then
		game.key:triggerVirtual("SHOW_CHARACTER_SHEET")
	elseif bx < 4*_talents_icon_w then
		game.key:triggerVirtual("EXIT")
	elseif bx < 5*_talents_icon_w then
		game.key:triggerVirtual("SHOW_MESSAGE_LOG")
	elseif bx < 6*_talents_icon_w then
		game.key:triggerVirtual("TOGGLE_BUMP_ATTACK")
	end
end

function _M:mouseIcon(bx, by)
	local virtual
	local key

	if bx < _talents_icon_w then
		virtual = "TOGGLE_NPC_LIST"
		key = game.key.binds_remap[virtual] ~= nil and game.key.binds_remap[virtual][1] or game.key:findBoundKeys(virtual)
		key = (key ~= nil and game.key:formatKeyString(key) or "unbound"):capitalize()
		if (not self.show_npc_list) then
			game:tooltipDisplayAtMap(game.w, game.h, "Displaying talents (#{bold}##GOLD#"..key.."#LAST##{normal}#)\nToggle for creature display")
		else
			game:tooltipDisplayAtMap(game.w, game.h, "Displaying creatures (#{bold}##GOLD#"..key.."#LAST##{normal}#)\nToggle for talent display#")
		end
	elseif bx < 2*_talents_icon_w then
		virtual = "SHOW_INVENTORY"
		key = game.key.binds_remap[virtual] ~= nil and game.key.binds_remap[virtual][1] or game.key:findBoundKeys(virtual)
		key = (key ~= nil and game.key:formatKeyString(key) or "unbound"):capitalize()
		if (key == "I") then
			game:tooltipDisplayAtMap(game.w, game.h, "#{bold}##GOLD#I#LAST##{normal}#nventory")
		else
			game:tooltipDisplayAtMap(game.w, game.h, "Inventory (#{bold}##GOLD#"..key.."#LAST##{normal}#)")
		end
	elseif bx < 3*_talents_icon_w then
		virtual = "SHOW_CHARACTER_SHEET"
		key = game.key.binds_remap[virtual] ~= nil and game.key.binds_remap[virtual][1] or game.key:findBoundKeys(virtual)
		key = (key ~= nil and game.key:formatKeyString(key) or "unbound"):capitalize()
		if (key == "C") then
			game:tooltipDisplayAtMap(game.w, game.h, "#{bold}##GOLD#C#LAST##{normal}#haracter Sheet")
		else
			game:tooltipDisplayAtMap(game.w, game.h, "Character Sheet (#{bold}##GOLD#"..key.."#LAST##{normal}#)")
		end
	elseif bx < 4*_talents_icon_w then
		virtual = "EXIT"
		key = game.key.binds_remap[virtual] ~= nil and game.key.binds_remap[virtual][1] or game.key:findBoundKeys(virtual)
		key = (key ~= nil and game.key:formatKeyString(key) or "unbound"):capitalize()
		game:tooltipDisplayAtMap(game.w, game.h, "Main menu (#{bold}##GOLD#"..key.."#LAST##{normal}#)")
	elseif bx < 5*_talents_icon_w then
		virtual = "SHOW_MESSAGE_LOG"
		key = game.key.binds_remap[virtual] ~= nil and game.key.binds_remap[virtual][1] or game.key:findBoundKeys(virtual)
		key = (key ~= nil and game.key:formatKeyString(key) or "unbound"):capitalize()
		game:tooltipDisplayAtMap(game.w, game.h, "Show message/chat log (#{bold}##GOLD#"..key.."#LAST##{normal}#)")
	elseif bx < 6*_talents_icon_w then
		virtual = "TOGGLE_BUMP_ATTACK"
		key = game.key.binds_remap[virtual] ~= nil and game.key.binds_remap[virtual][1] or game.key:findBoundKeys(virtual)
		key = (key ~= nil and game.key:formatKeyString(key) or "unbound"):capitalize()
		if (not config.settings.tome.actor_based_movement_mode and not self.bump_attack_disabled) or (config.settings.tome.actor_based_movement_mode and not game.player.bump_attack_disabled) then
			game:tooltipDisplayAtMap(game.w, game.h, "Movement: #LIGHT_GREEN#Default#LAST# (#{bold}##GOLD#"..key.."#LAST##{normal}#)\nToggle for passive mode")
		else
			game:tooltipDisplayAtMap(game.w, game.h, "Movement: #LIGHT_RED#Passive#LAST# (#{bold}##GOLD#"..key.."#LAST##{normal}#)\nToggle for default mode")
		end
	end
end

-- Load the various shaders used to display resources
air_c = {0x92/255, 0xe5, 0xe8}
air_sha = Shader.new("resources", {color=air_c, speed=100, amp=0.8, distort={2,2.5}})
life_c = {0xc0/255, 0, 0}
life_sha = Shader.new("resources", {color=life_c, speed=1000, distort={1.5,1.5}})
shield_c = {0.5, 0.5, 0.5}
shield_sha = Shader.new("resources", {color=shield_c, speed=5000, a=0.8, distort={0.5,0.5}})
stam_c = {0xff/255, 0xcc/255, 0x80/255}
stam_sha = Shader.new("resources", {color=stam_c, speed=700, distort={1,1.4}})
mana_c = {106/255, 146/255, 222/255}
mana_sha = Shader.new("resources", {color=mana_c, speed=1000, distort={0.4,0.4}})
soul_c = {128/255, 128/255, 128/255}
soul_sha = Shader.new("resources", {color=soul_c, speed=1200, distort={0.4,-0.4}})
equi_c = {0x00/255, 0xff/255, 0x74/255}
equi_sha = Shader.new("resources", {color=equi_c, amp=0.8, speed=20000, distort={0.3,0.25}})
paradox_c = {0x2f/255, 0xa0/255, 0xb4/255}
paradox_sha = Shader.new("resources", {color=paradox_c, amp=0.8, speed=20000, distort={0.1,0.25}})
pos_c = {colors.GOLD.r/255, colors.GOLD.g/255, colors.GOLD.b/255}
pos_sha = Shader.new("resources", {color=pos_c, speed=1000, distort={1.6,0.2}})
neg_c = {colors.DARK_GREY.r/255, colors.DARK_GREY.g/255, colors.DARK_GREY.b/255}
neg_sha = Shader.new("resources", {color=neg_c, speed=1000, distort={1.6,-0.2}})
vim_c = {0x90/255, 0x40/255, 0x10/255}
vim_sha = Shader.new("resources", {color=vim_c, speed=1000, distort={0.4,0.4}})
hate_c = {colors.GREY.r/255, colors.GREY.g/255, colors.GREY.b/255}
hate_sha = Shader.new("resources", {color=hate_c, speed=1000, distort={0.4,0.4}})
psi_c = {colors.BLUE.r/255, colors.BLUE.g/255, colors.BLUE.b/255}
psi_sha = Shader.new("resources", {color=psi_c, speed=2000, distort={0.4,0.4}})
save_c = pos_c
save_sha = pos_sha

sshat = {core.display.loadImage("/data/gfx/ui/resources/shadow.png"):glTexture()}
bshat = {core.display.loadImage("/data/gfx/ui/resources/back.png"):glTexture()}
shat = {core.display.loadImage("/data/gfx/ui/resources/fill.png"):glTexture()}
fshat = {core.display.loadImage("/data/gfx/ui/resources/front.png"):glTexture()}
fshat_life = {core.display.loadImage("/data/gfx/ui/resources/front_life.png"):glTexture()}
fshat_life_dark = {core.display.loadImage("/data/gfx/ui/resources/front_life_dark.png"):glTexture()}
fshat_shield = {core.display.loadImage("/data/gfx/ui/resources/front_life_armored.png"):glTexture()}
fshat_shield_dark = {core.display.loadImage("/data/gfx/ui/resources/front_life_armored_dark.png"):glTexture()}
fshat_stamina = {core.display.loadImage("/data/gfx/ui/resources/front_stamina.png"):glTexture()}
fshat_stamina_dark = {core.display.loadImage("/data/gfx/ui/resources/front_stamina_dark.png"):glTexture()}
fshat_mana = {core.display.loadImage("/data/gfx/ui/resources/front_mana.png"):glTexture()}
fshat_mana_dark = {core.display.loadImage("/data/gfx/ui/resources/front_mana_dark.png"):glTexture()}
fshat_soul = {core.display.loadImage("/data/gfx/ui/resources/front_souls.png"):glTexture()}
fshat_soul_dark = {core.display.loadImage("/data/gfx/ui/resources/front_souls_dark.png"):glTexture()}
fshat_equi = {core.display.loadImage("/data/gfx/ui/resources/front_nature.png"):glTexture()}
fshat_equi_dark = {core.display.loadImage("/data/gfx/ui/resources/front_nature_dark.png"):glTexture()}
fshat_paradox = {core.display.loadImage("/data/gfx/ui/resources/front_paradox.png"):glTexture()}
fshat_paradox_dark = {core.display.loadImage("/data/gfx/ui/resources/front_paradox_dark.png"):glTexture()}
fshat_hate = {core.display.loadImage("/data/gfx/ui/resources/front_hate.png"):glTexture()}
fshat_hate_dark = {core.display.loadImage("/data/gfx/ui/resources/front_hate_dark.png"):glTexture()}
fshat_positive = {core.display.loadImage("/data/gfx/ui/resources/front_positive.png"):glTexture()}
fshat_positive_dark = {core.display.loadImage("/data/gfx/ui/resources/front_positive_dark.png"):glTexture()}
fshat_negative = {core.display.loadImage("/data/gfx/ui/resources/front_negative.png"):glTexture()}
fshat_negative_dark = {core.display.loadImage("/data/gfx/ui/resources/front_negative_dark.png"):glTexture()}
fshat_vim = {core.display.loadImage("/data/gfx/ui/resources/front_vim.png"):glTexture()}
fshat_vim_dark = {core.display.loadImage("/data/gfx/ui/resources/front_vim_dark.png"):glTexture()}
fshat_psi = {core.display.loadImage("/data/gfx/ui/resources/front_psi.png"):glTexture()}
fshat_psi_dark = {core.display.loadImage("/data/gfx/ui/resources/front_psi_dark.png"):glTexture()}
fshat_air = {core.display.loadImage("/data/gfx/ui/resources/front_air.png"):glTexture()}
fshat_air_dark = {core.display.loadImage("/data/gfx/ui/resources/front_air_dark.png"):glTexture()}

font_sha = core.display.newFont("/data/font/USENET_.ttf", 14, true)
font_sha:setStyle("bold")
sfont_sha = core.display.newFont("/data/font/USENET_.ttf", 12, true)
sfont_sha:setStyle("bold")

function _M:displayResources(scale)
	local player = game.player
	if player then
		local stop = self.map_h_stop - fshat[7]
		local x, y = 0, 0

		-----------------------------------------------------------------------------------
		-- Air
		if player.air < player.max_air then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if air_sha.shad then air_sha.shad:use(true) end
			local p = player:getAir() / player.max_air
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], air_c[1], air_c[2], air_c[3], 1)
			if air_sha.shad then air_sha.shad:use(false) end

			if not self.res.air or self.res.air.vc ~= player.air or self.res.air.vm ~= player.max_air or self.res.air.vr ~= player.air_regen then
				self.res.air = {
					vc = player.air, vm = player.max_air, vr = player.air_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.air, player.max_air), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.air_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.air.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.air.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_air_dark
			if player.air >= player.max_air * 0.5 then front = fshat_air end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Life & shield
		sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
		bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
		if life_sha.shad then life_sha.shad:use(true) end
		local p = math.min(1, math.max(0, player.life / player.max_life))
		shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], life_c[1], life_c[2], life_c[3], 1)
		if life_sha.shad then life_sha.shad:use(false) end

		if not self.res.life or self.res.life.vc ~= player.life or self.res.life.vm ~= player.max_life or self.res.life.vr ~= player.life_regen then
			self.res.life = {
				vc = player.life, vm = player.max_life, vr = player.life_regen,
				cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.life, player.max_life), 255, 255, 255):glTexture()},
				regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.life_regen), 255, 255, 255):glTexture()},
			}
		end
		local dt = self.res.life.cur
		dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
		dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
		dt = self.res.life.regen
		dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
		dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

		local shield, max_shield = 0, 0
		if player:attr("time_shield") then shield = shield + player.time_shield_absorb max_shield = max_shield + player.time_shield_absorb_max end
		if player:attr("damage_shield") then shield = shield + player.damage_shield_absorb max_shield = max_shield + player.damage_shield_absorb_max end
		if player:attr("displacement_shield") then shield = shield + player.displacement_shield max_shield = max_shield + player.displacement_shield_max end
		if max_shield > 0 then
			if shield_sha.shad then shield_sha.shad:use(true) end
			local p = math.min(1, math.max(0, shield / max_shield))
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], shield_c[1], shield_c[2], shield_c[3], 0.8)
			if shield_sha.shad then shield_sha.shad:use(false) end
		end

		local front = fshat_life_dark
		if max_shield > 0 then
			front = fshat_shield_dark
			if shield >= max_shield * 0.8 then front = fshat_shield end
		elseif player.life >= player.max_life then front = fshat_life end
		front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
		y = y + fshat[7]
		if y > stop then x = x + fshat[6] y = 0 end

		-----------------------------------------------------------------------------------
		-- Stamina
		if player:knowTalent(player.T_STAMINA_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if stam_sha.shad then stam_sha.shad:use(true) end
			local p = player:getStamina() / player.max_stamina
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], stam_c[1], stam_c[2], stam_c[3], 1)
			if stam_sha.shad then stam_sha.shad:use(false) end

			if not self.res.stamina or self.res.stamina.vc ~= player.stamina or self.res.stamina.vm ~= player.max_stamina or self.res.stamina.vr ~= player.stamina_regen then
				self.res.stamina = {
					vc = player.stamina, vm = player.max_stamina, vr = player.stamina_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.stamina, player.max_stamina), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.stamina_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.stamina.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.stamina.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_stamina_dark
			if player.stamina >= player.max_stamina then front = fshat_stamina end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Mana
		if player:knowTalent(player.T_MANA_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if mana_sha.shad then mana_sha.shad:use(true) end
			local p = player:getMana() / player.max_mana
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], mana_c[1], mana_c[2], mana_c[3], 1)
			if mana_sha.shad then mana_sha.shad:use(false) end

			if not self.res.mana or self.res.mana.vc ~= player.mana or self.res.mana.vm ~= player.max_mana or self.res.mana.vr ~= player.mana_regen then
				self.res.mana = {
					vc = player.mana, vm = player.max_mana, vr = player.mana_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.mana, player.max_mana), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.mana_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.mana.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.mana.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_mana_dark
			if player.mana >= player.max_mana then front = fshat_mana end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Souls
		if player:isTalentActive(player.T_NECROTIC_AURA) then
			local pt = player:isTalentActive(player.T_NECROTIC_AURA)

			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if soul_sha.shad then soul_sha.shad:use(true) end
			local p = pt.souls / pt.souls_max
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], soul_c[1], soul_c[2], soul_c[3], 1)
			if soul_sha.shad then soul_sha.shad:use(false) end

			if not self.res.soul or self.res.soul.vc ~= pt.souls or self.res.soul.vm ~= pt.souls_max then
				self.res.soul = {
					vc = pt.souls, vm = player.souls_max,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(pt.souls, pt.souls_max), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.soul.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_soul_dark
			if pt.souls >= pt.souls_max then front = fshat_soul end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Equilibirum
		if player:knowTalent(player.T_EQUILIBRIUM_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			local _, chance = player:equilibriumChance()
			local s = math.max(50, 10000 - (math.sqrt(100 - chance) * 2000))
			if equi_sha.shad then
				equi_sha:setUniform("speed", s)
				equi_sha.shad:use(true)
			end
			local p = 1
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], equi_c[1], equi_c[2], equi_c[3], 1)
			if equi_sha.shad then equi_sha.shad:use(false) end

			if not self.res.equilibrium or self.res.equilibrium.vc ~= player.equilibrium or self.res.equilibrium.vr ~= chance then
				self.res.equilibrium = {
					vc = player.equilibrium, vr = chance,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d"):format(player.equilibrium), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%d%%"):format(100-chance), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.equilibrium.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.equilibrium.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_equi
			if chance <= 85 then front = fshat_equi_dark end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Positive
		if player:knowTalent(player.T_POSITIVE_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if pos_sha.shad then pos_sha.shad:use(true) end
			local p = player:getPositive() / player.max_positive
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], pos_c[1], pos_c[2], pos_c[3], 1)
			if pos_sha.shad then pos_sha.shad:use(false) end

			if not self.res.positive or self.res.positive.vc ~= player.positive or self.res.positive.vm ~= player.max_positive or self.res.positive.vr ~= player.positive_regen then
				self.res.positive = {
					vc = player.positive, vm = player.max_positive, vr = player.positive_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.positive, player.max_positive), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.positive_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.positive.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.positive.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_positive_dark
			if player.positive >= player.max_positive * 0.7 then front = fshat_positive end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Negative
		if player:knowTalent(player.T_NEGATIVE_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if neg_sha.shad then neg_sha.shad:use(true) end
			local p = player:getNegative() / player.max_negative
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], neg_c[1], neg_c[2], neg_c[3], 1)
			if neg_sha.shad then neg_sha.shad:use(false) end

			if not self.res.negative or self.res.negative.vc ~= player.negative or self.res.negative.vm ~= player.max_negative or self.res.negative.vr ~= player.negative_regen then
				self.res.negative = {
					vc = player.negative, vm = player.max_negative, vr = player.negative_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.negative, player.max_negative), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.negative_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.negative.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.negative.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_negative_dark
			if player.negative >= player.max_negative * 0.7  then front = fshat_negative end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Paradox
		if player:knowTalent(player.T_PARADOX_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			local _, chance = player:paradoxFailChance()
			local s = math.max(50, 10000 - (math.sqrt(chance) * 2000))
			if paradox_sha.shad then
				paradox_sha:setUniform("speed", s)
				paradox_sha.shad:use(true)
			end
			local p = 1
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], paradox_c[1], paradox_c[2], paradox_c[3], 1)
			if paradox_sha.shad then paradox_sha.shad:use(false) end

			if not self.res.paradox or self.res.paradox.vc ~= player.paradox or self.res.paradox.vr ~= chance then
				self.res.paradox = {
					vc = player.paradox, vr = chance,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d"):format(player.paradox), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%d%%"):format(chance), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.paradox.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.paradox.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_paradox
			if chance <= 10 then front = fshat_paradox_dark end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Vim
		if player:knowTalent(player.T_VIM_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if vim_sha.shad then vim_sha.shad:use(true) end
			local p = player:getVim() / player.max_vim
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], vim_c[1], vim_c[2], vim_c[3], 1)
			if vim_sha.shad then vim_sha.shad:use(false) end

			if not self.res.vim or self.res.vim.vc ~= player.vim or self.res.vim.vm ~= player.max_vim or self.res.vim.vr ~= player.vim_regen then
				self.res.vim = {
					vc = player.vim, vm = player.max_vim, vr = player.vim_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.vim, player.max_vim), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.vim_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.vim.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.vim.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_vim_dark
			if player.vim >= player.max_vim then front = fshat_vim end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Hate
		if player:knowTalent(player.T_HATE_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if hate_sha.shad then hate_sha.shad:use(true) end
			local p = player:getHate() / player.max_hate
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], hate_c[1], hate_c[2], hate_c[3], 1)
			if hate_sha.shad then hate_sha.shad:use(false) end

			if not self.res.hate or self.res.hate.vc ~= player.hate or self.res.hate.vm ~= player.max_hate or self.res.hate.vr ~= player.hate_regen then
				self.res.hate = {
					vc = player.hate, vm = player.max_hate, vr = player.hate_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.hate, player.max_hate), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.hate_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.hate.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.hate.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_hate_dark
			if player.hate >= 10 then front = fshat_hate end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Psi
		if player:knowTalent(player.T_PSI_POOL) then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if psi_sha.shad then psi_sha.shad:use(true) end
			local p = player:getPsi() / player.max_psi
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], psi_c[1], psi_c[2], psi_c[3], 1)
			if psi_sha.shad then psi_sha.shad:use(false) end

			if not self.res.psi or self.res.psi.vc ~= player.psi or self.res.psi.vm ~= player.max_psi or self.res.psi.vr ~= player.psi_regen then
				self.res.psi = {
					vc = player.psi, vm = player.max_psi, vr = player.psi_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.psi, player.max_psi), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.psi_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.psi.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])
			dt = self.res.psi.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat_psi_dark
			if player.psi >= player.max_psi then front = fshat_psi end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-----------------------------------------------------------------------------------
		-- Saving
		if savefile_pipe.saving then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3])
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3])
			if save_sha.shad then save_sha.shad:use(true) end
			local p = savefile_pipe.current_nb / savefile_pipe.total_nb
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], save_c[1], save_c[2], save_c[3], 1)
			if save_sha.shad then save_sha.shad:use(false) end

			if not self.res.save or self.res.save.vc ~= p then
				self.res.save = {
					vc = p,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("Saving... %d%%"):format(p * 100), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.save.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3])

			local front = fshat
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3])
			y = y + fshat[7]
			if y > stop then x = x + fshat[6] y = 0 end
		end

		-- Compute how much space to reserve on the side
		self.side_4 = x + fshat[6]
		Map.viewport_padding_4 = math.floor(scale * (self.side_4 / Map.tile_w))
	end
end

icon_green = { core.display.loadImage("/data/gfx/ui/talent_frame_ok.png"):glTexture() }
icon_yellow = { core.display.loadImage("/data/gfx/ui/talent_frame_sustain.png"):glTexture() }
icon_red = { core.display.loadImage("/data/gfx/ui/talent_frame_cooldown.png"):glTexture() }

function _M:handleEffect(player, eff_id, e, p, x, y, hs, bx, by)
	local dur = p.dur + 1

	if not self.tbuff[eff_id..":"..dur] then
		local name = e.desc
		local desc = nil
		local eff_subtype = table.concat(table.keys(e.subtype), "/")
		if e.display_desc then name = e.display_desc(self, p) end
		if p.save_string and p.amount_decreased and p.maximum and p.total_dur then
			desc = ("#{bold}##GOLD#%s\n(%s: %s)#WHITE##{normal}#\n"):format(name, e.type, eff_subtype)..e.long_desc(player, p).." "..("%s reduced the duration of this effect by %d turns, from %d to %d."):format(p.save_string, p.amount_decreased, p.maximum, p.total_dur)
		else
			desc = ("#{bold}##GOLD#%s\n(%s: %s)#WHITE##{normal}#\n"):format(name, e.type, eff_subtype)..e.long_desc(player, p)
		end

		local txt = nil
		if e.decrease > 0 then
			dur = tostring(dur)
			txt = self.buff_font:draw(dur, 40, colors.WHITE.r, colors.WHITE.g, colors.WHITE.b, true)[1]
			txt.fw, txt.fh = self.buff_font:size(dur)
		end
		local icon = e.status ~= "detrimental" and icon_green or icon_red

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, desc)
		end
		if not game.mouse:updateZone("tbuff"..eff_id, bx+x, by+y, hs, hs, desc_fct) then
			game.mouse:unregisterZone("tbuff"..eff_id)
			game.mouse:registerZone(bx+x, by+y, hs, hs, desc_fct, nil, "tbuff"..eff_id)
		end

		self.tbuff[eff_id..":"..dur] = {eff_id, "tbuff"..eff_id, function(x, y)
			core.display.drawQuad(x, y, hs, hs, 0, 0, 0, 255)
			e.display_entity:toScreen(self.hotkeys_display_icons.tiles, x+4, y+4, 32, 32)
			icon[1]:toScreenFull(x, y, hs, hs, icon[2] * hs / icon[6], icon[3] * hs / icon[7], 255, 255, 255, 255)
			if txt then
				txt._tex:toScreenFull(x+4+2 + (40 - txt.fw)/2, y+4+2 + (40 - txt.fh)/2, txt.w, txt.h, txt._tex_w, txt._tex_h, 0, 0, 0, 0.7)
				txt._tex:toScreenFull(x+4 + (40 - txt.fw)/2, y+4 + (40 - txt.fh)/2, txt.w, txt.h, txt._tex_w, txt._tex_h)
			end
		end}
	end

	self.tbuff[eff_id..":"..dur][3](x, y)
end

function _M:displayBuffs(scale, bx, by)
	local player = game.player
	if player then
		if player.changed then
			for _, d in pairs(self.pbuff) do if not player.sustain_talents[d[1]] then game.mouse:unregisterZone(d[2]) end end
			for _, d in pairs(self.tbuff) do if not player.tmp[d[1]] then game.mouse:unregisterZone(d[2]) end end
			self.tbuff = {} self.pbuff = {}
		end

		local hs = 40
		local stop = self.map_h_stop - hs
		local x, y = -hs, 0

		for tid, act in pairs(player.sustain_talents) do
			if act then
				if not self.pbuff[tid] then
					local t = player:getTalentFromId(tid)
					local displayName = t.name
					if t.getDisplayName then displayName = t.getDisplayName(player, t, player:isTalentActive(tid)) end
					local desc = "#GOLD##{bold}#"..displayName.."#{normal}##WHITE#\n"..tostring(player:getTalentFullDescription(t))

					if not game.mouse:updateZone("pbuff"..tid, bx+x, by+y, hs, hs) then
						game.mouse:unregisterZone("pbuff"..tid)
						game.mouse:registerZone(bx+x, by+y, hs, hs, function(button, mx, my, xrel, yrel, bx, by, event)
							game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, desc)
						end, nil, "pbuff"..tid)
					end

					self.pbuff[tid] = {tid, "pbuff"..tid, function(x, y)
						core.display.drawQuad(x, y, hs, hs, 0, 0, 0, 255)
						t.display_entity:toScreen(self.hotkeys_display_icons.tiles, x+4, y+4, 32, 32)
						icon_yellow[1]:toScreenFull(x, y, hs, hs, icon_yellow[2] * hs / icon_yellow[6], icon_yellow[3] * hs / icon_yellow[7], 255, 255, 255, 255)
					end}
				end

				self.pbuff[tid][3](x, y)

				y = y + hs
				if y + hs >= stop then y = 0 x = x - hs end
			end
		end

		local good_e, bad_e = {}, {}
		for eff_id, p in pairs(player.tmp) do
			local e = player.tempeffect_def[eff_id]
			if e.status == "detrimental" then bad_e[eff_id] = p else good_e[eff_id] = p end
		end

		for eff_id, p in pairs(good_e) do
			local e = player.tempeffect_def[eff_id]
			self:handleEffect(player, eff_id, e, p, x, y, hs, bx, by)
			y = y + hs
			if y + hs >= stop then y = 0 x = x - hs end
		end
		for eff_id, p in pairs(bad_e) do
			local e = player.tempeffect_def[eff_id]
			self:handleEffect(player, eff_id, e, p, x, y, hs, bx, by)
			y = y + hs
			if y + hs >= stop then y = 0 x = x - hs end
		end
	end
end

local portrait = {core.display.loadImage("/data/gfx/ui/party-portrait.png"):glTexture()}
local portrait_unsel = {core.display.loadImage("/data/gfx/ui/party-portrait-unselect.png"):glTexture()}

function _M:displayParty(scale, bx, by)
	if game.player.changed and next(self.party) then
		for a, d in pairs(self.party) do if not game.party:hasMember(a) then game.mouse:unregisterZone(d[2]) print("==UNREG part ", d[1].name, d[2]) end end
		self.party = {}
	end

	-- Party members
	if #game.party.m_list >= 2 and game.level then
		local hs = portrait[7] + 3
		local stop = self.map_h_stop - hs
		local x, y = 0, 0

		for i = 1, #game.party.m_list do
			local a = game.party.m_list[i]

			if not self.party[a] then
				local def = game.party.members[a]

				self.party[a] = {a, "party"..a.uid, function(x, y)
					core.display.drawQuad(x, y, 40, 40, 0, 0, 0, 255)
					if life_sha.shad then life_sha.shad:use(true) end
					local p = math.min(1, math.max(0, a.life / a.max_life))
					core.display.drawQuad(x+1, y+1 + (1-p)*hs, 38, p*38, life_c[1]*255, life_c[2]*255, life_c[3]*255, 178)
					if life_sha.shad then life_sha.shad:use(false) end

					a:toScreen(nil, x+4, y+4, 32, 32)
					local p = (game.player == a) and portrait or portrait_unsel
					p[1]:toScreenFull(x, y, p[6], p[7], p[2], p[3])
				end}

				local text = "#GOLD##{bold}#"..a.name.."\n#WHITE##{normal}#Life: "..math.floor(100 * a.life / a.max_life).."%\nLevel: "..a.level.."\n"..def.title
				local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
					game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, text)
					if event == "button" and button == "left" then if def.control == "full" then game.party:select(a) end end
				end
				if not game.mouse:updateZone("party"..a.uid, bx+x, by+y, hs, hs, desc_fct) then
					game.mouse:unregisterZone("party"..a.uid)
					game.mouse:registerZone(bx+x, by+y, hs, hs, desc_fct, nil, "party"..a.uid)
				end
			end

			self.party[a][3](x, y)

			x = x + hs
			if x + hs > stop then x = 0 y = y - hs end
		end

		-- Compute how much space to reserve on the side
		Map.viewport_padding_8 = math.floor(scale * y / Map.tile_w)
	end
end

function _M:display(nb_keyframes)
	-- Now the map, if any
	game:displayMap(nb_keyframes)

	-- Resources
	local d = core.display
	d.glTranslate(0, 0, 0)
	self:displayResources(1)
	d.glTranslate(-0, -0, -0)

	-- Buffs
	local d = core.display
	d.glTranslate(game.w, 0, 0)
	self:displayBuffs(1, game.w, 0)
	d.glTranslate(-game.w, -0, -0)

	-- Party
	local d = core.display
	d.glTranslate(self.side_4, 0, 0)
	self:displayParty(1, self.side_4, 0)
	d.glTranslate(-self.side_4, -0, -0)

	-- We display the player's interface
	profile.chat:toScreen()
	self.logdisplay:toScreen()

	if self.show_npc_list then
		self.npcs_display:toScreen()
	else
		self.hotkeys_display:toScreen()
	end

	-- UI
	self:displayUI()
end

function _M:setupMouse(mouse)
	-- Scroll message log
	mouse:registerZone(profile.chat.display_x, profile.chat.display_y, profile.chat.w, profile.chat.h, function(button, mx, my, xrel, yrel, bx, by, event)
		profile.chat.mouse:delegate(button, mx, my, xrel, yrel, bx, by, event)
	end)
	-- Use hotkeys with mouse
	mouse:registerZone(self.hotkeys_display.display_x, self.hotkeys_display.display_y, game.w, game.h, function(button, mx, my, xrel, yrel, bx, by, event)
		if self.show_npc_list then return end
		if event == "out" then self.hotkeys_display.cur_sel = nil return end
		if event == "button" and button == "left" and ((self.zone and self.zone.wilderness) or (game.key ~= game.normal_key)) then return end
		self.hotkeys_display:onMouse(button, mx, my, event == "button",
			function(text)
				text = text:toTString()
				text:add(true, "---", true, {"font","italic"}, {"color","GOLD"}, "Left click to use", true, "Right click to configure", true, "Press 'm' to setup", {"color","LAST"}, {"font","normal"})
				game:tooltipDisplayAtMap(game.w, game.h, text)
			end,
			function(i, hk)
				if button == "right" and hk[1] == "talent" then
					local d = require("mod.dialogs.UseTalents").new(game.player)
					d:use({talent=hk[2], name=game.player:getTalentFromId(hk[2]).name}, "right")
					return true
				end
			end
		)
	end, nil, "hotkeys", true)
	-- Use icons
	mouse:registerZone(self.icons.display_x, self.icons.display_y, self.icons.w, self.icons.h, function(button, mx, my, xrel, yrel, bx, by, event)
		self:mouseIcon(bx, by)
		if button == "left" and event == "button" then self:clickIcon(bx, by) end
	end)
	-- Move using the minimap
	mouse:registerZone(0, 0, 200, 200, function(button, mx, my, xrel, yrel, bx, by, event)
		if button == "left" and not xrel and not yrel and event == "button" then
			local tmx, tmy = math.floor(bx / 4), math.floor(by / 4)
			game.player:mouseMove(tmx + self.minimap_scroll_x, tmy + self.minimap_scroll_y)
		elseif button == "right" then
			local tmx, tmy = math.floor(bx / 4), math.floor(by / 4)
			self.level.map:moveViewSurround(tmx + self.minimap_scroll_x, tmy + self.minimap_scroll_y, 1000, 1000)
		end
	end)
	-- Chat tooltips
	profile.chat:onMouse(function(user, item, button, event, x, y, xrel, yrel, bx, by)
		local mx, my = core.mouse.get()
		if not item or not user or item.faded == 0 then game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap") return end

		local str = tstring{{"color","GOLD"}, {"font","bold"}, user.name, {"color","LAST"}, {"font","normal"}, true}
		if user.donator and user.donator ~= "none" then
			local text, color = "Donator", colors.WHITE
			if user.donator == "oneshot" then text, color = "Donator", colors.LIGHT_GREEN
			elseif user.donator == "recurring" then text, color = "Recurring Donator", colors.LIGHT_BLUE end
			str:add({"color",unpack(colors.simple(color))}, text, {"color", "LAST"}, true)
		end
		str:add({"color","ANTIQUE_WHITE"}, "Playing: ", {"color", "LAST"}, user.current_char, true)
		str:add({"color","ANTIQUE_WHITE"}, "Game: ", {"color", "LAST"}, user.module, "(", user.valid, ")",true)

		local extra = {}
		if item.extra_data and item.extra_data.mode == "tooltip" then
			local rstr = tstring{item.extra_data.tooltip, true, "---", true, "Linked by: "}
			rstr:merge(str)
			extra.log_str = rstr
		else
			extra.log_str = str
			if button == "right" and event == "button" then
				extra.add_map_action = { name="Show chat user", fct=function() profile.chat:showUserInfo(user.login) end }
			end
		end
		game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap", extra)
	end)
end
