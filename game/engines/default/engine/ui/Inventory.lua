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
local Base = require "engine.ui.Base"
local Focusable = require "engine.ui.Focusable"
local ImageList = require "engine.ui.ImageList"
local ListColumns = require "engine.ui.ListColumns"
local KeyBind = require "engine.KeyBind"

--- A generic inventory, with possible tabs
module(..., package.seeall, class.inherit(Base, Focusable))

function _M:init(t)
	self.inven = assert(t.inven, "no inventory inven")
	self.actor = assert(t.actor, "no inventory actor")
	self.w = assert(t.width, "no inventory width")
	self.h = assert(t.height, "no inventory height")
	self.tabslist = t.tabslist
	self.fct = t.fct
	self.on_select = t.select
	self.on_select_tab = t.select_tab
	self.on_drag = t.on_drag
	self.on_drag_end = t.on_drag_end

	Base.init(self, t)
end

function _M:generate()
	self.mouse:reset()
	self.key:reset()

	self.uis = {}

	if self.tabslist then
		self.c_tabs = ImageList.new{width=self.w, height=36, tile_w=32, tile_h=32, padding=5, force_size=true, selection="ctrl-multiple", list=self.tabslist, fct=function() self:generateList() end, on_select=function(item) self:selectTab(item) end}
		self.c_tabs.no_keyboard_focus = true
		if _M._last_tabs then
			for _, l in ipairs(_M._last_tabs) do self.c_tabs.dlist[l[1]][l[2]].selected = true end
		else
			self.c_tabs.dlist[1][1].selected = true
		end
		self.uis[#self.uis+1] = {x=0, y=0, ui=self.c_tabs}
	end

	self.c_inven = ListColumns.new{width=self.w, height=self.h - (self.c_tabs and self.c_tabs.h or 0), sortable=true, scrollbar=true, columns={
		{name="", width={20,"fixed"}, display_prop="char", sort="id"},
		{name="", width={24,"fixed"}, display_prop="object", sort="sortname", direct_draw=function(item, x, y) if item.object then item.object:toScreen(nil, x+4, y, 16, 16) end end},
		{name="Inventory", width=72, display_prop="name", sort="sortname"},
		{name="Category", width=20, display_prop="cat", sort="cat"},
		{name="Enc.", width=8, display_prop="encumberance", sort="encumberance"},
	}, list={},
		fct=function(item, sel, button, event) if self.fct then self.fct(item, button, event) end end,
		select=function(item, sel) if self.on_select then self.on_select(item, sel) end end,
		on_drag=function(item) if self.on_drag then self.on_drag(item) end end,
		on_drag_end=function() if self.on_drag_end then self.on_drag_end() end end,
	}

	self.c_inven.mouse.delegate_offset_x = 0
	self.c_inven.mouse.delegate_offset_y = self.c_tabs and self.c_tabs.h or 0

	self.uis[#self.uis+1] = {x=0, y=self.c_tabs and self.c_tabs.h or 0, ui=self.c_inven}

	self:generateList()

	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		self:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	end)
	self.key = self.c_inven.key
	self.key:addCommands{
		__TEXTINPUT = function(c)
			local list
			if self.focus_ui and self.focus_ui.ui == self.c_inven then list = self.c_inven.c_inven.list
			end
			if list and list.chars[c] then
				self:use(list[list.chars[c]])
			end
		end,
		_TAB = function() self.c_tabs.sel_j = 1 self.c_tabs.sel_i = util.boundWrap(self.c_tabs.sel_i+1, 1, #self.tabslist) self.c_tabs:onUse("left") end,
		[{"_TAB","ctrl"}] = function() self.c_tabs.sel_j = 1 self.c_tabs.sel_i = util.boundWrap(self.c_tabs.sel_i-1, 1, self.tabslist) self.c_tabs:onUse("left", false) end,
	}
	for i = 1, #self.tabslist do
		self.key:addCommands{
			['_F'..i] = function() self.c_tabs.sel_j = 1 self.c_tabs.sel_i = i self.c_tabs:onUse("left") end,
			[{'_F'..i,"ctrl"}] = function() self.c_tabs.sel_j = 1 self.c_tabs.sel_i = i self.c_tabs:onUse("left", true) end,
		}
	end
end

function _M:switchTab(filter)
	if not self.c_tabs then return end

	for i, d in ipairs(self.tabslist) do
		for k, e in pairs(filter) do if d[k] == e then
			self.c_tabs.sel_j = 1 self.c_tabs.sel_i = i self.c_tabs:onUse("left", false)
			return
		end end
	end
end

function _M:selectTab(item)
	if self.on_select_tab then self.on_select_tab(item) end
end

function _M:setInnerFocus(id)
	if self.focus_ui and self.focus_ui.ui.can_focus then self.focus_ui.ui:setFocus(false) end

	if type(id) == "table" then
		for i = 1, #self.uis do
			if self.uis[i].ui == id then id = i break end
		end
		if type(id) == "table" then self:no_focus() return end
	end

	local ui = self.uis[id]
	if not ui.ui.can_focus then self:no_focus() return end
	self.focus_ui = ui
	self.focus_ui_id = id
	ui.ui:setFocus(true)
	self:on_focus(id, ui)
end

function _M:on_focus(id, ui)
	if self.on_select and ui then self.on_select(ui, ui.ui.inven, ui.ui.item, ui.ui:getItem()) end
end
function _M:no_focus()
end

function _M:moveFocus(v)
	local id = self.focus_ui_id
	local start = id or 1
	local cnt = 0
	id = util.boundWrap((id or 1) + v, 1, #self.uis)
	while start ~= id and cnt <= #self.uis do
		if self.uis[id] and self.uis[id].ui and self.uis[id].ui.can_focus and not self.uis[id].ui.no_keyboard_focus then
			self:setInnerFocus(id)
			break
		end
		id = util.boundWrap(id + v, 1, #self.uis)
		cnt = cnt + 1
	end
end

function _M:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	-- Look for focus
	for i = 1, #self.uis do
		local ui = self.uis[i]
		if ui.ui.can_focus and bx >= ui.x and bx <= ui.x + ui.ui.w and by >= ui.y and by <= ui.y + ui.ui.h then
			self:setInnerFocus(i)

			-- Pass the event
			ui.ui.mouse:delegate(button, bx, by, xrel, yrel, bx, by, event)
			return
		end
	end
	self:no_focus()
end

function _M:keyEvent(...)
	if not self.focus_ui or not self.focus_ui.ui.key:receiveKey(...) then
		return KeyBind.receiveKey(self.key, ...)
	end
end

function _M:updateTabFilter()
	if not self.c_tabs then return end

	local list = self.c_tabs:getAllSelected()
	local checks = {}

	for i, item in ipairs(list) do
		if item.data.filter == "others" then
			local misc
			misc = function(o)
				-- Anything else
				for i, item in ipairs(self.tabslist) do
					if type(item.filter) == "function" and item.filter(o) then return false end
				end
				return true
			end
			checks[#checks+1] = misc
		else
			checks[#checks+1] = item.data.filter
		end
	end

	self.tab_filter = function(o)
		for i = 1, #checks do if checks[i](o) then return true end end
		return false
	end

	-- Save for next dialogs
	_M._last_tabs = self.c_tabs:getAllSelectedKeys()
end

function _M:generateList(no_update)
	self:updateTabFilter()

	-- Makes up the list
	self.inven_list = {}
	local list = self.inven_list
	local chars = {}
	local i = 1
	for item, o in ipairs(self.inven) do
		if (not self.filter or self.filter(o)) and (not self.tab_filter or self.tab_filter(o)) then
			local char = self:makeKeyChar(i)

			local enc = 0
			o:forAllStack(function(o) enc=enc+o.encumber end)

			list[#list+1] = { id=#list+1, char=char, name=o:getName(), sortname=o:getName():toString():removeColorCodes(), color=o:getDisplayColor(), object=o, inven=self.actor.INVEN_INVEN, item=item, cat=o.subtype, encumberance=enc, desc=o:getDesc() }
			chars[char] = #list
			i = i + 1
		end
	end
	list.chars = chars

	if not no_update then
		self.c_inven:setList(self.inven_list)
	end
end

function _M:display(x, y, nb_keyframes, ox, oy)
	-- UI elements
	for i = 1, #self.uis do
		local ui = self.uis[i]
		if not ui.hidden then ui.ui:display(x + ui.x, y + ui.y, nb_keyframes, ox + ui.x, oy + ui.y) end
	end
end