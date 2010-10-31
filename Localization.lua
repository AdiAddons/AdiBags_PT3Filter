--[[
AdiBags_PT3Filter - LibPeriodicTable-3.1 item filters for AdiBags.
Copyright 2010 Adirelle (adirelle@tagada-team.net)
All rights reserved.
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')

-- Poor man's inline localization
local L = setmetatable({}, {__index = addon.L})
ns.L = L

-- %Localization: adibags-pt3filter
-- THE END OF THE FILE IS UPDATED BY A SCRIPT
-- ANY CHANGE BELOW THESES LINES WILL BE LOST
-- CHANGES SHOULD BE MADE USING http://www.wowace.com/addons/adibags-pt3filter/localization/

-- @noloc[[

------------------------ enUS ------------------------


-- AdiBags_PT3Filter.lua
L["An item doesn't match this rule if it is contained in any of the listed sets."] = true
L["An item matches this rule if it is contained in any of the listed sets."] = true
L["Check this to have the section name calculated from matching item set. If unchecked, you provide a fixed section name."] = true
L["Create"] = true
L["Definitively delete this rule."] = true
L["Delete"] = true
L["Dispatch items using rules based on LibPeriodicTable-3.1 item sets."] = true
L["Do you really want to delete this rule ?"] = true
L["Dynamic section name index"] = true
L["Dynamic section name"] = true
L["Enter PT3 set names separated by spaces, commas or newlines."] = true
L["Fixed bag section name."] = true
L["Fixed section name"] = true
L["Invalid PT3 set: %q"] = true
L["Invalid index: %q"] = true
L["LibPeriodicTable-3.1 filter"] = true
L["Name"] = true
L["New Rule"] = true
L["PT3 set names look like 'This.Item.Set'. This settings allow to use any part of the matching item set name as the section name, e.g. 'This', 'Item' or 'Set'."] = true
L["Positive numbers are counted from the beginning of the set name (1 = first part). Negative from end (-1 = last part)."] = true
L["Priority"] = true
L["Section category"] = true
L["Sets to exclude"] = true
L["Sets to include"] = true
L["The name of the rule to create. This is purely informative."] = true
L["The rule with the highest priority is applied first. The displaying ordre reflects the rule order."] = true
L["Unknown item set: %s"] = true
L["Use this section to create a brand new rule."] = true


------------------------ frFR ------------------------
local locale = GetLocale()
if locale == 'frFR' then
L["An item doesn't match this rule if it is contained in any of the listed sets."] = "Un object ne correpond pas à cette règle s'il est contenu dans n'importe lequel des ensembles listes."
L["An item matches this rule if it is contained in any of the listed sets."] = "Un object correpond à cette règle s'il est contenu dans n'importe lequel des ensembles listes."
L["Check this to have the section name calculated from matching item set. If unchecked, you provide a fixed section name."] = "Cochez ceci pour que le nom de section soit calculé à partir du nom de l'ensemble qui contient l'objet. Si c'est décoché, vous fournissez un nom de section prédéfini."
L["Create"] = "Créer"
L["Definitively delete this rule."] = "Supprime définitivement cette règle."
L["Delete"] = "Supprimer"
L["Dispatch items using rules based on LibPeriodicTable-3.1 item sets."] = "Distribue les objets en utilisant des règles basées sur les ensembles de LibPeriodicTable-3.1."
L["Do you really want to delete this rule ?"] = "Voulez-vous vraiment supprimer cette règle ?"
L["Dynamic section name"] = "Nom de section dynamique"
L["Dynamic section name index"] = "Index du nom de section dynamique."
L["Enter PT3 set names separated by spaces, commas or newlines."] = "Entrez des noms d'ensemble PT3, séparés par des espaces, des virgules ou des retours à la ligne."
L["Fixed bag section name."] = "Nom de section prédéfini."
L["Fixed section name"] = "Nom de section prédéfini."
L["Invalid PT3 set: %q"] = "Ensemble PT3 invalide : %q"
L["Invalid index: %q"] = "Index invalide : %q"
L["LibPeriodicTable-3.1 filter"] = "Filtre LibPeriodicTable-3.1"
L["Name"] = "Nom"
L["New Rule"] = "Nouvelle règle"
L["PT3 set names look like 'This.Item.Set'. This settings allow to use any part of the matching item set name as the section name, e.g. 'This', 'Item' or 'Set'."] = "Les noms d'ensemble de PT3 ressemble à 'Ceci.Est.Un.Ensemble'. Ce réglage permet d'utiliser n'importe quelle partie comme nom de section, e.g. 'Ceci', 'Est', 'Un' ou 'Ensemble'."
L["Positive numbers are counted from the beginning of the set name (1 = first part). Negative from end (-1 = last part)."] = "Les nombres positifs sont comptés depuis le début (1 = première partie), les negatifs depuis la fin (-1 = dernière partie)."
L["Priority"] = "Priorité"
L["Section category"] = "Catégorie de la section"
L["Sets to exclude"] = "Ensemble(s) à exclure"
L["Sets to include"] = "Ensemble(s) à inclure"
L["The name of the rule to create. This is purely informative."] = "Le nom de la règle à créer. C'est purement informatif."
L["The rule with the highest priority is applied first. The displaying ordre reflects the rule order."] = "La règle avec la plus grande priorité est appliquée en premier. L'ordre d'affichage reflète l'ordre d'application des règles."
L["Unknown item set: %s"] = "Ensemble inconnu : %s"
L["Use this section to create a brand new rule."] = "Utilisez cette section pour créer une règle toute neuve."

------------------------ deDE ------------------------
-- no translation

------------------------ esMX ------------------------
-- no translation

------------------------ ruRU ------------------------
-- no translation

------------------------ esES ------------------------
-- no translation

------------------------ zhTW ------------------------
-- no translation

------------------------ zhCN ------------------------
-- no translation

------------------------ koKR ------------------------
-- no translation
end

-- @noloc]]

-- Replace remaining true values by their key
for k,v in pairs(L) do if v == true then L[k] = k end end
