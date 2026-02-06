--[[
    AutoQuests Settings Module
    Manages all settings for flows and filters
]]
local AddonName, L = ...

local Settings = {}

-- Cache for quest categories by questID
local CATEGORY_CACHE = {}

-- Default settings for new characters
local DEFAULTS = {
    flows = {
        autoAccept = true,
        autoComplete = true,
        autoSelectGossips = true,
    },
    filters = {
        normalQuestsUnfinished = false,
        normalQuestsFinished = true,
        campaignQuestsUnfinished = false,
        campaignQuestsFinished = true,
        repeatableQuests = true,
        bountyQuests = false,
        taskQuests = false,
        trivialQuests = false,
        invasionQuests = false,
        worldQuests = false,
        metaQuests = false,
        professionQuests = false,
        pvpQuests = false,
        dungeonQuests = false,
    },
    misc = {
        debug = false,
    }
}

-- Initialize settings if not already done
function Settings.Initialize()
    if AutoQuestsDB == nil then
        AutoQuestsDB = {}
    end

    -- Initialize flows
    if AutoQuestsDB.flows == nil then
        AutoQuestsDB.flows = {}
    end
    for key, value in pairs(DEFAULTS.flows) do
        if AutoQuestsDB.flows[key] == nil then
            AutoQuestsDB.flows[key] = value
        end
    end

    -- Initialize filters
    if AutoQuestsDB.filters == nil then
        AutoQuestsDB.filters = {}
    end
    for key, value in pairs(DEFAULTS.filters) do
        if AutoQuestsDB.filters[key] == nil then
            AutoQuestsDB.filters[key] = value
        end
    end

    -- Initialize misc
    if AutoQuestsDB.misc == nil then
        AutoQuestsDB.misc = {}
    end
    for key, value in pairs(DEFAULTS.misc) do
        if AutoQuestsDB.misc[key] == nil then
            AutoQuestsDB.misc[key] = value
        end
    end
end

-- Flow getters and setters
function Settings.IsAutoAcceptEnabled()
    return AutoQuestsDB.flows.autoAccept
end

function Settings.SetAutoAcceptEnabled(value)
    AutoQuestsDB.flows.autoAccept = value
end

function Settings.IsAutoCompleteEnabled()
    return AutoQuestsDB.flows.autoComplete
end

function Settings.SetAutoCompleteEnabled(value)
    AutoQuestsDB.flows.autoComplete = value
end

function Settings.IsAutoSelectGossipsEnabled()
    return AutoQuestsDB.flows.autoSelectGossips
end

function Settings.SetAutoSelectGossipsEnabled(value)
    AutoQuestsDB.flows.autoSelectGossips = value
end

-- Filter getters and setters
function Settings.IsNormalQuestsUnfinishedEnabled()
    return AutoQuestsDB.filters.normalQuestsUnfinished
end

function Settings.SetNormalQuestsUnfinishedEnabled(value)
    AutoQuestsDB.filters.normalQuestsUnfinished = value
end

function Settings.IsNormalQuestsFinishedEnabled()
    return AutoQuestsDB.filters.normalQuestsFinished
end

function Settings.SetNormalQuestsFinishedEnabled(value)
    AutoQuestsDB.filters.normalQuestsFinished = value
end

function Settings.IsCampaignQuestsUnfinishedEnabled()
    return AutoQuestsDB.filters.campaignQuestsUnfinished
end

function Settings.SetCampaignQuestsUnfinishedEnabled(value)
    AutoQuestsDB.filters.campaignQuestsUnfinished = value
end

function Settings.IsCampaignQuestsFinishedEnabled()
    return AutoQuestsDB.filters.campaignQuestsFinished
end

function Settings.SetCampaignQuestsFinishedEnabled(value)
    AutoQuestsDB.filters.campaignQuestsFinished = value
end

function Settings.IsRepeatableQuestsEnabled()
    return AutoQuestsDB.filters.repeatableQuests
end

function Settings.SetRepeatableQuestsEnabled(value)
    AutoQuestsDB.filters.repeatableQuests = value
end

function Settings.IsBountyQuestsEnabled()
    return AutoQuestsDB.filters.bountyQuests
end

function Settings.SetBountyQuestsEnabled(value)
    AutoQuestsDB.filters.bountyQuests = value
end

function Settings.IsTaskQuestsEnabled()
    return AutoQuestsDB.filters.taskQuests
end

function Settings.SetTaskQuestsEnabled(value)
    AutoQuestsDB.filters.taskQuests = value
end

function Settings.IsTrivialQuestsEnabled()
    return AutoQuestsDB.filters.trivialQuests
end

function Settings.SetTrivialQuestsEnabled(value)
    AutoQuestsDB.filters.trivialQuests = value
end

function Settings.IsInvasionQuestsEnabled()
    return AutoQuestsDB.filters.invasionQuests
end

function Settings.SetInvasionQuestsEnabled(value)
    AutoQuestsDB.filters.invasionQuests = value
end

function Settings.IsWorldQuestsEnabled()
    return AutoQuestsDB.filters.worldQuests
end

function Settings.SetWorldQuestsEnabled(value)
    AutoQuestsDB.filters.worldQuests = value
end

function Settings.IsMetaQuestsEnabled()
    return AutoQuestsDB.filters.metaQuests
end

function Settings.SetMetaQuestsEnabled(value)
    AutoQuestsDB.filters.metaQuests = value
end

function Settings.IsProfessionQuestsEnabled()
    return AutoQuestsDB.filters.professionQuests
end

function Settings.SetProfessionQuestsEnabled(value)
    AutoQuestsDB.filters.professionQuests = value
end

function Settings.IsPvpQuestsEnabled()
    return AutoQuestsDB.filters.pvpQuests
end

function Settings.SetPvpQuestsEnabled(value)
    AutoQuestsDB.filters.pvpQuests = value
end

function Settings.IsDungeonQuestsEnabled()
    return AutoQuestsDB.filters.dungeonQuests
end

function Settings.SetDungeonQuestsEnabled(value)
    AutoQuestsDB.filters.dungeonQuests = value
end

-- Misc getters and setters
function Settings.IsDebugEnabled()
    if AutoQuestsDB == nil or AutoQuestsDB.misc == nil then
        return false
    end
    return AutoQuestsDB.misc.debug
end

function Settings.SetDebugEnabled(value)
    if AutoQuestsDB == nil or AutoQuestsDB.misc == nil then
        Settings.Initialize()
    end
    AutoQuestsDB.misc.debug = value
end

--[[
    Determines if a quest matches the enabled filters.
    Uses GetQuestCategory to determine the quest type, then checks if that type is enabled.
]]

function Settings.MatchesFilters(questId, quest, availableIndex)
    if questId == nil then
        return false
    end

    local category = Settings.GetCategoryByParams(questId, quest, availableIndex)

    if category == "Bounty Quest" then
        return Settings.IsBountyQuestsEnabled()
    elseif category == "Task Quest" then
        return Settings.IsTaskQuestsEnabled()
    elseif category == "Trivial Quest" then
        return Settings.IsTrivialQuestsEnabled()
    elseif category == "Invasion Quest" then
        return Settings.IsInvasionQuestsEnabled()
    elseif category == "Profession Quest" then
        return Settings.IsProfessionQuestsEnabled()
    elseif category == "PVP Quest" then
        return Settings.IsPvpQuestsEnabled()
    elseif category == "Dungeon Quest" then
        return Settings.IsDungeonQuestsEnabled()
    elseif category == "Campaign (Warband Completed)" then
        return Settings.IsCampaignQuestsFinishedEnabled()
    elseif category == "Campaign" then
        return Settings.IsCampaignQuestsUnfinishedEnabled()
    elseif category == "World Quest" then
        return Settings.IsWorldQuestsEnabled()
    elseif category == "Meta Quest" then
        return Settings.IsMetaQuestsEnabled()
    elseif category == "Repeatable" then
        return Settings.IsRepeatableQuestsEnabled()
    elseif category == "Normal (Warband Completed)" then
        return Settings.IsNormalQuestsFinishedEnabled()
    elseif category == "Normal" then
        return Settings.IsNormalQuestsUnfinishedEnabled()
    else
        return false
    end
end

--[[
    Gets the category name of a quest for debugging purposes
]]
function Settings.GetCategoryByQuest(quest)
		return Settings.GetCategoryByParams(quest.questID, quest)
end

function Settings.GetCategoryByParams(questID, quest, availableIndex)
		if not questID or questID == 0 then
				return "Unknown"
		end

		-- Check cache first
		if CATEGORY_CACHE[questID] then
				return CATEGORY_CACHE[questID]
		end

		local isLegendary = false
		local isRepeatable = false

		if quest then
			isLegendary = quest.isLegendary
			isRepeatable = quest.repeatable
		end

		if availableIndex and availableIndex > 0 then
			local isTrivial, frequency, repeatable, legendary = GetAvailableQuestInfo(availableIndex)
			isLegendary = isLegendary or legendary
			isRepeatable = isRepeatable or repeatable
		end

		local category
    if C_QuestLog.IsQuestBounty(questID) then
        category = "Bounty Quest"
    elseif C_QuestLog.IsQuestTask(questID) then
        category = "Task Quest"
    elseif C_QuestLog.IsQuestTrivial(questID) then
        category = "Trivial Quest"
    elseif C_QuestLog.IsQuestInvasion(questID) then
        category = "Invasion Quest"
    elseif C_QuestLog.GetQuestType(questID) == 267 then
        category = "Profession Quest"
    elseif C_QuestLog.GetQuestType(questID) == 41 then
        category = "PVP Quest"
    elseif C_QuestLog.GetQuestType(questID) == 81 then
        category = "Dungeon Quest"
    elseif C_QuestLog.IsImportantQuest(questID) or isLegendary then
        if C_QuestLog.IsQuestFlaggedCompletedOnAccount(questId) then
            category = "Campaign (Warband Completed)"
        else
            category = "Campaign"
        end
    elseif C_QuestLog.IsWorldQuest(questID) then
        category = "World Quest"
    elseif C_QuestLog.IsMetaQuest(questID) then
        category = "Meta Quest"
    elseif C_QuestLog.IsRepeatableQuest(questID) or isRepeatable then
        category = "Repeatable"
    else
        if C_QuestLog.IsQuestFlaggedCompletedOnAccount(questID) then
            category = "Normal (Warband Completed)"
        else
            category = "Normal"
        end
    end

		-- Cache non-normal categories
		if category ~= "Normal" and category ~= "Normal (Warband Completed)" then
				CATEGORY_CACHE[questID] = category
		end

		return category
end

function Settings.OutputAllFlagsByAvailableIndex(index)
	if not Settings.IsDebugEnabled() then
			return
	end

	print("===== OUTPUT ALL AVAILABLE FLAGS =====")
	if not index or index == 0 then
			print("No available quest index")
			return
	end

	local title = GetAvailableTitle(index)
	local isTrivial, frequency, isRepeatable, isLegendary, questID, isImportant = GetAvailableQuestInfo(index)

	print("Quest ID:", questID, "Quest Name:", title, "Quest Category", Settings.GetCategoryByParams(questID))

	print("isTrivial:", isTrivial)
	print("frequency:", frequency)
	print("isRepeatable:", isRepeatable)
	print("isLegendary:", isLegendary)
	print("isImportant:", isImportant)
end

function Settings.OutputAllFlagsByQuestID(questID, quest)
		if not Settings.IsDebugEnabled() then
			return
		end

		print("===== OUTPUT ALL QUEST FLAGS =====")
		if not questID or questID == 0 then
			print("No quest ID")
			return
		end
		local category = 'N/A'
		if quest then
			category = Settings.GetCategoryByQuest(quest)
		end
		print("Quest ID:", questID, "Quest Name:", C_QuestLog.GetTitleForQuestID(questID), "Quest Category", category)

		print("IsAccountQuest:", C_QuestLog.IsAccountQuest(questID))
		print("IsComplete:", C_QuestLog.IsComplete(questID))
		print("IsFailed:", C_QuestLog.IsFailed(questID))
		print("IsImportantQuest:", C_QuestLog.IsImportantQuest(questID))
		print("IsMetaQuest:", C_QuestLog.IsMetaQuest(questID))
		print("IsOnMap:", C_QuestLog.IsOnMap(questID))
		print("IsOnQuest:", C_QuestLog.IsOnQuest(questID))
		print("IsPushableQuest:", C_QuestLog.IsPushableQuest(questID))
		print("IsQuestBounty:", C_QuestLog.IsQuestBounty(questID))
		print("IsQuestCalling:", C_QuestLog.IsQuestCalling(questID))
		-- print("IsQuestCriteriaForBounty:", C_QuestLog.IsQuestCriteriaForBounty(questID))
		print("IsQuestDisabledForSession:", C_QuestLog.IsQuestDisabledForSession(questID))
		print("IsQuestFlaggedCompleted:", C_QuestLog.IsQuestFlaggedCompleted(questID))
		print("IsQuestFlaggedCompletedOnAccount:", C_QuestLog.IsQuestFlaggedCompletedOnAccount(questID))
		print("IsQuestFromContentPush:", C_QuestLog.IsQuestFromContentPush(questID))
		print("IsQuestInvasion:", C_QuestLog.IsQuestInvasion(questID))
		print("IsQuestReplayable:", C_QuestLog.IsQuestReplayable(questID))
		print("IsQuestReplayedRecently:", C_QuestLog.IsQuestReplayedRecently(questID))
		print("IsQuestTask:", C_QuestLog.IsQuestTask(questID))
		print("IsQuestTrivial:", C_QuestLog.IsQuestTrivial(questID))
		print("IsRepeatableQuest:", C_QuestLog.IsRepeatableQuest(questID))
		print("IsThreatQuest:", C_QuestLog.IsThreatQuest(questID))
		-- print("IsUnitOnQuest:", C_QuestLog.IsUnitOnQuest(questID))
		print("IsWorldQuest:", C_QuestLog.IsWorldQuest(questID))
		print("QuestHasWarModeBonus:", C_QuestLog.QuestHasWarModeBonus(questID))
		print("---")
		local info = C_QuestLog.GetQuestTagInfo(questID)
		print("info.tagName:", info and info.tagName or "nil")
		print("info.tagID:", info and info.tagID or "nil")
		print("info.worldQuestType:", info and info.worldQuestType or "nil")
		print("info.quality:", info and info.quality or "nil")
		print("info.tradeskillLineID:", info and info.tradeskillLineID or "nil")
		print("info.isElite:", info and info.isElite or "nil")
		print("info.displayExpiration:", info and info.displayExpiration or "nil")
		if quest ~= nil then
			print("---")
			print("quest.isLegendary:", quest.isLegendary)
			print("quest.frequency:", quest.frequency)
			print("quest.repeatable:", quest.repeatable)
		end
		print("---")
		print("questType:", C_QuestLog.GetQuestType(questID))
end

function Settings.OutputAllFlags(quest)
		Settings.OutputAllFlagsByQuestID(quest.questID, quest)
end

--[[
    Opens the options panel using the native Settings API
]]
function Settings.OpenPanel()
    if SettingsPanel then
        SettingsPanel:OpenToCategory("AutoQuests")
    else
        -- Fallback to old API if new one unavailable
        InterfaceOptionsFrame_OpenToCategory("AutoQuests")
    end
end

-- Initialize immediately on load
Settings.Initialize()

-- Export Settings to global namespace
_G.AutoQuestsSettings = Settings
