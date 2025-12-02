if not NpcTrackerDB then
    NpcTrackerDB = {
        trackingNpcName = "",
        trackingNpcEnabled = false,
        debugMode = false,
    }
end
-- local NpcTrackerDB = {
    -- trackingNpcName = "",
    -- trackingNpcEnabled = false,
-- }


-- Frames
local eventListenerFrame = CreateFrame('Frame', 'NpcTrackerEventListenerFrame', UIParent)


-- Functions
local function printDebug(s)
    if (NpcTrackerDB.debugMode) then print(s or "nil") end
end

local function isEmpty(s)
    printDebug("isEmpty("..(s or "nil")..")")
    return s == nil or s == ''
end

local function trackNpc(npcName)
    printDebug("trackNpc("..(npcName or "nil")..")")
    if (not isEmpty(npcName)) then
        NpcTrackerDB.trackingNpcEnabled = true
        NpcTrackerDB.trackingNpcName = npcName or NpcTrackerDB.trackingNpcName
        SendChatMessage('.findnpc ' .. npcName, 'SAY')
        printDebug("retracking")
    end
end

local function unTrackNpc()
    printDebug("unTrackNpc()")
    NpcTrackerDB.trackingNpcEnabled = false
    SendChatMessage('.findnpc stop', 'SAY')
end

local function parseNpcFound(msg)
    printDebug("parseNpcFound("..(msg or "nil")..")")
    printDebug (string.match(msg, "You have found ([^.]*)."))
    local foundNpcName = string.match(msg, "You have found ([^.]*).")
    if (NpcTrackerDB.trackingNpcEnabled and not isEmpty(foundNpcName)) then
        trackNpc(NpcTrackerDB.trackingNpcName)
        printDebug('Found ' .. foundNpcName .. ', tracking ' .. NpcTrackerDB.trackingNpcName)
    end
end

local function eventHandler(self, event, arg1)
    if (event == 'CHAT_MSG_SYSTEM') then
        printDebug("eventHandler - CHAT_MSG_SYSTEM - ("..(arg1 or "nil")..")")
        parseNpcFound(arg1)
    end
end


-- Commands
-- Define the slash command
SLASH_TRACK1 = "/tracknpc"
SLASH_TRACK2 = "/track"
SLASH_UNTRACK1 = "/untracknpc"
SLASH_UNTRACK2 = "/untrack"
SLASH_UNTRACK3 = "/stoptrack"

-- Create the command list entry
SlashCmdList["TRACK"] = function(msg)
    printDebug("TRACK - ("..(msg or "nil")..")")
    if (not isEmpty(msg)) then
        trackNpc(msg)
    else
        print("|cff00ff00NpcTracker|r commands:")
        print("  /track npcName |ccccccccc- Tracks npcName")
        print("  /untrack |ccccccccc- Stops tracking")
    end
end

SlashCmdList["UNTRACK"] = function(msg)
    printDebug("UNTRACK - ("..(msg or "nil")..")")
    unTrackNpc()
end


-- Events
eventListenerFrame:SetScript('OnEvent', eventHandler)
eventListenerFrame:RegisterEvent('CHAT_MSG_SYSTEM')

-- Other stuff
printDebug("NpcTracker successfully loaded!")
DEFAULT_CHAT_FRAME:AddMessage("NpcTracker successfully loaded!2")
-- You have found Doom Lord Kazzak.
-- NPC name in white.
-- /console scriptErrors 0
-- /console scriptErrors 1