local addonName, ns = ...

local npcFound = ns.npcFound
local npcPossibleLocation = ns.npcPossibleLocation
local npcWrongName = ns.npcWrongName
local prettyPrint = ns.prettyPrint
local prettyPrintError = ns.prettyPrintError
local printDebug = ns.printDebug
local removeNpcFromTrackingList = ns.removeNpcFromTrackingList
local searchingTooFast = ns.searchingTooFast
local stopTracking = ns.stopTracking
local updateNpcToNext = ns.updateNpcToNext


-- Events
local function eventHandler(self, event, arg1)
    if (event == 'ADDON_LOADED' and arg1 == addonName) then
        ns.npcTrackerDB = npcTrackerDB or ns.npcTrackerDB
         ns.eventsFrame:UnregisterEvent("ADDON_LOADED")
    elseif (event == 'CHAT_MSG_SYSTEM' and ns.trackingMode ~= ns.TrackingModeTypes.DISABLED) then
        printDebug("eventHandler - CHAT_MSG_SYSTEM - ("..(arg1 or "nil")..")")
        if (npcWrongName(arg1)) then
            if (ns.trackingMode == ns.TrackingModeTypes.NPC) then
                prettyPrintError("Wrong NPC name, stopping. NpcName: " .. (arg1 or "nil"))
                stopTracking()
            elseif (ns.trackingMode == ns.TrackingModeTypes.LIST) then
                prettyPrintError("Wrong NPC name, skipping npcName " .. (arg1 or "nil") .. ".")
                updateNpcToNext()
                -- SendChatMessage('.findnpc ' .. npcTrackerDB.trackingNpcName, 'SAY')
            end
        elseif (npcPossibleLocation(arg1)) then
            if (ns.trackingMode == ns.TrackingModeTypes.LIST) then
				removeNpcFromTrackingList(npcName)
                updateNpcToNext()
                -- SendChatMessage('.findnpc ' .. npcTrackerDB.trackingNpcName, 'SAY')
            end
        elseif (npcFound(arg1)) then
            -- SendChatMessage('.findnpc ' .. npcTrackerDB.trackingNpcName, 'SAY')
        elseif (searchingTooFast(arg1)) then
            npcTrackerDB.timerInterval = npcTrackerDB.timerInterval + 1
			prettyPrint("Parsing too fast, increasing interval to " .. npcTrackerDB.timerInterval .. " seconds.")
        end
    elseif (event == 'PLAYER_LOGOUT') then
        npcTrackerDB = ns.npcTrackerDB
    end
end

local function updateHandler(self, elapsed)
    if (ns.trackingMode ~= ns.TrackingModeTypes.DISABLED) then
        -- printDebug("updateHandler("..(elapsed or "nil")..")")
        ns.timeElapsed = ns.timeElapsed - elapsed
        if ns.timeElapsed <= 0 then
            SendChatMessage('.findnpc ' .. npcTrackerDB.trackingNpcName, 'SAY')
            printDebug("time elapsed: " .. ns.timeElapsed)
			updateNpcToNext()
            ns.timeElapsed = npcTrackerDB.timerInterval
        end
    end
end

ns.eventsFrame:SetScript('OnEvent', eventHandler)
ns.eventsFrame:SetScript("OnUpdate", updateHandler)