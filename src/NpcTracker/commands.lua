local addonName, ns = ...

local addNpcToTrackingList = ns.addNpcToTrackingList
local clearTrackingList = ns.clearTrackingList
local isEmpty = ns.isEmpty
local listTrackingList = ns.listTrackingList
local prettyPrint = ns.prettyPrint
local prettyPrintError = ns.prettyPrintError
local printDebug = ns.printDebug
local removeNpcFromTrackingList = ns.removeNpcFromTrackingList
local setTimerInterval = ns.setTimerInterval
local startTrackingList = ns.startTrackingList
local stopTracking = ns.stopTracking
local trackNpc = ns.trackNpc
local toggleDebug = ns.toggleDebug


-- Commands
SLASH_TRACK1 = "/track"

SlashCmdList["TRACK"] = function(msg)
    printDebug("TRACK - ("..(msg or "nil")..")")
    if (isEmpty(msg)) then
        print("|cff00ff00NpcTracker|r commands:")
        print("  /track stop |ccccccccc- Stops tracking")
        print("  /track start |ccccccccc- Starts tracking the list of NPCs to track")
        print("  /track track <npcName> |ccccccccc- Tracks npcName")
        print("  /track add <npcName> |ccccccccc- Adds npcName to the list of NPCs to track")
        print("  /track remove <npcName> |ccccccccc- Removes npcName from the list of NPCs to track")
        print("  /track clear |ccccccccc- Clears the list of NPCs to track")
        print("  /track list |ccccccccc- Lists NPCs in the list of NPCs to track")
        print("  /track interval <newInterval> |ccccccccc- Updates the tracking interval (<newInterval> in seconds)")
    else
        local command, rest = string.match(msg, "^(%w+)%s*(.*)$");
        printDebug("command = " .. (command or "nil"))
        printDebug("rest = " .. (rest or "nil"))
        if (command == "stop") then
            stopTracking()
        elseif (command == "start") then
            startTrackingList()
        elseif (command == "npc") then
            trackNpc(rest)
        elseif (command == "add") then
            addNpcToTrackingList(rest)
        elseif (command == "remove") then
            removeNpcFromTrackingList(rest)
        elseif (command == "clear") then
            clearTrackingList()
        elseif (command == "list") then
            listTrackingList()
        elseif (command == "interval") then
        -- TODO
            if (isEmpty(rest)) then
                prettyPrint("Current timer interval: " .. ns.npcTrackerDB.timerInterval .. ".")
            else
                setTimerInterval(rest)
            end
        elseif (command == "debug") then
            prettyPrint("Toggling debug mode.")
            toggleDebug()
        else
			prettyPrintError("Wrong command: " .. (command or "nil") .. ".")
        end
    end
end