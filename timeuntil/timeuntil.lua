-------------- Original Author: Strawberry --------------
--------------- Thanks to Koala and Zilus ---------------
----------------- Discord: exec.noir --------------------
ADDON:ImportObject(OBJECT_TYPE.TEXT_STYLE)
ADDON:ImportObject(OBJECT_TYPE.BUTTON)
ADDON:ImportObject(OBJECT_TYPE.DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.NINE_PART_DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.COLOR_DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.WINDOW)
ADDON:ImportObject(OBJECT_TYPE.LABEL)
ADDON:ImportObject(OBJECT_TYPE.ICON_DRAWABLE)
ADDON:ImportObject(OBJECT_TYPE.IMAGE_DRAWABLE)

ADDON:ImportAPI(API_TYPE.CHAT.id)
ADDON:ImportAPI(API_TYPE.TIME.id)
ADDON:ImportAPI(API_TYPE.MAP.id)

--TODO:
-- fix "in progress"
-- save length of window

local color = {}
    color.normal    = UIParent:GetFontColor("btn_df")
    color.highlight = UIParent:GetFontColor("btn_ov")
    color.pushed    = UIParent:GetFontColor("btn_on")
    color.disabled  = UIParent:GetFontColor("btn_dis")

local buttonskin = {
        drawableType = "ninePart",
        path = "ui/common/default.dds",
        coordsKey = "btn",
        autoResize = true,
        fontColor = color,
        fontInset = {
            left = 11,
            right = 11,
            top = 0,
            bottom = 0,
        },
    }

local timerAnchor = CreateEmptyWindow("timerAnchor", "UIParent")
      timerAnchor:Show(true)
      timerAnchor:AddAnchor("TOPLEFT", "UIParent", 100, 100)
      timerAnchor:SetExtent(150, 50)
      timerAnchor:EnableDrag(true)
local background = timerAnchor:CreateColorDrawable(0, 0, 0, 0.5, "background")
background:AddAnchor("TOPLEFT", timerAnchor, 0, 0)
background:AddAnchor("BOTTOMRIGHT", timerAnchor, 0, 0)
local amountOfTimers = 10
local eventLabels = {}
local timerLabels = {}
function updateTimers()
    for i, lbl in ipairs(eventLabels) do
        lbl:Show(false)
    end
    for i, lbl in ipairs(timerLabels) do
        lbl:Show(false)
    end
    eventLabels = {}
    timerLabels = {}
    timerAnchor:SetExtent(150, amountOfTimers * 25)

    for i = 1, amountOfTimers do
        --names
        local lblEventName = timerAnchor:CreateChildWidget("label", "timerLabelEvent" .. i, 0, false)
        lblEventName:SetHeight(20)
        lblEventName.style:SetFontSize(16)
        lblEventName:AddAnchor("TOPLEFT", timerAnchor, 0, (i - 1) * 25)
        lblEventName.style:SetAlign(ALIGN_LEFT)
        lblEventName.style:SetColor(255, 255, 255, 255)
        lblEventName:SetText("")
        eventLabels[i] = lblEventName

        --timers
        local lblTimer = timerAnchor:CreateChildWidget("label", "timerLabelTime" .. i, 0, false)
        lblTimer:SetHeight(20)
        lblTimer.style:SetFontSize(16)
        lblTimer:AddAnchor("TOPRIGHT", timerAnchor, 0, (i - 1) * 25)
        lblTimer.style:SetAlign(ALIGN_RIGHT)
        lblTimer.style:SetColor(255, 255, 255, 255)
        lblTimer:SetText("")
        timerLabels[i] = lblTimer
    end
end
updateTimers()
local moreEntries = timerAnchor:CreateChildWidget("button", "moreEntries", 0, true)
      moreEntries:AddAnchor("TOPLEFT", timerAnchor, -5, -25)
      ApplyButtonSkin(moreEntries, buttonskin)
      moreEntries:SetExtent(35,25)
      moreEntries:SetText("+")
      function moreEntries:OnClick(arg)
        amountOfTimers = amountOfTimers + 1
        updateTimers()
      end
      moreEntries:SetHandler("OnClick", moreEntries.OnClick)
local lessEntries = timerAnchor:CreateChildWidget("button", "lessEntries", 0, true)
      lessEntries:AddAnchor("TOPLEFT", timerAnchor, 25, -25)
      ApplyButtonSkin(lessEntries, buttonskin)
      lessEntries:SetExtent(35,25)
      lessEntries:SetText("-")
      function lessEntries:OnClick(arg)
        amountOfTimers = amountOfTimers - 1
        updateTimers()
      end
      lessEntries:SetHandler("OnClick", lessEntries.OnClick)

----- save draggable window ----------

local filePath = "TimeUntilWindowPos.txt"
local function SaveWindowPosition(x, y)
    local file = io.open(filePath, "w")
    file:write(string.format("%d,%d", x, y))
    file:close()
end
local function LoadSavedPosition()
    local file = io.open(filePath, "r")
    if not file then
        return 0, 0
    end
    local line = file:read("*line") 
    file:close()
    local x,y = line:match("(%d+),(%d+)")
    if x and y then
        return x,y
    else
        return 0,0
    end
end
function timerAnchor:OnDragStart()
    self:StartMoving()
    self.moving = true
end
timerAnchor:SetHandler("OnDragStart", timerAnchor.OnDragStart)
function timerAnchor:OnDragStop()
    self:StopMovingOrSizing()
    self.moving = false
    local offsetX, offsetY = self:GetOffset()
    local uiScale = UIParent:GetUIScale() or 1.0
    local normalizedX = offsetX * uiScale
    local normalizedY = offsetY * uiScale
    SaveWindowPosition(normalizedX, normalizedY)
end
timerAnchor:SetHandler("OnDragStop", timerAnchor.OnDragStop)
local savedWindowX, savedWindowY = LoadSavedPosition()
timerAnchor:AddAnchor("TOPLEFT", "UIParent", tonumber(savedWindowX), tonumber(savedWindowY))

local whaleConflict = false
local aegConflict = true

local serverEvents = {
    ["GR"] = {
       { times = {
            {hour = 2, minute = 20, duration = 20},
            {hour = 6, minute = 20, duration = 20},
            {hour = 10, minute = 20, duration = 20},
            {hour = 14, minute = 20, duration = 20},
            {hour = 18, minute = 20, duration = 20},
            {hour = 22, minute = 20, duration = 20}
        },
        days = {1, 2, 3, 4, 5, 6, 7}
    }},
    ["CR"] = {
       { times = {
            {hour = 0, minute = 20, duration = 10},
            {hour = 4, minute = 20, duration = 10},
            {hour = 8, minute = 20, duration = 10},
            {hour = 12, minute = 20, duration = 10},
            {hour = 16, minute = 20, duration = 10},
            {hour = 20, minute = 20, duration = 10}
        },
        days = {1, 2, 3, 4, 5, 6, 7}
    } },
    ["SG CR"] = {
    {    times = {
            {hour = 1, minute = 20, duration = 10},
            {hour = 5, minute = 20, duration = 10},
            {hour = 9, minute = 20, duration = 10},
            {hour = 13, minute = 20, duration = 10},
            {hour = 17, minute = 20, duration = 10},
            {hour = 21, minute = 20, duration = 10}
        },
        days = {1, 2, 3, 4, 5, 6, 7}
    } },
    ["JMG"] = {
       { times = {
            {hour = 3, minute = 20, duration = 15},
            {hour = 7, minute = 20, duration = 15},
            {hour = 11, minute = 20, duration = 15},
            {hour = 15, minute = 20, duration = 15},
            {hour = 19, minute = 20, duration = 15},
            {hour = 23, minute = 20, duration = 15}
        },
        days = {1, 2, 3, 4, 5, 6, 7}
    } },
    ["Lusca"] = { times = {{hour = 12, minute = 20, duration = 30}}, days = {1, 2, 3, 4, 5, 6, 7} },
    ["BD"] = {
        { times = {{hour = 21, minute = 30, duration = 60}}, days = {3, 5} },
        { times = {{hour = 18, minute = 30, duration = 60}}, days = {7} }
    },
    ["Kraken"] = {
        { times = {{hour = 22, minute = 30, duration = 60}}, days = {3, 5} },
        { times = {{hour = 19, minute = 30, duration = 60}}, days = {7} }
    },
    ["Leviathan"] = {
        { times = {{hour = 20, minute = 05, duration = 60}}, days = {3, 5} },
        { times = {{hour = 17, minute = 05, duration = 60}}, days = {7} }
    },
    ["Charybdis"] = {
        { times = {{hour = 21, minute = 30, duration = 60}}, days = {1, 5} }
    },
    ["Small Titan"] = {
        { times = {
        	{hour = 0, minute = 00, duration = 15}, 
        	{hour = 3, minute = 00, duration = 15}, 
        	{hour = 6, minute = 00, duration = 15}, 
        	{hour = 9, minute = 00, duration = 15}, 
        	{hour = 12, minute = 00, duration = 15}, 
        	{hour = 15, minute = 00, duration = 15}, 
        	{hour = 18, minute = 00, duration = 15}, 
        	{hour = 21, minute = 00, duration = 15}
        }, 
        days = {3, 6} }
    },
    ["Big Titan"] = {
        { times = {
        	{hour = 14, minute = 00, duration = 15}, 
        	{hour = 21, minute = 00, duration = 15}
        }, 
        days = {4, 7} }
    },
    ["Anthalon (G)"] = {
        { times = {{hour = 21, minute = 30, duration = 45}}, days = {1, 2, 6} }
    },
    ["Halcy"] = {
        { times = {{hour = 1, minute = 30, duration = 30}, {hour = 11, minute = 00, duration = 10}, {hour = 20, minute = 30, duration = 10}}, days = {1, 2, 3, 4, 5, 6, 7} }
    },
    ["RD"] = {
        { times = {{hour = 2, minute = 00, duration = 15}, {hour = 10, minute = 30, duration = 15}, {hour = 20, minute = 00, duration = 15}}, days = {1, 2, 4, 6} }
    },
    ["Abyssal Atk"] = {
        { times = {{hour = 12, minute = 00, duration = 30}, {hour = 22, minute = 30, duration = 30}}, days = {3, 5, 7} }
    },
    ["Hasla"] = {
        { times = {{hour = 18, minute = 49, duration = 15}, {hour = 20, minute = 49, duration = 15}}, days = {1, 2, 3, 4} }
    },
    ["Akasch"] = {
        { times = {{hour = 15, minute = 00, duration = 20}, {hour = 18, minute = 30, duration = 20}, {hour = 21, minute = 30, duration = 20}}, days = {7} },
        { times = {{hour = 15, minute = 00, duration = 20}, {hour = 18, minute = 30, duration = 20}, {hour = 22, minute = 00, duration = 20}}, days = {6} }
    },
    ["Prairie"] = {
        { times = {{hour = 9, minute = 00, duration = 20}, {hour = 22, minute = 00, duration = 20}}, days = {6, 7} }
    }
}



local function calculateDayOfWeek(year, month, day)
    if month < 3 then
        month = month + 12
        year = year - 1
    end
    local k = year % 100
    local j = math.floor(year / 100)
    local dayOfWeek = (day + math.floor((13 * (month + 1)) / 5) + k + math.floor(k / 4) + math.floor(j / 4) + 5 * j) % 7
    return (dayOfWeek + 6) % 7 + 1
end

local function serverMinutesSinceMidnight(serverTimeTable)
    if not serverTimeTable then return nil end
    return (serverTimeTable.hour * 60) + serverTimeTable.minute
end

local function getServerEventMinutes(eventTimes, eventDays, currentServerMinutes, currentDayOfWeek)
    local eventMinutesList = {}

    for _, time in ipairs(eventTimes) do
        local eventMinutes = (time.hour * 60) + time.minute
        local dayOffset = nil

        for _, eventDay in ipairs(eventDays) do
            local daysAway = eventDay - currentDayOfWeek
            if daysAway < 0 then
                daysAway = daysAway + 7
            end
            if dayOffset == nil or daysAway < dayOffset then
                dayOffset = daysAway
            end
        end

        local minutesAway = eventMinutes - currentServerMinutes + (dayOffset * 1440)
        if minutesAway < 0 then
            --minutesAway = minutesAway + 1440
        end

        table.insert(eventMinutesList, minutesAway)
    end

    return eventMinutesList 
end



local timer = 0
function timerAnchor:OnUpdate(dt)
    timer = timer + dt
    if timer > 1000 then
        timer = 0

        local isAM, currentHour, currentMinute = X2Time:GetGameTime()

        local serverTimeTable = UIParent:GetServerTimeTable()
        local currentServerMinutes = serverMinutesSinceMidnight(serverTimeTable)
        local dayOfWeek = calculateDayOfWeek(serverTimeTable.year, serverTimeTable.month, serverTimeTable.day)


        local sortedEvents = {}
        for name, eventList in pairs(serverEvents) do
            for _, eventData in ipairs(eventList) do
                local minutesList = getServerEventMinutes(eventData.times, eventData.days, currentServerMinutes, dayOfWeek)
                
                for i, minutesAway in ipairs(minutesList) do
                    if minutesAway then
                        --X2Chat:DispatchChatMessage(CMF_SYSTEM, tostring(minutesAway) .. " - " .. eventData.times[i].duration)
                        --X2Chat:DispatchChatMessage(CMF_SYSTEM, tostring(eventDuration) .. " times: " .. eventData.times[i] .. " duration: " .. eventData.times[i].duration)
                        local eventDuration = eventData.times[i] and eventData.times[i].duration or 0
                        table.insert(sortedEvents, {
                            name = name,
                            minutes = minutesAway,
                            duration = eventDuration, 
                            isServerEvent = true
                        })
                    end
                end
            end
        end

        table.sort(sortedEvents, function(a, b)
            return a.minutes < b.minutes
        end)

        local skipCounter = 0
        for i, event in ipairs(sortedEvents) do
            --X2Chat:DispatchChatMessage(CMF_SYSTEM, tostring(event.minutes))
            if (event.minutes + event.duration) > 0 then
                local iWithSkip = i - skipCounter
                if eventLabels[iWithSkip] then
                    eventLabels[iWithSkip]:SetText(event.name)
                    local hours = math.floor(event.minutes / 60)
                    local minutes = event.minutes % 60
                    if event.minutes <= 0 then
                        eventLabels[iWithSkip].style:SetColor(255, 0, 0, 255)
                        timerLabels[iWithSkip].style:SetColor(255, 0, 0, 255)
                        local timeEventIsActive = event.duration + event.minutes
                        timerLabels[iWithSkip]:SetText(string.format("Ends %02d", timeEventIsActive))
                    else
                        eventLabels[iWithSkip].style:SetColor(255, 255, 255, 255)
                        timerLabels[iWithSkip].style:SetColor(255, 255, 255, 255)
                        if event.name == "Big Titan" or event.name == "Small Titan" then
                        	eventLabels[iWithSkip].style:SetColor(0.3, 0.7, 1, 255)
                            timerLabels[iWithSkip].style:SetColor(0.3, 0.7, 1, 255)
                        end
                        if hours == 0 then
                            timerLabels[iWithSkip]:SetText(string.format("%02d", minutes))
                        else
                            timerLabels[iWithSkip]:SetText(string.format("%02d:%02d", hours, minutes))
                        end
                    end

                end
            else
                skipCounter = skipCounter + 1
            end
        end
    end
end

timerAnchor:SetHandler("OnUpdate", timerAnchor.OnUpdate)


--- war event handler 
function dump(o)
 if type(o) == 'table' then
  local s = '{ '
  for k,v in pairs(o) do
    if type(k) ~= 'number' then k = '"'..k..'"' end
    s = s .. '['..k..'] = ' .. dump(v) .. ','
  end
  return s .. '} '
 else
  return tostring(o)
 end
end


local events = {
  "HPW_ZONE_STATE_CHANGE"
}

local function GenericEventHandler(eventName)
    return function(info1)
        if info1 == 102 or info1 == 103 then
            local zoneInfo = X2Map:GetZoneStateInfoByZoneId(info1)
            if zoneInfo.conflictState == 5 then
                --X2Chat:DispatchChatMessage(CMF_SYSTEM, "Whale/Aeg in conflict")
                if info == 102 then
                    aegConflict = true
                elseif info == 103 then
                    whaleConflict = true
                end
            end
        end
    end
end

for _, event in ipairs(events) do
    UIParent:SetEventHandler(UIEVENT_TYPE[event], GenericEventHandler(event))
end

---