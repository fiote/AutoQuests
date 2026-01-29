local _, L = ...;

if GetLocale() == "enUS" then

  L.TITLE = "AutoQuests — "
  L.REWARD = ", Choose your reward and complete your quest."
  L.MULTIPLE_REWARDS = ", Quest has multiple rewards, please select manually."
  L.REPEATABLE = ", Choose your daily quest."
  L.BACK = "\n"
  L.ENABLE = "Enable"
  L.DISABLE = "Disabled"
  L.STATE = "State is "
  L.GOSSIP = ", Choose your dialogue."

  -- UI Strings
  L.OPTIONS_PANEL_NAME = "AutoQuests"

  -- Flows
  L.FLOWS_TITLE = "Automation Flows"
  L.AUTO_ACCEPT = "Auto Accept"
  L.AUTO_TURN_IN = "Auto Turn-in"
  L.AUTO_SELECT_GOSSIPS = "Auto Select Gossips"

  -- Filters
  L.FILTERS_TITLE = "Quest Filters"
  L.NORMAL_UNFINISHED = "Normal Quests (Not Completed by Warband)"
  L.NORMAL_FINISHED = "Normal Quests (Completed by Warband)"
  L.CAMPAIGN_UNFINISHED = "Campaign Quests (Not Completed by Warband)"
  L.CAMPAIGN_FINISHED = "Campaign Quests (Completed by Warband)"
  L.REPEATABLE_QUESTS = "Repeatable Quests"
  L.BOUNTY_QUESTS = "Bounty Quests"
  L.TASK_QUESTS = "Task Quests"
  L.TRIVIAL_QUESTS = "Trivial Quests"
  L.INVASION_QUESTS = "Invasion Quests"
  L.WORLD_QUESTS = "World Quests"
  L.META_QUESTS = "Meta Quests"

  -- Misc
  L.MISC_TITLE = "Miscellaneous"
  L.DEBUG = "Debug Mode"

end