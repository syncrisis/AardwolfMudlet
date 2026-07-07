-- AardwolfMudlet: mapAddons
-- Group: aard > aardMap

mapAddOns = mapAddOns or {}

local function safeDelete(ids)
    for _, id in ipairs(ids) do
        id = tonumber(id)
        local rooms = {}
        for _, room in ipairs(getAllRoomEntrances(id)) do
            for dir, exit in pairs(getRoomExits(room)) do
                if exit == id then
                    if rooms[room] then
                        if type(rooms[room]) == "table" then
                            table.insert(rooms[room],dir)
                        else
                            rooms[room] = {rooms[room], dir}
                        end
                    else
                        rooms[room] = dir
                    end
                end
            end
        end
        deleteRoom(id)
        for rid, dirs in pairs(rooms) do
            if type(dirs) == "table" then
                for _, dir in ipairs(dirs) do
                    setExitStub(rid, dir, true)
                end
            else
                setExitStub(rid, dirs, true)
            end
        end
    end
    updateMap()
end

local function shiftZ(direction)
  local selectedRooms = getMapSelection()
  for i in pairs(selectedRooms.rooms) do
  	local x,y,z = getRoomCoordinates(selectedRooms.rooms[i])
  	setRoomCoordinates(selectedRooms.rooms[i], x, y, z+direction)
  end
	updateMap()
	centerview(selectedRooms.rooms[1])
end

function mapAddOns.eventHandler(event, mapEvent, ...)
    if event == "mapAddOnEvent" then
        if mapEvent == "safeDelete" then
            safeDelete(arg)
        elseif mapEvent == "shiftUp" then          
            shiftZ(1)
        elseif mapEvent == "shiftDown" then
            shiftZ(-1)
        end
    elseif event == "mapOpenEvent" then
        local events = {safeDelete = "Safe Delete", shiftUp = "Shift Up", shiftDown = "Shift Down"}
        local mapEvents = getMapEvents()
        for event, name in pairs(events) do
            if not mapEvents[event] then
                addMapEvent(event, "mapAddOnEvent","",name)
            end
        end
    end
end

registerAnonymousEventHandler("mapAddOnEvent","mapAddOns.eventHandler")
registerAnonymousEventHandler("mapOpenEvent","mapAddOns.eventHandler")
