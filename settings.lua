--[[
    AutoQuests Settings Module
    Manages all settings for flows and filters
]]
local AddonName, L = ...

local Settings = {}

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
    Returns true only if ALL applicable quest types are enabled.

    Quest types checked:
    - Bounty: C_QuestLog.IsQuestBounty
    - Normal: not important, repeatable, world, or meta
    - Campaign: C_QuestLog.IsImportantQuest
    - Repeatable: C_QuestLog.IsRepeatableQuest
    - World: C_QuestLog.IsWorldQuest
    - Meta: C_QuestLog.IsMetaQuest
    - Finished on warband: C_QuestLog.IsQuestFlaggedCompletedOnAccount
]]
function Settings.MatchesFilters(questId)
    if questId == nil then
        return false
    end

    local isBounty = C_QuestLog.IsQuestBounty(questId)
    local isTask = C_QuestLog.IsQuestTask(questId)
    local isTrivial = C_QuestLog.IsQuestTrivial(questId)
    local isInvasion = C_QuestLog.IsQuestInvasion(questId)
    local isImportant = C_QuestLog.IsImportantQuest(questId)
    local isRepeatable = C_QuestLog.IsRepeatableQuest(questId)
    local isWorld = C_QuestLog.IsWorldQuest(questId)
    local isMeta = C_QuestLog.IsMetaQuest(questId)
    local isFinishedOnAccount = C_QuestLog.IsQuestFlaggedCompletedOnAccount(questId)

    -- Determine quest types
    local questTypes = {}
    local questType = C_QuestLog.GetQuestType(questId)

    if isBounty then
        questTypes.bounty = true
    elseif isTask then
        questTypes.task = true
    elseif isTrivial then
        questTypes.trivial = true
    elseif isInvasion then
        questTypes.invasion = true
    elseif questType == 267 then
        questTypes.profession = true
    elseif questType == 41 then
        questTypes.pvp = true
    elseif isImportant then
        questTypes.campaign = true
    elseif isWorld then
        questTypes.world = true
    elseif isMeta then
        questTypes.meta = true
    elseif isRepeatable then
        questTypes.repeatable = true
    else
        -- Normal quest
        if isFinishedOnAccount then
            questTypes.normalFinished = true
        else
            questTypes.normalUnfinished = true
        end
    end

    -- Check if all applicable types are enabled
    if questTypes.bounty and not Settings.IsBountyQuestsEnabled() then
        return false
    end
    if questTypes.task and not Settings.IsTaskQuestsEnabled() then
        return false
    end
    if questTypes.trivial and not Settings.IsTrivialQuestsEnabled() then
        return false
    end
    if questTypes.invasion and not Settings.IsInvasionQuestsEnabled() then
        return false
    end
    if questTypes.normalUnfinished and not Settings.IsNormalQuestsUnfinishedEnabled() then
        return false
    end
    if questTypes.normalFinished and not Settings.IsNormalQuestsFinishedEnabled() then
        return false
    end
    if questTypes.campaign then
        if isFinishedOnAccount then
            if not Settings.IsCampaignQuestsFinishedEnabled() then return false end
        else
            if not Settings.IsCampaignQuestsUnfinishedEnabled() then return false end
        end
    end
    if questTypes.repeatable and not Settings.IsRepeatableQuestsEnabled() then
        return false
    end
    if questTypes.world and not Settings.IsWorldQuestsEnabled() then
        return false
    end
    if questTypes.meta and not Settings.IsMetaQuestsEnabled() then
        return false
    end
    if questTypes.profession and not Settings.IsProfessionQuestsEnabled() then
        return false
    end
    if questTypes.pvp and not Settings.IsPvpQuestsEnabled() then
        return false
    end

    return true
end

--[[
    Gets the category name of a quest for debugging purposes
]]
function Settings.GetQuestCategory(quest)
		local questId = quest.questID

    if questId == nil then
        return "Unknown"
    end

    if C_QuestLog.IsQuestBounty(questId) then
        return "Bounty Quest"
    elseif C_QuestLog.IsQuestTask(questId) then
        return "Task Quest"
    elseif C_QuestLog.IsQuestTrivial(questId) then
        return "Trivial Quest"
    elseif C_QuestLog.IsQuestInvasion(questId) then
        return "Invasion Quest"
    elseif C_QuestLog.GetQuestType(questId) == 267 then
        return "Profession Quest"
    elseif C_QuestLog.GetQuestType(questId) == 41 then
        return "PVP Quest"
    elseif C_QuestLog.IsImportantQuest(questId) or quest.isLegendary then
        if C_QuestLog.IsQuestFlaggedCompletedOnAccount(questId) then
            return "Campaign (Warband Completed)"
        else
            return "Campaign"
        end
    elseif C_QuestLog.IsWorldQuest(questId) then
        return "World Quest"
    elseif C_QuestLog.IsMetaQuest(questId) then
        return "Meta Quest"
    elseif C_QuestLog.IsRepeatableQuest(questId) or quest.repeatable then
        return "Repeatable"
    else
        if C_QuestLog.IsQuestFlaggedCompletedOnAccount(questId) then
            return "Normal (Warband Completed)"
        else
            return "Normal"
        end
    end
end

function Settings.OutputAllFlags(quest)
		if not Settings.IsDebugEnabled() then
			return
		end
		print("===== OUTPUT ALL FLAGS =====")
		if not quest or not quest.questID then
			print("No quest or quest ID")
			return
		end
		print("Quest ID:", quest.questID, "Quest Name:", C_QuestLog.GetTitleForQuestID(quest.questID, "Quest Category", Settings.GetQuestCategory(quest)))
		print("IsAccountQuest:", C_QuestLog.IsAccountQuest(quest.questID))
		print("IsComplete:", C_QuestLog.IsComplete(quest.questID))
		print("IsFailed:", C_QuestLog.IsFailed(quest.questID))
		print("IsImportantQuest:", C_QuestLog.IsImportantQuest(quest.questID))
		print("IsMetaQuest:", C_QuestLog.IsMetaQuest(quest.questID))
		print("IsOnMap:", C_QuestLog.IsOnMap(quest.questID))
		print("IsOnQuest:", C_QuestLog.IsOnQuest(quest.questID))
		print("IsPushableQuest:", C_QuestLog.IsPushableQuest(quest.questID))
		print("IsQuestBounty:", C_QuestLog.IsQuestBounty(quest.questID))
		print("IsQuestCalling:", C_QuestLog.IsQuestCalling(quest.questID))
		-- print("IsQuestCriteriaForBounty:", C_QuestLog.IsQuestCriteriaForBounty(quest.questID))
		print("IsQuestDisabledForSession:", C_QuestLog.IsQuestDisabledForSession(quest.questID))
		print("IsQuestFlaggedCompleted:", C_QuestLog.IsQuestFlaggedCompleted(quest.questID))
		print("IsQuestFlaggedCompletedOnAccount:", C_QuestLog.IsQuestFlaggedCompletedOnAccount(quest.questID))
		print("IsQuestFromContentPush:", C_QuestLog.IsQuestFromContentPush(quest.questID))
		print("IsQuestInvasion:", C_QuestLog.IsQuestInvasion(quest.questID))
		print("IsQuestReplayable:", C_QuestLog.IsQuestReplayable(quest.questID))
		print("IsQuestReplayedRecently:", C_QuestLog.IsQuestReplayedRecently(quest.questID))
		print("IsQuestTask:", C_QuestLog.IsQuestTask(quest.questID))
		print("IsQuestTrivial:", C_QuestLog.IsQuestTrivial(quest.questID))
		print("IsRepeatableQuest:", C_QuestLog.IsRepeatableQuest(quest.questID))
		print("IsThreatQuest:", C_QuestLog.IsThreatQuest(quest.questID))
		-- print("IsUnitOnQuest:", C_QuestLog.IsUnitOnQuest(quest.questID))
		print("IsWorldQuest:", C_QuestLog.IsWorldQuest(quest.questID))
		print("QuestHasWarModeBonus:", C_QuestLog.QuestHasWarModeBonus(quest.questID))
		print("---")
		local info = C_QuestLog.GetQuestTagInfo(quest.questID)
		print("info.tagName:", info and info.tagName or "nil")
		print("info.tagID:", info and info.tagID or "nil")
		print("info.worldQuestType:", info and info.worldQuestType or "nil")
		print("info.quality:", info and info.quality or "nil")
		print("info.tradeskillLineID:", info and info.tradeskillLineID or "nil")
		print("info.isElite:", info and info.isElite or "nil")
		print("info.displayExpiration:", info and info.displayExpiration or "nil")
		print("---")
		print("quest.isLegendary:", quest.isLegendary)
		print("quest.frequency:", quest.frequency)
		print("quest.repeatable:", quest.repeatable)
		print("---")
		print("questType:", C_QuestLog.GetQuestType(quest.questID))
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
