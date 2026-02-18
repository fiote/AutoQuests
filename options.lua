--[[
    AutoQuests Options Panel
    Creates the Blizzard Settings UI for configuring flows and filters
]]
local AddonName, L = ...
local Settings = _G.AutoQuestsSettings

local OptionsPanel = {}

function OptionsPanel.CreatePanel()
    -- Create main frame
    local frame = CreateFrame("Frame", "AutoQuestsOptionsFrame", UIParent)
    frame.name = "AutoQuests"

    -- Title label
    local titleLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

    -- Helper function to create a checkbox with label
    local function createCheckboxOption(parent, name, anchor, anchorPoint, getter, setter, labelText, offset)
        local checkbox = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate")
        checkbox:SetPoint("TOPLEFT", anchor, anchorPoint, 0, offset)
        checkbox:SetChecked(getter())
        checkbox:SetScript("OnClick", function(self)
            setter(self:GetChecked())
        end)

        local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("LEFT", checkbox, "RIGHT", 8, 0)
        label:SetText(labelText)
        label:SetTextColor(1, 1, 1)

        return checkbox
    end

    -- Helper function to create a section with title, divider, and options
    local function createOptionsSection(parent, sectionTitle, anchor, anchorOffset, options, useColumns)
        -- Section title
        local title = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalMed1")
        title:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, anchorOffset)
        title:SetText(sectionTitle)
        title:SetTextColor(1, 0.82, 0)

        -- Divider line
        local divider = parent:CreateLine()
        divider:SetColorTexture(0.5, 0.5, 0.5, 0.5)
        divider:SetThickness(1)
        divider:SetStartPoint("LEFT", title, "BOTTOMLEFT", 0, -4)
        divider:SetEndPoint("RIGHT", title, "BOTTOMRIGHT", -16, -4)

        -- Create options
        if useColumns then
            -- Two-column layout
            local firstColumn = {}
            local secondColumn = {}

            for i, option in ipairs(options) do
                if i % 2 == 1 then
                    table.insert(firstColumn, option)
                else
                    table.insert(secondColumn, option)
                end
            end

            local lastCheckboxLeft = divider
            local lastCheckboxRight = divider
            local first = true
            local firstOffset = -10
            local otherOffset = 6
            local columnSpacing = 320

            for i = 1, math.max(#firstColumn, #secondColumn) do
                -- Left column
                if firstColumn[i] then
                    local offset = otherOffset
                    if first then
                        offset = firstOffset
                        first = false
                    end

                    lastCheckboxLeft = createCheckboxOption(
                        parent,
                        firstColumn[i].name,
                        lastCheckboxLeft,
                        "BOTTOMLEFT",
                        firstColumn[i].getter,
                        firstColumn[i].setter,
                        firstColumn[i].label,
                        offset
                    )
                    if lastCheckboxLeft == divider then
                        lastCheckboxLeft:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, -5)
                    end
                end

                -- Right column
                if secondColumn[i] then
                    local offset = otherOffset
                    if i == 1 then
                        offset = firstOffset
                    end

                    lastCheckboxRight = createCheckboxOption(
                        parent,
                        secondColumn[i].name,
                        lastCheckboxRight,
                        "BOTTOMLEFT",
                        secondColumn[i].getter,
                        secondColumn[i].setter,
                        secondColumn[i].label,
                        offset
                    )

                    -- Position right column checkbox
                    if i == 1 then
                        lastCheckboxRight:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", columnSpacing, -5)
                    else
                        lastCheckboxRight:SetPoint("TOPLEFT", secondColumn[i-1] and _G[secondColumn[i-1].name], "BOTTOMLEFT", 0, 6)
                    end
                end
            end

            -- Create an anchor frame positioned below both columns for the next section
            local columnAnchor = CreateFrame("Frame", nil, parent)
            columnAnchor:SetSize(1, 1)
            columnAnchor:SetPoint("TOPLEFT", lastCheckboxLeft, "BOTTOMLEFT", 0, -2)
            columnAnchor:SetPoint("TOPRIGHT", lastCheckboxRight, "BOTTOMRIGHT", 0, -2)

            return columnAnchor
        else
            -- Single column layout
            local lastCheckbox = divider
            local first = true
            local firstOffset = -10
            local otherOffset = 6

            for _, option in ipairs(options) do
                local offset = otherOffset
                if first then
                    offset = firstOffset
                    first = false
                end

                lastCheckbox = createCheckboxOption(
                    parent,
                    option.name,
                    lastCheckbox,
                    "BOTTOMLEFT",
                    option.getter,
                    option.setter,
                    option.label,
                    offset
                )
                if lastCheckbox == divider then
                    lastCheckbox:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, -5)
                end
            end

            return lastCheckbox
        end
    end

    -- FLOWS SECTION
    local flowsAnchor = createOptionsSection(frame, L.FLOWS_TITLE, titleLabel, -5, {
        {name = "AutoQuestsAutoAcceptCheckbox", getter = Settings.IsAutoAcceptEnabled, setter = Settings.SetAutoAcceptEnabled, label = L.AUTO_ACCEPT},
        {name = "AutoQuestsAutoCompleteCheckbox", getter = Settings.IsAutoCompleteEnabled, setter = Settings.SetAutoCompleteEnabled, label = L.AUTO_TURN_IN},
        {name = "AutoQuestsAutoSelectQuestGossipsCheckbox", getter = Settings.IsAutoSelectQuestGossipsEnabled, setter = Settings.SetAutoSelectQuestGossipsEnabled, label = L.AUTO_SELECT_QUEST_GOSSIPS},
        {name = "AutoQuestsAutoSelectAnySingularGossipCheckbox", getter = Settings.IsAutoSelectAnySingularGossipEnabled, setter = Settings.SetAutoSelectAnySingularGossipEnabled, label = L.AUTO_SELECT_SINGULAR_GOSSIP},
    })

    -- FILTERS SECTION
    local filtersAnchor = createOptionsSection(frame, L.FILTERS_TITLE, flowsAnchor, -20, {
        {name = "AutoQuestsNormalUnfinishedCheckbox", getter = Settings.IsNormalQuestsUnfinishedEnabled, setter = Settings.SetNormalQuestsUnfinishedEnabled, label = L.NORMAL_UNFINISHED},
        {name = "AutoQuestsNormalFinishedCheckbox", getter = Settings.IsNormalQuestsFinishedEnabled, setter = Settings.SetNormalQuestsFinishedEnabled, label = L.NORMAL_FINISHED},
        {name = "AutoQuestsCampaignUnfinishedCheckbox", getter = Settings.IsCampaignQuestsUnfinishedEnabled, setter = Settings.SetCampaignQuestsUnfinishedEnabled, label = L.CAMPAIGN_UNFINISHED},
        {name = "AutoQuestsCampaignFinishedCheckbox", getter = Settings.IsCampaignQuestsFinishedEnabled, setter = Settings.SetCampaignQuestsFinishedEnabled, label = L.CAMPAIGN_FINISHED},
        {name = "AutoQuestsRepeatableCheckbox", getter = Settings.IsRepeatableQuestsEnabled, setter = Settings.SetRepeatableQuestsEnabled, label = L.REPEATABLE_QUESTS},
        {name = "AutoQuestsBountyCheckbox", getter = Settings.IsBountyQuestsEnabled, setter = Settings.SetBountyQuestsEnabled, label = L.BOUNTY_QUESTS},
        {name = "AutoQuestsTaskCheckbox", getter = Settings.IsTaskQuestsEnabled, setter = Settings.SetTaskQuestsEnabled, label = L.TASK_QUESTS},
        {name = "AutoQuestsTrivialCheckbox", getter = Settings.IsTrivialQuestsEnabled, setter = Settings.SetTrivialQuestsEnabled, label = L.TRIVIAL_QUESTS},
        {name = "AutoQuestsInvasionCheckbox", getter = Settings.IsInvasionQuestsEnabled, setter = Settings.SetInvasionQuestsEnabled, label = L.INVASION_QUESTS},
        {name = "AutoQuestsWorldCheckbox", getter = Settings.IsWorldQuestsEnabled, setter = Settings.SetWorldQuestsEnabled, label = L.WORLD_QUESTS},
        {name = "AutoQuestsMetaCheckbox", getter = Settings.IsMetaQuestsEnabled, setter = Settings.SetMetaQuestsEnabled, label = L.META_QUESTS},
        {name = "AutoQuestsProfessionCheckbox", getter = Settings.IsProfessionQuestsEnabled, setter = Settings.SetProfessionQuestsEnabled, label = L.PROFESSION_QUESTS},
        {name = "AutoQuestsPvpCheckbox", getter = Settings.IsPvpQuestsEnabled, setter = Settings.SetPvpQuestsEnabled, label = L.PVP_QUESTS},
        {name = "AutoQuestsDungeonCheckbox", getter = Settings.IsDungeonQuestsEnabled, setter = Settings.SetDungeonQuestsEnabled, label = L.DUNGEON_QUESTS},
    }, true)

    -- MISC SECTION
    createOptionsSection(frame, L.MISC_TITLE, filtersAnchor, -20, {
        {name = "AutoQuestsDebugCheckbox", getter = Settings.IsDebugEnabled, setter = Settings.SetDebugEnabled, label = L.DEBUG},
    })

    -- Register with Blizzard Settings
    local category = _G.Settings.RegisterCanvasLayoutCategory(frame, "AutoQuests")
    _G.Settings.RegisterAddOnCategory(category)

    return frame
end

-- Export OptionsPanel to global namespace
_G.AutoQuestsOptionsPanel = OptionsPanel
print("[AutoQuests] OptionsPanel module loaded")
