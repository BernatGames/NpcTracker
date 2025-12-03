local addonName, ns = ...

local isEmpty = ns.isEmpty
local npcFound = ns.npcFound
local npcFoundAway = ns.npcFoundAway
local npcPossibleLocation = ns.npcPossibleLocation
local npcWrongName = ns.npcWrongName
local prettyPrint = ns.prettyPrint
local prettyPrintError = ns.prettyPrintError
local prettyPrintInfo = ns.prettyPrintInfo
local printDebug = ns.printDebug
local removeNpcFromTrackingList = ns.removeNpcFromTrackingList
local searchingTooFast = ns.searchingTooFast
local stopTracking = ns.stopTracking
local updateNpcToNext = ns.updateNpcToNext


-- Events
local function eventHandler(self, event, arg1)
    if (event == 'ADDON_LOADED' and arg1 == addonName) then
        ns.npcTrackerDB = npcTrackerDB or ns.npcTrackerDB
        if (#ns.npcTrackerDB.trackingList > 0) then ns.trackingListCurrentIndex = 1 end
        ns.eventsFrame:UnregisterEvent("ADDON_LOADED")
    elseif (event == 'CHAT_MSG_SYSTEM' and ns.trackingMode ~= ns.TrackingModeTypes.DISABLED) then
        printDebug("eventHandler - CHAT_MSG_SYSTEM - ("..(arg1 or "nil")..")")
        if (not isEmpty(arg1)) then
            chatMsg = arg1
            chatMsg = string.gsub(chatMsg, "\|c%x%x%x%x%x%x%x%x", "") -- colored text
            chatMsg = string.gsub(chatMsg, "\|r", "") -- reset color
            if (npcWrongName(chatMsg)) then
                printDebug("eventHandler - Found npcWrongName.")
                ns.possibleLocationSkip = false
                ns.timeElapsed = ns.npcTrackerDB.timerInterval
                if (ns.trackingMode == ns.TrackingModeTypes.NPC) then
                    prettyPrintError("Wrong NPC name, stopping. NpcName: " .. (chatMsg or "nil"))
                    stopTracking()
                elseif (ns.trackingMode == ns.TrackingModeTypes.LIST) then
                    --prettyPrintError("Wrong NPC name, skipping npcName " .. (chatMsg or "nil") .. ".")
                    --prettyPrintError("Will skip to next in list.")
                    updateNpcToNext()
                    SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
                    ns.timeElapsed = ns.npcTrackerDB.timerInterval
                    -- SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
                end
            elseif (npcPossibleLocation(chatMsg)) then
                printDebug("eventHandler - Found npcPossibleLocation.")
                if (ns.trackingMode == ns.TrackingModeTypes.LIST) then
                    if (ns.possibleLocationSkip) then
                        ns.possibleLocationSkip = false
                        --prettyPrintError("Will skip to next in list.")
                        updateNpcToNext()
                        SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
                        ns.timeElapsed = ns.npcTrackerDB.timerInterval
                        -- SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
                    else
                        ns.possibleLocationSkip = true
                    end
                    ns.timeElapsed = ns.npcTrackerDB.timerInterval
                end
            elseif (npcFound(chatMsg) or npcFoundAway(chatMsg)) then
                printDebug("eventHandler - Found npcFound or npcFoundAway.")
                ns.possibleLocationSkip = false
                ns.timeElapsed = ns.npcTrackerDB.timerInterval
                -- SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
            elseif (searchingTooFast(chatMsg)) then
                printDebug("eventHandler - Found searchingTooFast.")
                ns.npcTrackerDB.timerInterval = ns.npcTrackerDB.timerInterval + 1
                ns.possibleLocationSkip = false
                ns.timeElapsed = ns.npcTrackerDB.timerInterval
                prettyPrint("Parsing too fast, increasing interval to " .. ns.npcTrackerDB.timerInterval .. " seconds.")
            end
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
            SendChatMessage('.findnpc ' .. ns.npcTrackerDB.trackingNpcName, 'SAY')
            printDebug("time elapsed: " .. ns.timeElapsed)
            ns.timeElapsed = ns.npcTrackerDB.timerInterval
        end
    end
end

ns.eventsFrame:SetScript('OnEvent', eventHandler)
ns.eventsFrame:SetScript("OnUpdate", updateHandler)