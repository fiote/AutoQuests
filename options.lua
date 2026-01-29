--[[
    AutoQuests Options Panel
    Creates the Blizzard Settings UI for configuring flows and filters
]]
local AddonName, L = ...
local Settings = _G.AutoQuestsSettings

local OptionsPanel = {}

function OptionsPanel.CreatePanel()
    print("[AutoQuests] Creating options panel")

    -- Create main frame
    local frame = CreateFrame("Frame", "AutoQuestsOptionsFrame", UIParent)
    frame.name = "AutoQuests"

    print("[AutoQuests] Frame created, name:", frame.name)
    print("[AutoQuests] L.AUTO_ACCEPT:", L.AUTO_ACCEPT)
    print("[AutoQuests] L.FLOWS_TITLE:", L.FLOWS_TITLE)

    -- Title label
    local titleLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -16)
    titleLabel:SetText(L.OPTIONS_PANEL_NAME or "AutoQuests")
    titleLabel:SetTextColor(1, 1, 1)

    -- FLOWS SECTION
    local flowsTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalMed1")
    flowsTitle:SetPoint("TOPLEFT", titleLabel, "BOTTOMLEFT", 0, -20)
    flowsTitle:SetText(L.FLOWS_TITLE)
    flowsTitle:SetTextColor(1, 0.82, 0)  -- Golden yellow like Auto Turn-in

    -- Divider line after flows title
    local flowsDivider = frame:CreateLine()
    flowsDivider:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    flowsDivider:SetThickness(1)
    flowsDivider:SetStartPoint("LEFT", flowsTitle, "BOTTOMLEFT", 0, -4)
    flowsDivider:SetEndPoint("RIGHT", flowsTitle, "BOTTOMRIGHT", -16, -4)

    -- Auto Accept Checkbox
    local autoAcceptCheckbox = CreateFrame("CheckButton", "AutoQuestsAutoAcceptCheckbox", frame, "UICheckButtonTemplate")
    autoAcceptCheckbox:SetPoint("TOPLEFT", flowsDivider, "BOTTOMLEFT", 0, -10)
    autoAcceptCheckbox:SetChecked(Settings.IsAutoAcceptEnabled())
    autoAcceptCheckbox:SetScript("OnClick", function(self)
        Settings.SetAutoAcceptEnabled(self:GetChecked())
    end)
    print("[AutoQuests] Auto Accept checkbox created at:", autoAcceptCheckbox:GetPoint())

    local autoAcceptLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    print("[AutoQuests] Auto Accept label created")
    autoAcceptLabel:SetPoint("LEFT", autoAcceptCheckbox, "RIGHT", 8, 0)
    print("[AutoQuests] Label positioned at:", autoAcceptLabel:GetPoint())
    autoAcceptLabel:SetText(L.AUTO_ACCEPT)
    print("[AutoQuests] Label text set to:", L.AUTO_ACCEPT)
    autoAcceptLabel:SetTextColor(1, 1, 1)
    print("[AutoQuests] Label color set")

    -- Auto Complete Checkbox
    local autoCompleteCheckbox = CreateFrame("CheckButton", "AutoQuestsAutoCompleteCheckbox", frame, "UICheckButtonTemplate")
    autoCompleteCheckbox:SetPoint("TOPLEFT", autoAcceptCheckbox, "BOTTOMLEFT", 0, -6)
    autoCompleteCheckbox:SetChecked(Settings.IsAutoCompleteEnabled())
    autoCompleteCheckbox:SetScript("OnClick", function(self)
        Settings.SetAutoCompleteEnabled(self:GetChecked())
    end)

    local autoCompleteLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoCompleteLabel:SetPoint("LEFT", autoCompleteCheckbox, "RIGHT", 8, 0)
    autoCompleteLabel:SetText(L.AUTO_TURN_IN)
    autoCompleteLabel:SetTextColor(1, 1, 1)  -- White like other labels

    -- Auto Select Gossips Checkbox
    local autoSelectGossipsCheckbox = CreateFrame("CheckButton", "AutoQuestsAutoSelectGossipsCheckbox", frame, "UICheckButtonTemplate")
    autoSelectGossipsCheckbox:SetPoint("TOPLEFT", autoCompleteCheckbox, "BOTTOMLEFT", 0, -6)
    autoSelectGossipsCheckbox:SetChecked(Settings.IsAutoSelectGossipsEnabled())
    autoSelectGossipsCheckbox:SetScript("OnClick", function(self)
        Settings.SetAutoSelectGossipsEnabled(self:GetChecked())
    end)

    local autoSelectGossipsLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    autoSelectGossipsLabel:SetPoint("LEFT", autoSelectGossipsCheckbox, "RIGHT", 8, 0)
    autoSelectGossipsLabel:SetText(L.AUTO_SELECT_GOSSIPS)
    autoSelectGossipsLabel:SetTextColor(1, 1, 1)

    -- FILTERS SECTION
    local filtersTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalMed1")
    filtersTitle:SetPoint("TOPLEFT", autoSelectGossipsCheckbox, "BOTTOMLEFT", 0, -20)
    filtersTitle:SetText(L.FILTERS_TITLE)
    filtersTitle:SetTextColor(1, 0.82, 0)  -- Golden yellow like Auto Turn-in

    -- Divider line after filters title
    local filtersDivider = frame:CreateLine()
    filtersDivider:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    filtersDivider:SetThickness(1)
    filtersDivider:SetStartPoint("LEFT", filtersTitle, "BOTTOMLEFT", 0, -4)
    filtersDivider:SetEndPoint("RIGHT", filtersTitle, "BOTTOMRIGHT", -16, -4)

    -- Normal Quests Unfinished
    local normalUnfinishedCheckbox = CreateFrame("CheckButton", "AutoQuestsNormalUnfinishedCheckbox", frame, "UICheckButtonTemplate")
    normalUnfinishedCheckbox:SetPoint("TOPLEFT", filtersDivider, "BOTTOMLEFT", 0, -10)
    normalUnfinishedCheckbox:SetChecked(Settings.IsNormalQuestsUnfinishedEnabled())
    normalUnfinishedCheckbox:SetScript("OnClick", function(self)
        Settings.SetNormalQuestsUnfinishedEnabled(self:GetChecked())
    end)

    local normalUnfinishedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    normalUnfinishedLabel:SetPoint("LEFT", normalUnfinishedCheckbox, "RIGHT", 8, 0)
    normalUnfinishedLabel:SetText(L.NORMAL_UNFINISHED)
    normalUnfinishedLabel:SetTextColor(1, 1, 1)

    -- Normal Quests Finished
    local normalFinishedCheckbox = CreateFrame("CheckButton", "AutoQuestsNormalFinishedCheckbox", frame, "UICheckButtonTemplate")
    normalFinishedCheckbox:SetPoint("TOPLEFT", normalUnfinishedCheckbox, "BOTTOMLEFT", 0, -6)
    normalFinishedCheckbox:SetChecked(Settings.IsNormalQuestsFinishedEnabled())
    normalFinishedCheckbox:SetScript("OnClick", function(self)
        Settings.SetNormalQuestsFinishedEnabled(self:GetChecked())
    end)

    local normalFinishedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    normalFinishedLabel:SetPoint("LEFT", normalFinishedCheckbox, "RIGHT", 8, 0)
    normalFinishedLabel:SetText(L.NORMAL_FINISHED)
    normalFinishedLabel:SetTextColor(1, 1, 1)

    -- Campaign Quests Unfinished
    local campaignUnfinishedCheckbox = CreateFrame("CheckButton", "AutoQuestsCampaignUnfinishedCheckbox", frame, "UICheckButtonTemplate")
    campaignUnfinishedCheckbox:SetPoint("TOPLEFT", normalFinishedCheckbox, "BOTTOMLEFT", 0, -6)
    campaignUnfinishedCheckbox:SetChecked(Settings.IsCampaignQuestsUnfinishedEnabled())
    campaignUnfinishedCheckbox:SetScript("OnClick", function(self)
        Settings.SetCampaignQuestsUnfinishedEnabled(self:GetChecked())
    end)

    local campaignUnfinishedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    campaignUnfinishedLabel:SetPoint("LEFT", campaignUnfinishedCheckbox, "RIGHT", 8, 0)
    campaignUnfinishedLabel:SetText(L.CAMPAIGN_UNFINISHED)
    campaignUnfinishedLabel:SetTextColor(1, 1, 1)

    -- Campaign Quests Finished
    local campaignFinishedCheckbox = CreateFrame("CheckButton", "AutoQuestsCampaignFinishedCheckbox", frame, "UICheckButtonTemplate")
    campaignFinishedCheckbox:SetPoint("TOPLEFT", campaignUnfinishedCheckbox, "BOTTOMLEFT", 0, -6)
    campaignFinishedCheckbox:SetChecked(Settings.IsCampaignQuestsFinishedEnabled())
    campaignFinishedCheckbox:SetScript("OnClick", function(self)
        Settings.SetCampaignQuestsFinishedEnabled(self:GetChecked())
    end)

    local campaignFinishedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    campaignFinishedLabel:SetPoint("LEFT", campaignFinishedCheckbox, "RIGHT", 8, 0)
    campaignFinishedLabel:SetText(L.CAMPAIGN_FINISHED)
    campaignFinishedLabel:SetTextColor(1, 1, 1)

    -- Repeatable Quests
    local repeatableCheckbox = CreateFrame("CheckButton", "AutoQuestsRepeatableCheckbox", frame, "UICheckButtonTemplate")
    repeatableCheckbox:SetPoint("TOPLEFT", campaignFinishedCheckbox, "BOTTOMLEFT", 0, -6)
    repeatableCheckbox:SetChecked(Settings.IsRepeatableQuestsEnabled())
    repeatableCheckbox:SetScript("OnClick", function(self)
        Settings.SetRepeatableQuestsEnabled(self:GetChecked())
    end)

    local repeatableLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    repeatableLabel:SetPoint("LEFT", repeatableCheckbox, "RIGHT", 8, 0)
    repeatableLabel:SetText(L.REPEATABLE_QUESTS)
    repeatableLabel:SetTextColor(1, 1, 1)

    -- World Quests
    local worldCheckbox = CreateFrame("CheckButton", "AutoQuestsWorldCheckbox", frame, "UICheckButtonTemplate")
    worldCheckbox:SetPoint("TOPLEFT", repeatableCheckbox, "BOTTOMLEFT", 0, -6)
    worldCheckbox:SetChecked(Settings.IsWorldQuestsEnabled())
    worldCheckbox:SetScript("OnClick", function(self)
        Settings.SetWorldQuestsEnabled(self:GetChecked())
    end)

    local worldLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    worldLabel:SetPoint("LEFT", worldCheckbox, "RIGHT", 8, 0)
    worldLabel:SetText(L.WORLD_QUESTS)
    worldLabel:SetTextColor(1, 1, 1)

    -- Meta Quests
    local metaCheckbox = CreateFrame("CheckButton", "AutoQuestsMetaCheckbox", frame, "UICheckButtonTemplate")
    metaCheckbox:SetPoint("TOPLEFT", worldCheckbox, "BOTTOMLEFT", 0, -6)
    metaCheckbox:SetChecked(Settings.IsMetaQuestsEnabled())
    metaCheckbox:SetScript("OnClick", function(self)
        Settings.SetMetaQuestsEnabled(self:GetChecked())
    end)

    local metaLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    metaLabel:SetPoint("LEFT", metaCheckbox, "RIGHT", 8, 0)
    metaLabel:SetText(L.META_QUESTS)
    metaLabel:SetTextColor(1, 1, 1)

    -- MISC SECTION
    local miscTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalMed1")
    miscTitle:SetPoint("TOPLEFT", metaCheckbox, "BOTTOMLEFT", 0, -20)
    miscTitle:SetText(L.MISC_TITLE)
    miscTitle:SetTextColor(1, 0.82, 0)  -- Golden yellow like headers

    -- Divider line after misc title
    local miscDivider = frame:CreateLine()
    miscDivider:SetColorTexture(0.5, 0.5, 0.5, 0.5)
    miscDivider:SetThickness(1)
    miscDivider:SetStartPoint("LEFT", miscTitle, "BOTTOMLEFT", 0, -4)
    miscDivider:SetEndPoint("RIGHT", miscTitle, "BOTTOMRIGHT", -16, -4)

    -- Debug Checkbox
    local debugCheckbox = CreateFrame("CheckButton", "AutoQuestsDebugCheckbox", frame, "UICheckButtonTemplate")
    debugCheckbox:SetPoint("TOPLEFT", miscDivider, "BOTTOMLEFT", 0, -10)
    debugCheckbox:SetChecked(Settings.IsDebugEnabled())
    debugCheckbox:SetScript("OnClick", function(self)
        Settings.SetDebugEnabled(self:GetChecked())
    end)

    local debugLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    debugLabel:SetPoint("LEFT", debugCheckbox, "RIGHT", 8, 0)
    debugLabel:SetText(L.DEBUG)
    debugLabel:SetTextColor(1, 1, 1)

    -- Register with Blizzard Settings
    print("[AutoQuests] Registering with Blizzard Settings API")
    local category = _G.Settings.RegisterCanvasLayoutCategory(frame, "AutoQuests")
    _G.Settings.RegisterAddOnCategory(category)
    print("[AutoQuests] Options panel registered successfully")

    return frame
end

-- Export OptionsPanel to global namespace
_G.AutoQuestsOptionsPanel = OptionsPanel
print("[AutoQuests] OptionsPanel module loaded")
