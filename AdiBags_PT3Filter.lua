--[[
AdiBags_PT3Filter - LibPeriodicTable-3.1 item filters for AdiBags.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local _, ns = ...
local L = ns.L
local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')

-- The filter itself

local filter = addon:RegisterFilter("PT3Filter", 80, 'AceEvent-3.0')
filter.uiName = L['LibPeriodicTable-3.1 filter']
filter.uiDesc = L['Dispatch items using rules based on LibPeriodicTable-3.1 item sets.']

local LPT = LibStub('LibPeriodicTable-3.1')

function filter:OnInitialize()
	self.db = addon.db:RegisterNamespace('PT3Filter', {
		profile = {
			rules = {
				['*'] = {
					dynamicSection = false,
					sectionIndex = -1,
					priority = 50,
					include = {},
					exclude = {}
				}
			}
		}
	})
end

function filter:OnEnable()
	self:UpdateRules()
	addon:UpdateFilters()
end

function filter:OnDisable()
	addon:UpdateFilters()
end

--------------------------------------------------------------------------------
-- Actual filtering, using a cache
--------------------------------------------------------------------------------

local InternalFilter

local filterCache = setmetatable({}, {__index = function(t, id)
	if not id then return end
	local result = InternalFilter(id) or false
	t[id] = result
	return result
end})

function filter:Filter(slotData)
	local category = filterCache[slotData.itemId]
	if category then
		return strsplit('#', category)
	end
end

--------------------------------------------------------------------------------
-- Rule ordering
--------------------------------------------------------------------------------

local orderedRules = {}

local function CompareRules(a, b)
	if a.priority == b.priority then
		return a.name < b.name
	else
		return a.priority > b.priority
	end
end

function filter:UpdateRules()
	wipe(filterCache)
	wipe(orderedRules)
	for key, rule in pairs(self.db.profile.rules) do
		tinsert(orderedRules, rule)
	end
	table.sort(orderedRules, CompareRules)
	self:UpdateOptions()
	filter:SendMessage('AdiBags_FiltersChanged')
end

--------------------------------------------------------------------------------
-- Internal filter function
--------------------------------------------------------------------------------

local function GetSetPart(index, ...)
	local num = select('#', ...)
	if index < 0 then
		index = num + 1 + index
	elseif idnex > num then
		index = num
	end
	if index < 1 then
		index = 1
	end
	return (select(index, ...))
end

function InternalFilter(id)
	for index, rule in ipairs(orderedRules) do
		local foundInSet = nil
		for i, set in pairs(rule.include) do
			local found, setName = LPT:ItemInSet(id, set)
			if found and setName then
				foundInSet = setName
				break
			end
		end
		if foundInSet then
			for i, set in pairs(rule.exclude) do
				if LPT:ItemInSet(id, set) then
					foundInSet = nil
					break
				end
			end
			if foundInSet then
				local dynamicSection = rule.dynamicSection and L[GetSetPart(rule.sectionIndex, strsplit('.', foundInSet)) or false]
				return strjoin('#', dynamicSection or rule.section, rule.category)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

local options
function filter:GetOptions()
	if not options then
		local newName
		options = {
			newRule = {
				type = 'group',
				name = L["New Rule"],
				desc = L["Use this section to create a brand new rule."],
				inline = true,
				order = 1,
				args = {
					name = {
						type = 'input',
						name = L['Name'],
						desc = L["The name of the rule to create. This is purely informative."],
						order = 10,
						get = function() return newName end,
						set = function(_, value) newName = value ~= "" and value or nil end,
					},
					create = {
						type = 'execute',
						name = L['Create'],
						order = 20,
						func = function()
							local rule = self.db.profile.rules[newName]
							rule.name = newName
							newName = nil
							self:UpdateRules()
						end,
						disabled = function() return not newName or rawget(self.db.profile.rules, newName) end,
					},
				},
			},
		}
		filter:UpdateOptions()
	end
	return options
end

local categoryValues = {}
for name in addon:IterateCategories() do
	categoryValues[name] = name
end

local ruleOptionProto = {
	type = 'group',
	inline = true,
	set = "Set",
	get = "Get",
	disabled = false,
	args = {
		dynamicSection = {
			type = 'toggle',
			name = L['Dynamic section name'],
			desc = L["Check this to have the section name calculated from matching item set. If unchecked, you provide a fixed section name."],
			order = 10,			
		},
		section = {
			type = 'input',
			name = L['Fixed section name'],
			desc = L["Fixed bag section name."],
			order = 20,
			validate = function(_, value) return value and value:trim() ~= "" end,
			hidden = function(info) return info.handler:GetDB(info).dynamicSection end,
		},
		sectionIndex = {
			type = 'input',
			name = L['Dynamic section name index'],
			desc = L["PT3 set names look like 'This.Item.Set'. This settings allow to use any part of the matching item set name as the section name, e.g. 'This', 'Item' or 'Set'."],
			usage = L["Positive numbers are counted from the beginning of the set name (1 = first part). Negative from end (-1 = last part)."],
			order = 20,
			validate = function(_, value) return (tonumber(value) or 0) ~= 0 or format(L["Invalid index: %q"], value) end,
			get = function(info) return tostring(info.handler:Get(info)) end,
			set = function(info, value) return info.handler:Set(info, tonumber(value)) end,
			hidden = function(info) return not info.handler:GetDB(info).dynamicSection end,
		},
		category = {
			type = 'select',
			name = L['Section category'],
			order = 30,
			values = categoryValues,
		},
		priority = {
			type = 'range',
			name = L['Priority'],
			desc = L["The rule with the highest priority is applied first. The displaying ordre reflects the rule order."],
			order = 35,
			min = 0,
			max = 100,
			step = 1,
			bigStep = 5,
		},
		include = {
			type = 'input',
			name = L['Sets to include'],
			desc = L["An item matches this rule if it is contained in any of the listed sets."],
			usage = L["Enter PT3 set names separated by spaces, commas or newlines."],
			multiline = true,
			order = 40,
			set = 'SetSets',
			get = 'GetSets',
			validate = 'ValidateSets',
		},
		exclude = {
			type = 'input',
			name = L['Sets to exclude'],
			desc = L["An item doesn't match this rule if it is contained in any of the listed sets."],
			usage = L["Enter PT3 set names separated by spaces, commas or newlines."],
			multiline = true,
			order = 50,
			set = 'SetSets',
			get = 'GetSets',
			validate = 'ValidateSets',
		},
		delete = {
			type = 'execute',
			name = L['Delete'],
			desc = L["Definitively delete this rule."],
			order = -1,
			confirm = true,
			confirmText = L["Do you really want to delete this rule ?"],
			func = 'DeleteRule',
		},
	},
}

local handlerProto = {}

function handlerProto:GetDB(info)
	return filter.db.profile.rules[self.ruleKey], info.arg or info[#info]
end

function handlerProto:Get(info)
	local db, key = self:GetDB(info)
	return db[key]
end

function handlerProto:Set(info, value)
	local db, key = self:GetDB(info)
	db[key] = value
	filter:UpdateRules()
end

function handlerProto:GetSets(info)
	return table.concat(self:Get(info), "\n")
end

function handlerProto:SetSets(info, value)
	local sets = self:Get(info)
	wipe(sets)
	for set in gmatch(value, "[^\n]+") do
		tinsert(sets, strtrim(set))
	end
	filter:UpdateRules()
end

function handlerProto:ValidateSets(info, value)
	for set in gmatch(value, "[^\n]+") do
		set = strtrim(set)
		if not LPT:GetSetString(set) then
			return format(L["Unknown item set: %s"], set)
		end
	end
	return true
end

function handlerProto:DeleteRule(info)
	filter.db.profile.rules[self.ruleKey] = nil
	filter:UpdateRules()
end

local ruleOptionMeta = { __index = ruleOptionProto }
local handlerMeta = { __index = handlerProto }

local AceConfigRegistry = LibStub('AceConfigRegistry-3.0')

local ours = {}
local pool = {}
function filter:UpdateOptions()
	if not options then return end
	for key, option in pairs(ours) do
		if not rawget(self.db.profile.rules, key) then
			pool[option] = true
			ours[key] = nil
			options[key] = nil
		end
	end
	for key, rule in pairs(self.db.profile.rules) do
		local option = options[key]
		if not option then
			option = next(pool)
			if option then
				pool[option] = nil
			else
				option = setmetatable({handler = setmetatable({}, handlerMeta)}, ruleOptionMeta)
				ours[key] = option
			end
			option.name = rule.name
			option.handler.ruleKey = key
			options[key] = option
		end
		option.order = 100 + rule.priority
	end
	AceConfigRegistry:NotifyChange(addonName)
end


