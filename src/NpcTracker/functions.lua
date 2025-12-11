local addonName, ns = ...


-- Functions
local function prettyPrint(s)
	print("|cff00ff00" .. addonName .. ":|r " .. (s or "nil"))
end

local function prettyPrintInfo(s)
	print("|cff0000ff" .. addonName .. ":|r " .. (s or "nil"))
end

local function prettyPrintError(s)
	print("|cffff0000" .. addonName .. ":|r " .. (s or "nil"))
end

local function printDebug(s)
    if (ns.npcTrackerDB.debugMode) then prettyPrintInfo("|cff0000ffDebug:|r " .. (s or "nil")) end
end

local function isEmpty(s)
    --printDebug("isEmpty("..(s or "nil")..")")
    return s == nil or s == ''
end

function indexOf(array, value)
    --printDebug("indexOf(..., "..(value or "nil")..")")
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

local function registerEvents()
    printDebug("registerEvents()")
    ns.eventsFrame:RegisterEvent("CHAT_MSG_SYSTEM")
end

local function unregisterEvents()
    printDebug("unregisterEvents()")
    ns.eventsFrame:UnregisterEvent("CHAT_MSG_SYSTEM")
end

local function stopTracking()
    printDebug("stopTracking()")
    ns.trackingMode = ns.TrackingModeTypes.DISABLED
    unregisterEvents()
    SendChatMessage('.findnpc stop', 'SAY')
	prettyPrint("Stopped tracking.")
end

local function startTrackingList()
    printDebug("startTrackingList()")
    if (#ns.npcTrackerDB.trackingList > 0) then
        ns.trackingMode = ns.TrackingModeTypes.LIST
        -- ns.npcTrackerDB.trackingNpcName = ns.npcTrackerDB.trackingList[ns.trackingListCurrentIndex]
        registerEvents()
        ns.possibleLocationSkip = false
        SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
		prettyPrint("Started tracking (LIST).")
    else
		prettyPrintError("Nothing to track (LIST).")
    end
end

local function trackNpc(npcName)
    printDebug("trackNpc("..(npcName or "nil")..")")
    if (not isEmpty(npcName)) then
        npcName = string.gsub(npcName, "%%t", GetUnitName("target"))
        ns.trackingMode = ns.TrackingModeTypes.NPC
        ns.npcTrackerDB.trackingNpcName = npcName or ns.npcTrackerDB.trackingNpcName
        registerEvents()
        SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
		prettyPrint("Started tracking (NPC): " .. ns.npcTrackerDB.trackingNpcName .. ".")
    else
        prettyPrintError("Nothing to track (NPC).")
    end
end

local function addNpcToTrackingList(npcName)
    printDebug("addNpcToTrackingList("..(npcName or "nil")..")")
    if (isEmpty(npcName)) then
        prettyPrintError("Nothing to add.")
    else
        npcName = string.gsub(npcName, "%%t", GetUnitName("target"))
        if (indexOf(ns.npcTrackerDB.trackingList, npcName) == nil) then
            table.insert(ns.npcTrackerDB.trackingList, npcName)
            ns.trackingListCurrentIndex = 1
            ns.npcTrackerDB.trackingNpcName = ns.npcTrackerDB.trackingList[ns.trackingListCurrentIndex]
            prettyPrint("Added to tracking list: " .. npcName .. ".")
        else
            prettyPrintError("Already tracking " .. npcName .. ".")
        end
    end
end

local function removeNpcFromTrackingList(npcName)
    printDebug("removeNpcFromTrackingList("..(npcName or "nil")..")")
    if(not isEmpty(npcName)) then
        npcName = string.gsub(npcName, "%%t", GetUnitName("target"))
        local i = indexOf(ns.npcTrackerDB.trackingList, npcName)
        if (i ~= nil) then
            table.remove(ns.npcTrackerDB.trackingList, i)
            if (#ns.npcTrackerDB.trackingList > 0) then
                ns.trackingListCurrentIndex = 1
                ns.npcTrackerDB.trackingNpcName = ns.npcTrackerDB.trackingList[ns.trackingListCurrentIndex]
            else
                if (ns.trackingMode ~= ns.TrackingModeTypes.DISABLED) then
                    stopTracking()
                end
                ns.trackingListCurrentIndex = nil
            end
            prettyPrint("Removed from tracking list: " .. npcName .. ".")
        else
            prettyPrint(npcName .. " not found in list.")
        end
    else
        prettyPrintError("Nothing to remove.")
    end
end

local function clearTrackingList()
    printDebug("clearTrackingList()")
    if (ns.trackingMode ~= ns.TrackingModeTypes.DISABLED) then
        stopTracking()
    end
    ns.npcTrackerDB.trackingList = {}
    ns.trackingListCurrentIndex = nil
	prettyPrint("List cleared.")
end

local function listTrackingList()
    printDebug("listTrackingList()")
    prettyPrint("Tracking list:")
    for _, npcName in ipairs(ns.npcTrackerDB.trackingList) do
        print("  |ccccccccc" .. npcName)
    end
end

local function npcFound(msg)
    --printDebug("parseNpcFound("..(msg or "nil")..")")
    --printDebug (string.match(msg, "You have found ([^.]*)\."))
    local foundNpcName = string.match(msg, "You have found ([^.]*)\.")
    if (not isEmpty(foundNpcName)) then
        --printDebug('NPC name found: ' .. foundNpcName)
        return true
    else
        --printDebug('NPC name not found')
        return false
    end
end

local function npcFoundAway(msg)
    printDebug("npcFoundAway("..(msg or "nil")..")")
    printDebug (string.match(msg, "(.+) is %d+ yards away from here!"))
    local foundNpcName = string.match(msg, "(.+) is %d+ yards away from here!")
    if (not isEmpty(foundNpcName)) then
        printDebug('NPC name found yards away: ' .. foundNpcName)
        return true
    else
        printDebug('NPC name not found yards away')
        return false
    end
end

local function npcPossibleLocation(msg)
    --printDebug("npcPossibleLocation("..(msg or "nil")..")")
    --printDebug (string.match(msg, "A possible location for ([^.]*) has been marked on your map\."))
    local foundNpcName = string.match(msg, "A possible location for (.+) has been marked on your map\.")
    if (not isEmpty(foundNpcName)) then
        --printDebug('Possible location for ' .. foundNpcName .. ".")
        return true
    else
        --printDebug('No possible location.')
        return false
    end
end

local function npcWrongName(msg)
    --printDebug("npcWrongName("..(msg or "nil")..")")
    if (msg == "Couldn't find a creature with that name at all. Make sure you entered the exact name with correct capitalization.") then
        --printDebug('Wrong NPC name')
        return true
    else
        --printDebug('Right NPC name')
        return false
    end
end

local function searchingTooFast(msg)
    --printDebug("searchingTooFast("..(msg or "nil")..")")
    if (msg == "Please wait a while longer before using this command again.") then
        printDebug('Searching too fast.')
        return true
    else
        printDebug('Searching speed ok.')
        return false
    end
end

local function updateNpcToNext()
    printDebug("updateNpcToNext()")
    --prettyPrintError("Previously tracking element number: " .. (ns.trackingListCurrentIndex or "nil"))
    if (#ns.npcTrackerDB.trackingList == 0) then
        ns.trackingListCurrentIndex = nil
        ns.npcTrackerDB.trackingNpcName = nil
    else
        if (ns.trackingListCurrentIndex == #ns.npcTrackerDB.trackingList) then
            ns.trackingListCurrentIndex = 1
        else
            ns.trackingListCurrentIndex = (ns.trackingListCurrentIndex or 0) + 1
        end
        ns.npcTrackerDB.trackingNpcName = ns.npcTrackerDB.trackingList[ns.trackingListCurrentIndex]
    end
    --prettyPrintError("Now tracking element number: " .. (ns.trackingListCurrentIndex or "nil"))
end

local function setTimerInterval(newTimerInterval)
    printDebug("setTimerInterval("..(newTimerInterval or "nil")..")")
    local newTimerInterval = tonumber(newTimerInterval)
    if (newTimerInterval) then
        ns.npcTrackerDB.timerInterval = newTimerInterval
        prettyPrint("Timer interval set to : " .. ns.npcTrackerDB.timerInterval .. ".")
    else
        prettyPrintError("Wrong new timer interval value: " .. (newTimerInterval or "nil") .. ".")
    end
end

local function toggleDebug()
    printDebug("toggleDebug()")
    ns.npcTrackerDB.debugMode = not ns.npcTrackerDB.debugMode
end

local function resetNpcTrackerDB()
    ns.npcTrackerDB = {
        trackingName = "",
        trackingList = {},
        timerInterval = 5, -- in seconds
        debugMode = false,
    }
end


-- Add functions to namespace
ns.prettyPrint = prettyPrint
ns.prettyPrintInfo = prettyPrintInfo
ns.prettyPrintError = prettyPrintError
ns.printDebug = printDebug
ns.isEmpty = isEmpty
ns.indexOf = indexOf
ns.registerEvents = registerEvents
ns.unregisterEvents = unregisterEvents
ns.stopTracking = stopTracking
ns.startTrackingList = startTrackingList
ns.trackNpc = trackNpc
ns.addNpcToTrackingList = addNpcToTrackingList
ns.removeNpcFromTrackingList = removeNpcFromTrackingList
ns.clearTrackingList = clearTrackingList
ns.listTrackingList = listTrackingList
ns.npcFound = npcFound
ns.npcFoundAway = npcFoundAway
ns.npcPossibleLocation = npcPossibleLocation
ns.npcPossibleLocation = npcPossibleLocation
ns.npcWrongName = npcWrongName
ns.searchingTooFast = searchingTooFast
ns.updateNpcToNext = updateNpcToNext
ns.setTimerInterval = setTimerInterval
ns.toggleDebug = toggleDebug
ns.resetNpcTrackerDB = resetNpcTrackerDB
