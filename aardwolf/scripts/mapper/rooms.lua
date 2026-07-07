-- AardwolfMudlet: rooms
-- Group: aard > aardMap

-- Rawcolor functionality leaves ANSI identifiers in many room names.
-- We don't want those, so strip them out.
-- Example: @WMy Colorful Roomname@g
function aard.stripRoomName(room_name)
  --local new_name = string.gsub(room_name, "@%a", "")
	local new_name = ansi2decho(room_name):gsub("%b<>", "")
	if room_name ~= new_name then
  	aard.log:debug("Cleaned room name: "..new_name)
	end
  return new_name
end

function aard.map:createUnexploredRoom(direction, room) --called from connectExits(
	local isCreated = false
	local found_zone, zone_id = aard.map:isKnownZone(gmcp.room.info.zone)
	--display(roomId)
	--if i use the info in the ASCII map I can also infer when a direction leads to a new zone.
	--allthough the only option that leaves me with is choosing not to yet mark that room on the map.
	
  aard.log:debug("Attempting to create Unexplored room for "..room)
  if room == -1 then
    aard.log:error("Unable to create room - no room id given by mud")
    return
  end

  isCreated = addRoom(room)
  setRoomName(room, "?")--set as ? to indicate not explored
  setRoomArea(room, zone_id)
	setRoomEnv(room, 999)--set env to 999 to indicate its an Unexplored room.

  --local terrain_id = aard.map.terrain[gmcp.room.info.terrain]
  --aard.log:debug("Setting terrain as "..terrain_id)
  --if terrain_id then
  --  setRoomEnv(room_id, terrain_id)
  --end

	--this blocks handles continent coords for creating unexplored rooms.
  if gmcp.room.info.coord.cont == 1 then
    aard.log:debug("Unexplored Continent room: hardcoding coords")
    if direction == "n" then
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1+1, 0)
    elseif direction == "s" then
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1-1, 0)
    elseif direction == "e" then
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x)+1, tonumber(gmcp.room.info.coord.y)*-1, 0)
    elseif direction == "w" then
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x)-1, tonumber(gmcp.room.info.coord.y)*-1, 0)
    elseif direction == "u" then
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1, 1)
    elseif direction == "d" then
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1, -1)
    else
      setRoomCoordinates(room, tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1, 0)
    end
  else
    aard.log:debug("unexploredRoom() getNewCoords() cRoom: "..aard.map.current_room)
    local x,y,z = aard.map:getNewCoords(direction,aard.map.current_room)
    
    local rooms_at_location = getRoomsByPosition(zone_id, x, y, z)
    --display(rooms_at_location)
    if table.size(rooms_at_location) > 0 then 
      aard.log:debug("unexploredRoom() Found colliding rooms... moving")
      aard.map:moveCollidingRooms(zone_id, x, y, z, direction)
    end
    
    aard.log:debug("New coords set to:"..x.." "..y.." "..z)
    setRoomCoordinates(room, x, y, z)
	end
	
	setRoomChar(room, "?")
  aard.log:debug("Created new Unexplored room")
	local dir_num = aard.map:getExitNum(direction)
	setExit(aard.map.seen_room, room, dir_num)
 
  if not isCreated then
    aard.log:error("Failed to create new room!")
  end
end

function aard.map:exploreRoom()
  local room_id = gmcp.room.info.num
  local isCreated = true
  local found_zone, zone_id = aard.map:isKnownZone(gmcp.room.info.zone)
  local room_name = aard.stripRoomName(gmcp.room.info.name)

  if not found_zone then
    aard.log:error("exploring: Unknown zone! Can't create room in an unknown zone")
    return
  end

  aard.log:debug("Attempting to create room for "..room_id)
  if room_id == -1 then
    aard.log:error("Unable to create room - no room id given by mud")
    return
  end

  setRoomName(room_id, room_name)
  setRoomArea(room_id, zone_id)
	setRoomChar(room_id, "")

  local terrain_id = aard.map.terrain[gmcp.room.info.terrain]
  aard.log:debug("Setting terrain as "..terrain_id)
  if terrain_id then
    setRoomEnv(room_id, terrain_id)
  end

	--this blocks handles zone change on exploring existing unexplored room.
  if gmcp.room.info.zone ~= aard.map.prior_zone_name then
    if gmcp.room.info.coord.cont == 1 then
      aard.log:debug("Continent room: hardcoding coords")
			setRoomCoordinates(room_id, tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1, 0)
    else
      aard.log:debug("Changed zone, centering map at 0,0,0")
      setRoomCoordinates(room_id, 0, 0, 0)
  		aard.map.prior_zone_name=gmcp.room.info.zone
		end
  end
	
  aard.map.current_room = room_id
	if firstRoom == true or aard.newzone == true then
	  aard.map:connectExits(gmcp.room,false)
	else
	  aard.map:connectExits(gmcp.room,true)
	end
	
	--jakejake
	--display(aard.other)
	if aard.other == true then
		aard.other = false
  	aard.map:connectSpecialExits()
	end
  centerview(room_id)
  aard.log:debug("Explored room")
 
  if not isCreated then
    aard.log:error("Failed to create new room!")
  end
end

function aard.map:createRoom()
  local room_id = gmcp.room.info.num
  local isCreated = false
  local found_zone, zone_id = aard.map:isKnownZone(gmcp.room.info.zone)
  local room_name = aard.stripRoomName(gmcp.room.info.name)

  if not found_zone then
    aard.log:error("creating: Unknown zone! Can't create room in an unknown zone")
    return
  end

  aard.log:debug("Attempting to create room for "..room_id)
  if room_id == -1 then
    aard.log:error("Unable to create room - no room id given by mud")
    return
  end

  isCreated = addRoom(room_id)
  setRoomName(room_id, room_name)
  setRoomArea(room_id, zone_id)
	
	--JAKE if its a special exit this wont work, because its looking for cardinal direction
	if aard.map:isCardinalExit(aard.command) then
		setExit(aard.map.prior_room, room_id, aard.command)
	end
	aard.log:debug("Created Link from: " .. aard.map.prior_room .. " to: " .. room_id .. " dir: " .. aard.command)
	--echo("\n2from: " .. aard.map.prior_room .. " to: " .. room_id .. " dir: " .. aard.command .. " .\n")

  local terrain_id = aard.map.terrain[gmcp.room.info.terrain]
  aard.log:debug("Setting terrain as "..terrain_id)
  if terrain_id then
    setRoomEnv(room_id, terrain_id)
  end
	
	local firstRoom = false
  -- If there is no prior room, then this is the first room of the map
  if not aard.map.prior_room then
		firstRoom = true
    if gmcp.room.info.coord.cont == 1 then
      setRoomCoordinates(room_id, gmcp.room.info.coord.x, gmcp.room.info.coord.y*-1, 0)
    else
      setRoomCoordinates(room_id, 0, 0, 0)
    end
    aard.map.prior_room = room_id
    aard.log:debug("Created first map room for id "..room_id)
  else
    aard.map.prior_room = aard.map.current_room
		aard.log:debug("createRoom() getNewCoords() pRoom: "..aard.map.prior_room)

    local x,y,z = aard.map:getNewCoords(aard.command,aard.map.prior_room)--join organized crime

		local rooms_at_location = getRoomsByPosition(zone_id, x, y, z)
    --display(rooms_at_location)
    if table.size(rooms_at_location) > 0 then 
      aard.log:debug("createRoom() Found colliding rooms... moving")
      aard.map:moveCollidingRooms(zone_id, x, y, z, aard.command) 
    end

    aard.log:debug("New coords set to:"..x.." "..y.." "..z)
    setRoomCoordinates(room_id, x, y, z)
  end

  aard.map.current_room = room_id
	if firstRoom == true or aard.newzone == true then
	  aard.map:connectExits(gmcp.room,false)
	else
	  aard.map:connectExits(gmcp.room,true)
	end
  if aard.other == true then
		aard.other = false
		aard.map:connectSpecialExits()
	end
  centerview(room_id)
  aard.log:debug("Created new room")
	aard.newzone = false
 
  if not isCreated then
    aard.log:error("Failed to create new room!")
  end
end

function aard.map:getNewCoords(command,fromRoom)
  if not command then
    aard.log:error("No command has been sent - can't find new coords")
    return
  end
  
  -- Continents are mapped in the 4th coordinate x,y system
  if gmcp.room.info.coord.cont == 1 then
    aard.log:debug("Continent room: hardcoding coords")
    return tonumber(gmcp.room.info.coord.x), tonumber(gmcp.room.info.coord.y)*-1, 0
  end

  if gmcp.room.info.zone ~= aard.map.prior_zone_name then
    aard.log:debug("Changed zone, centering map at 0,0,0")
    return 0,0,0 
  end
	
  if aard.map:isCardinalExit(command) then
    local direction_traveled = aard.map:getShortExit(command)
    aard.log:debug("Last command was a cardinal exit")
    local prior_room_x, prior_room_y, prior_room_z = getRoomCoordinates(fromRoom)
    if direction_traveled == "n" then
      return prior_room_x, prior_room_y+2, prior_room_z
    elseif direction_traveled == "s" then
      return prior_room_x, prior_room_y-2, prior_room_z
    elseif direction_traveled == "e" then
      return prior_room_x+2, prior_room_y, prior_room_z
    elseif direction_traveled == "w" then
      return prior_room_x-2, prior_room_y, prior_room_z
    elseif direction_traveled == "ne" then
      return prior_room_x+2, prior_room_y+2, prior_room_z
    elseif direction_traveled == "nw" then
      return prior_room_x-2, prior_room_y+2, prior_room_z
    elseif direction_traveled == "se" then
      return prior_room_x+2, prior_room_y-2, prior_room_z
    elseif direction_traveled == "sw" then
      return prior_room_x-2, prior_room_y-2, prior_room_z
    elseif direction_traveled == "u" then
      return prior_room_x, prior_room_y, prior_room_z+1
    elseif direction_traveled == "d" then
      return prior_room_x, prior_room_y, prior_room_z-1
    else
      return prior_room_x, prior_room_y, prior_room_z
    end
	else--not cardinal exit(special exit) and same zone, so just +1 the x axis
		local prior_room_x, prior_room_y, prior_room_z = getRoomCoordinates(fromRoom)
		return prior_room_x+1, prior_room_y, prior_room_z
  end
end

function aard.map:moveCollidingRooms(zone_id, cur_x, cur_y, cur_z, movedir)
  local x_axis_pos = {"e"}
  local x_axis_neg = {"w"}
  local y_axis_pos = {"n","nw","ne"}
  local y_axis_neg = {"s","sw","se"}
  local z_axis_pos = {"u"}
  local z_axis_neg = {"d"}

  local rooms = getAreaRooms(zone_id)
  local dir = movedir

  if table.contains(y_axis_pos, dir) then
    for name, id in pairs(rooms) do
      local x,y,z = getRoomCoordinates(id)
      if y >= cur_y then
        setRoomCoordinates(id, x, y+2, z)
      end
    end
  elseif table.contains(y_axis_neg, dir) then
    for name, id in pairs(rooms) do
      local x,y,z = getRoomCoordinates(id)
      if y <= cur_y then
        setRoomCoordinates(id, x, y-2, z)
      end
    end
  elseif table.contains(x_axis_pos, dir) then
    for name, id in pairs(rooms) do
      local x,y,z = getRoomCoordinates(id)
      if x >= cur_x then
        setRoomCoordinates(id, x+2, y, z)
      end
    end
  elseif table.contains(x_axis_neg, dir) then
    aard.log:debug("Shifting rooms lower in x")
    for name, id in pairs(rooms) do
      local x,y,z = getRoomCoordinates(id)
      if x <= cur_x then
        setRoomCoordinates(id, x-2, y, z)
      end
    end
  elseif table.contains(z_axis_pos, dir) then
    for name, id in pairs(rooms) do
      local x,y,z = getRoomCoordinates(id)
      if z >= cur_z then
        setRoomCoordinates(id, x, y, z+1)
      end
    end
  elseif table.contains(z_axis_neg, dir) then
    for name, id in pairs(rooms) do
      local x,y,z = getRoomCoordinates(id)
      if z <= cur_z then
        setRoomCoordinates(id, x, y, z-1)
      end
    end
  end
end
