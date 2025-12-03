local addonName, ns = ...

ns.npcTrackerDB = {
    trackingName = "",
    trackingList = {},
    timerInterval = 5, -- in seconds
    debugMode = false,
}

ns.TrackingModeTypes = {
    DISABLED = {},
    NPC = {},
    LIST = {},
}

ns.timeElapsed = ns.npcTrackerDB.timerInterval

ns.trackingMode = ns.TrackingModeTypes.DISABLED

ns.eventsFrame = CreateFrame('Frame', 'NpcTrackerEventsFrame', UIParent)
ns.eventsFrame:RegisterEvent("ADDON_LOADED")
ns.eventsFrame:RegisterEvent("PLAYER_LOGOUT")