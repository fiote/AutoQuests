--[[
    AutoQuests Main Module
]]
local AddonName, L = ...
local Settings = _G.AutoQuestsSettings
local OptionsPanel = {}

local playerName = UnitName("player")
local defaultRewardIndex = 1
local enabled = true
local lastSelectedQuest = nil  -- Track the last quest selected from gossip
local lastSelectedActiveQuest = nil  -- Track the last active quest selected from gossip

--[[
    Fonction d'affichage de message
]]
function printMessage(message)
    DEFAULT_CHAT_FRAME:AddMessage(message, 1.0, 1.0, 0.0)
end

--[[
    Helper function to check if a quest should be processed and log appropriately
    Returns true if the quest should be processed, false otherwise
]]
function ShouldProcessQuest(questId, quest, flowEnabled, disabledReason, filterCheckFn)
		local category = Settings.GetQuestCategoryByID(questId, quest)
		local title = C_QuestLog.GetTitleForQuestID(questId)

    if not flowEnabled then
        printMessage("[AutoQuests] Quest '" .. title .. "' detected as " .. category .. ", but " .. disabledReason .. ".")
        return false
    end

    if filterCheckFn and not filterCheckFn(questId, quest) then
        if Settings.IsDebugEnabled() then
            printMessage("[AutoQuests] Quest '" .. title .. "' detected as " .. category .. ", but filters don't match.")
        end
        return false
    end

    return true
end

--[[
    Helper function to log quest detection for auto-processing
]]
function LogQuestProcessing(questId, action)
    if Settings.IsDebugEnabled() then
				local category = Settings.GetQuestCategoryByID(questId)
				local title = C_QuestLog.GetTitleForQuestID(questId)
        printMessage("[AutoQuests] Quest '" .. title .. "' detected as " .. category .. ", " .. action .. "...")
    end
end

--[[
    Fonction principale pour gérer les événements liés aux quêtes
]]
function AutoQuestsHandler(self, event, ...)
    if not enabled or IsShiftKeyDown() or IsControlKeyDown() or IsAltKeyDown() then
        return
    end

    if event == "GOSSIP_SHOW" then
        HandleGossipShow()
    elseif event == "QUEST_GREETING" then
        HandleQuestGreeting()
    elseif event == "QUEST_DETAIL" then
        ON_QUEST_DETAIL(...)
    elseif event == "QUEST_PROGRESS" then
        ON_QUEST_PROGRESS()
    elseif event == "QUEST_AUTOCOMPLETE" then
        HandleQuestAutocomplete(...)
    elseif event == "QUEST_COMPLETE" then
        ON_QUEST_COMPLETE()
    end
end

local function debugtable(tab)
	if tab == nil or not tab then
		printMessage("Table is nil")
		return
	end
	if type(tab) ~= "table" then
		printMessage("Value is not a table: " .. tostring(tab) .. " (type: " .. type(tab) .. ")")
		return
	end
  printMessage("=====================================")
  printMessage("SIZE:", #tab)
  printMessage("{")
  if not tab then
    printMessage("nil")
  else
    for k,v in pairs(tab) do
      printMessage('"'..k..'" = '..tostring(v))
    end
  end
  printMessage("}")
  printMessage("=====================================")
end

--[[
    Fonction pour gérer l'événement QUEST_DETAIL
    Auto-accepts quests if flow is enabled and quest matches filters
]]
function ON_QUEST_DETAIL(questparam)
    local quest = nil
		local questID = nil

    -- First priority: use lastSelectedQuest if set (from gossip selection)
    if lastSelectedQuest and lastSelectedQuest ~= nil then
        quest = lastSelectedQuest
				questID = quest.questID
        printMessage("[AutoQuests] ON_QUEST_DETAIL: Using lastSelectedQuest from gossip: " .. tostring(questID))
    else
        -- Fallback: try GetQuestID() which works during QUEST_DETAIL
				questID = GetQuestID()
				printMessage("[AutoQuests] ON_QUEST_DETAIL: Fallback GetQuestID() returned: " .. tostring(questID))
    end

    if not questID or questID == 0 then
        printMessage("[AutoQuests] ON_QUEST_DETAIL: Could not determine questId")
        return
    end

    printMessage("[AutoQuests] ON_QUEST_DETAIL: Final questId: " .. tostring(questID))

		local category = Settings.GetQuestCategoryByID(questID, quest)
		local title = C_QuestLog.GetTitleForQuestID(questID)

    printMessage("[AutoQuests] ON_QUEST_DETAIL: Got quest info - Title: '" .. title .. "' (" .. category .. ")")
		-- Settings.Output	lags(quest.questID)

    if not ShouldProcessQuest(questID, quest, Settings.IsAutoAcceptEnabled(), "auto-accept flow is disabled", Settings.MatchesFilters) then
        return
    end

    LogQuestProcessing(questID, "auto-accepting")

    if Settings.IsDebugEnabled() then
        printMessage("[AutoQuests] Calling AcceptQuest()")
    end

    AcceptQuest()

    -- Clear the stored quest ID after accepting
    lastSelectedQuest = nil
end

--[[
    Fonction pour gérer l'événement QUEST_PROGRESS
    Auto-completes quests if flow is enabled and quest matches filters
]]
function ON_QUEST_PROGRESS()
    local quest = nil
		local questID = nil

    -- First priority: use lastSelectedActiveQuest if set (from gossip selection)
    if lastSelectedActiveQuest and lastSelectedActiveQuest ~= nil then
        quest = lastSelectedActiveQuest
				questID = quest.questID
        printMessage("[AutoQuests] ON_QUEST_PROGRESS: Using lastSelectedActiveQuest from gossip: " .. tostring(quest.questID))
    else
        -- Fallback: try GetQuestID() which works during QUEST_PROGRESS
				questID = GetQuestID()
				printMessage("[AutoQuests] ON_QUEST_PROGRESS: Fallback GetQuestID() returned: " .. tostring(questID))
    end

    if not questID or questID == 0 then
        printMessage("[AutoQuests] ON_QUEST_PROGRESS: Could not determine questId")
        return
    end

		local category = Settings.GetQuestCategoryByID(questID, quest)
		local title = C_QuestLog.GetTitleForQuestID(questID)
    printMessage("[AutoQuests] ON_QUEST_PROGRESS: Quest title='" .. title .. "' category=" .. category)

    if not ShouldProcessQuest(questID, quest, Settings.IsAutoCompleteEnabled(), "auto-turn-in flow is disabled", Settings.MatchesFilters) then
        return
    end

    LogQuestProcessing(questID, "auto-completing")
    printMessage("[AutoQuests] Calling CompleteQuest()")
    CompleteQuest()

    -- Clear the stored quest ID after completing
    lastSelectedActiveQuest = nil
end

--[[
    Fonction pour gérer l'événement QUEST_AUTOCOMPLETE
    Auto-completes quests that can be completed in the world without talking to an NPC
]]
function HandleQuestAutocomplete(quest)
    if quest and Settings.IsDebugEnabled() then
				local category = Settings.GetQuestCategory(quest)
        printMessage("[AutoQuests] HandleQuestAutocomplete called. Quest: '" .. quest.title .. "' (" .. category .. ")")
    end

    if not quest then
        return
    end

    if not ShouldProcessQuest(quest.questID, quest, Settings.IsAutoCompleteEnabled(), "auto-turn-in flow is disabled", Settings.MatchesFilters) then
        return
    end

    LogQuestProcessing(quest.questID, "auto-completing")
    ShowQuestComplete(C_QuestLog.GetLogIndexForQuestID(quest.questID))
end

--[[
    Fonction pour gérer l'événement GOSSIP_SHOW
]]
function HandleGossipShow()
    local nActive = C_GossipInfo.GetNumActiveQuests()
    local activeQuests = C_GossipInfo.GetActiveQuests()
    local nAvailable = C_GossipInfo.GetNumAvailableQuests()
    local availableQuests = C_GossipInfo.GetAvailableQuests()
    local gossipOptions = C_GossipInfo.GetOptions()

    printMessage("[AutoQuests] HandleGossipShow() available=" .. nAvailable .. ", active=" .. nActive);

    -- Debug: show what quests are available
    if Settings.IsDebugEnabled() then
        if nAvailable > 0 then
            printMessage("[AutoQuests] Available quests in gossip:")
            for i, quest in ipairs(availableQuests) do
                local category = Settings.GetQuestCategory(quest)
                local matches = Settings.MatchesFilters(quest.questID, quest)
                local matchStr = matches and "MATCHES" or "NO MATCH"
                printMessage("[AutoQuests] - " .. quest.title .. " (" .. category .. ") " .. matchStr)
            end
        end
        if nActive > 0 then
            printMessage("[AutoQuests] Active quests in gossip:")
            for i, quest in ipairs(activeQuests) do
                local completeStr = quest.isComplete and "(complete)" or "(incomplete)"
                local category = Settings.GetQuestCategory(quest)
                printMessage("[AutoQuests] - " .. quest.title .. " (" .. category .. ") " .. completeStr)
            end
        end
    end

    -- Only automate gossip options if auto-select gossips is enabled
    if Settings.IsAutoSelectGossipsEnabled() then
        if #gossipOptions == 1 and gossipOptions[1].flags == 1 then
            C_GossipInfo.SelectOption(gossipOptions[1].gossipOptionID)
        else
            local questOptionsCount = 0
            local firstQuestOption = nil
            for _, option in ipairs(gossipOptions) do
                if option.flags == 1 then
                    questOptionsCount = questOptionsCount + 1
                    if firstQuestOption == nil then
                        firstQuestOption = option
                    end
                end
            end
            if questOptionsCount > 1 then
                printMessage(L.TITLE .. playerName .. L.GOSSIP)
                PlaySound(5274, "master")
                if firstQuestOption then
                    C_GossipInfo.SelectOption(firstQuestOption.gossipOptionID)
                end
            elseif questOptionsCount == 1 then
                C_GossipInfo.SelectOption(gossipOptions[1].gossipOptionID)
            end
        end
    end

		local acceptedAnyQuest = false

    if nAvailable > 0 then
			 if Settings.IsAutoAcceptEnabled() then
					-- Auto-accept is enabled: select quests that match filters
					for i, quest in ipairs(availableQuests) do
							if Settings.MatchesFilters(quest.questID, quest) then
									local category = Settings.GetQuestCategory(quest)
									if Settings.IsDebugEnabled() then
											printMessage("[AutoQuests] Quest '" .. quest.title .. "' detected as " .. category .. ", auto-accepting...")
											printMessage("[AutoQuests] Calling C_GossipInfo.SelectAvailableQuest for questID: " .. quest.questID)
									end
									lastSelectedQuest = quest  -- Store for use in QUEST_DETAIL
								printMessage("[AutoQuests] Stored lastSelectedQuest: " .. quest.questID .. " ('" .. quest.title .. "')")
								C_GossipInfo.SelectAvailableQuest(quest.questID)
								acceptedAnyQuest = true
						else
								printMessage("[AutoQuests] Available quest '" .. quest.title .. "' (ID: " .. quest.questID .. ") does not match filters")
								-- Settings.OutputAllFlags(quest)
						end
				end
		 end
	end

	if not acceptedAnyQuest and nActive > 0 then
			if Settings.IsAutoCompleteEnabled() then
					printMessage("[AutoQuests] Gossip has " .. nActive .. " active quests, auto-complete enabled")
					for i, quest in ipairs(activeQuests) do
							local isComplete = quest.isComplete
							local matchesFilters = Settings.MatchesFilters(quest.questID, quest)
							local category = Settings.GetQuestCategory(quest)

							-- Settings.OutputAllFlags(quest)

							printMessage("[AutoQuests] Quest '" .. quest.title .. "' detected as " .. category .. " (matches filters? " .. tostring(matchesFilters)..")(complete? " .. tostring(isComplete)..")")

							if isComplete and matchesFilters then
									printMessage("[AutoQuests] Auto-completing...")
									printMessage("[AutoQuests] Calling C_GossipInfo.SelectActiveQuest for questID: " .. quest.questID)
									lastSelectedActiveQuest = quest  -- Store for use in QUEST_PROGRESS
									printMessage("[AutoQuests] Stored lastSelectedActiveQuest: " .. quest.questID .. " ('" .. quest.title .. "')")
									C_GossipInfo.SelectActiveQuest(quest.questID)
								end						end
				else
						printMessage("[AutoQuests] Gossip has " .. nActive .. " active quests, but auto-complete is DISABLED")
				end
		end
end

--[[
    Fonction pour gérer l'événement QUEST_GREETING
]]
function HandleQuestGreeting()
    printMessage("[AutoQuests] HandleQuestGreeting called")

    -- Use old indexed-based APIs during QUEST_GREETING, not C_GossipInfo
    local numAvailableQuests = GetNumAvailableQuests()
    local numActiveQuests = GetNumActiveQuests()

    printMessage("[AutoQuests] Available quests: " .. numAvailableQuests .. ", Active quests: " .. numActiveQuests)

    if numAvailableQuests > 0 then
        if Settings.IsAutoAcceptEnabled() then
            -- During QUEST_GREETING, we can only access quest info via index and title
            -- We'll select quests by index, filtering by title if needed
            for i = 1, numAvailableQuests do
                local title = GetAvailableTitle(i)
                -- We can't reliably get questID at this point, so we select by index
                -- The QUEST_DETAIL event will handle filtering
                if Settings.IsDebugEnabled() then
                    printMessage("[AutoQuests] Available quest " .. i .. ": '" .. (title or "Unknown") .. "', auto-selecting in QUEST_GREETING...")
                end
                SelectAvailableQuest(i)
                -- Only select the first one, let QUEST_DETAIL handle the rest
                break
            end
        end
    elseif numActiveQuests > 0 then
        if Settings.IsAutoCompleteEnabled() then
            -- Similarly for active quests
            for i = 1, numActiveQuests do
                local title, isComplete = GetActiveTitle(i)
                if isComplete then
                    if Settings.IsDebugEnabled() then
                        printMessage("[AutoQuests] Active quest " .. i .. ": '" .. (title or "Unknown") .. "' (complete), auto-selecting in QUEST_GREETING...")
                    end
                    SelectActiveQuest(i)
                    -- Only select the first one
                    break
                end
            end
        end
    else
        -- No quests found, output gossip options for debugging
        printMessage("[AutoQuests] No quests found in QUEST_GREETING. Checking gossip options...")
        local gossipOptions = C_GossipInfo.GetOptions()
        if gossipOptions and #gossipOptions > 0 then
            printMessage("[AutoQuests] Gossip options available: " .. #gossipOptions)
            for i, option in ipairs(gossipOptions) do
                printMessage("[AutoQuests] Option " .. i .. ": text='" .. (option.text or "nil") .. "' flags=" .. (option.flags or "nil") .. " gossipOptionID=" .. (option.gossipOptionID or "nil"))
            end
        else
            printMessage("[AutoQuests] No gossip options found")
        end
    end
end

--[[
    Fonction pour gérer l'événement QUEST_COMPLETE
    Auto-picks reward if flow is enabled and there's only one reward
]]
function ON_QUEST_COMPLETE()
    local quest = lastSelectedActiveQuest
		local questID = nil

		-- First priority: use lastSelectedActiveQuest if set (from gossip selection)
		if lastSelectedActiveQuest and lastSelectedActiveQuest ~= nil then
				quest = lastSelectedActiveQuest
				questID = quest.questID
				printMessage("[AutoQuests] ON_QUEST_COMPLETE: Using lastSelectedActiveQuest from gossip: " .. tostring(questID))
		else
				-- Fallback: try GetQuestID() which works during QUEST_COMPLETE
				questID = GetQuestID()
				printMessage("[AutoQuests] ON_QUEST_COMPLETE: Fallback GetQuestID() returned: " .. tostring(questID))
		end

		if not questID or questID == 0 then
				printMessage("[AutoQuests] ON_QUEST_COMPLETE: Could not determine questId")
				return
		end

    local rewardCount = GetNumQuestChoices()
    printMessage("[AutoQuests] ON_QUEST_COMPLETE called for questId: " .. tostring(questID) .. ", rewardCount: " .. rewardCount)

			local category = Settings.GetQuestCategoryByID(questID, quest)
			local title = C_QuestLog.GetTitleForQuestID(questID)
			printMessage("[AutoQuests] Quest: '" .. title .. "' (" .. category .. "), Reward count: " .. rewardCount)

    if rewardCount > 1 then
        printMessage(L.TITLE .. L.MULTIPLE_REWARDS)
        PlaySound(5274, "master")
    elseif (rewardCount == 0 or rewardCount == 1) and Settings.IsAutoCompleteEnabled() then
        printMessage("[AutoQuests] Auto-selecting reward for '" .. (title or "Unknown") .. "'")
        printMessage("[AutoQuests] Calling GetQuestReward(" .. defaultRewardIndex .. ")")
        GetQuestReward(defaultRewardIndex)
    else
        printMessage("[AutoQuests] Not auto-selecting reward (rewardCount=" .. rewardCount .. ", autoComplete=" .. tostring(Settings.IsAutoCompleteEnabled()) .. ")")
    end
end

--[[
    Enregistrement des événements de quêtes
]]
function RegisterAutoQuestsEvents()
    enabled = true
    printMessage(L.TITLE .. L.ENABLE)

    local frame = CreateFrame("Frame")
    frame:RegisterEvent("GOSSIP_SHOW")
    frame:RegisterEvent("QUEST_DETAIL")
    frame:RegisterEvent("QUEST_PROGRESS")
    frame:RegisterEvent("QUEST_AUTOCOMPLETE")
    frame:RegisterEvent("QUEST_COMPLETE")
    frame:RegisterEvent("QUEST_GREETING")
    frame:RegisterEvent("QUEST_DATA_LOAD_RESULT")
    frame:SetScript("OnEvent", AutoQuestsHandler)
end

--[[
    Commandes slash pour activer/désactiver l'addon et ouvrir options
]]
SLASH_AUTOQUEST1 = "/autoquest"
SLASH_AUTOQUEST2 = "/aq"

SlashCmdList["AUTOQUEST"] = function(msg)
    msg = string.lower(msg)
    local exec = msg:match("^(%S*)") -- Extraire la première partie de la commande

    if exec == "on" then
        enabled = true
        printMessage(L.TITLE .. L.ENABLE)
    elseif exec == "off" then
        enabled = false
        printMessage(L.TITLE .. L.DISABLE)
    elseif exec == "settings" or exec == "options" then
        Settings.OpenPanel()
    else
        local statusMessage = enabled and L.ENABLE or L.DISABLE
        printMessage(L.TITLE .. L.STATE .. statusMessage)
    end
end
--[[
    Gestionnaire de l'événement de connexion du joueur
]]
loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        _G.AutoQuestsOptionsPanel.CreatePanel()
        RegisterAutoQuestsEvents()
    end
end)
