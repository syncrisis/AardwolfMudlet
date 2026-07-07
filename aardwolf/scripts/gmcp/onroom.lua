-- AardwolfMudlet: onRoom
-- Group: aard > gmcp
-- Events: gmcp.room

function onRoom()	
  if not aard.map.current_room then--value not initialized
    if gmcp.room.info then
      if gmcp.room.info.num then--gmcp room number available
        if gmcp.room.info.num ~= -1 then--gmcp room number is not a -1 value (nomap room)
          aard.map.current_room = gmcp.room.info.num
        end
      end
    end
  end
  if not aard.map.init then
    if gmcp.room.info and gmcp.room.info.num and gmcp.room.info.num ~= -1 then
      aard.log:info("Map tracking was uninitialized - auto-reinitializing")
      aard:init_map()
    else
      return
    end
  end

  if (aard.special_move) then 
    aard.special_move = false
    return 
  end
  aard.log:debug("Parsing room")
  if gmcp.room.info then
  	if gmcp.room.info.num == 49393 then
  		send("close north;lock north")
  	elseif gmcp.room.info.num == 47195 and aard.command == "n" then
  		send("close south;lock south")
  	end
	end
  aard.map:parseGmcpRoom()
	
end
-- Parse gmcp.room data from the mud

function aard.map:parseGmcpRoom()
  local room_data = gmcp.room.info
	--local full = gmcp.room
  --display(room_data)
	--display(full)
  local zone_name = gmcp.room.info.zone

  -- Zone Handling
  if aard.map.current_zone ~= zone_name then
    aard.log:debug("Entered different zone")
    aard.map:setZone(zone_name)
  end
 
  -- Continent handling
  if gmcp.room.info.coord.cont == 1 then
    aard.log:debug("Continent room seen")
    local found_zone, zone_id = aard.map:isKnownZone(zone_name)
--    setGridMode(zone_id, true)
  end

  aard.map.seen_room = gmcp.room.info.num
  aard.map.prior_room = aard.map.current_room

  if aard.map.seen_room == -1 then
    -- Eventually needs to work to map "nomap" areas...
    aard.log:info("Can't find room based on mud id - none given - nomap rooms not yet implemented")
    local nexits = getRoomExits(aard.map.current_room)
		display(nexits)
		--if direction from existing room - room exists then display warning, room already exists
		--elseif direction does not have existing room, create it.
  		--aard.log:debug("New room seen - creating...")
      --aard.map:createRoom()
  elseif roomExists(aard.map.seen_room) then
	
    if getRoomEnv(aard.map.seen_room) == 999 then
				aard.map:exploreRoom()
--      aard.log:debug("Existing room is a temp room - recreating")
--      deleteRoom(aard.map.seen_room)  -- Causes exits to get delinked!
--      aard.map:createRoom()
--      aard.map:connectExits(aard.map.prior_room_data) -- Relink missing exits
    else
      aard.log:debug("Found existing room - moving there")
      aard.map.current_room = aard.map.seen_room
			--jakejake this goes off the direction used instead of vnum info. for now lets work without this.
			--because if you quickly spam comamnds such as north west north west, it gets it wrong.
			--i have an idea that may make this work by comparing command history, but its not a priority right now.
			--if aard.map:isCardinalExit(command) then
			--	if aard.map.prior_room ~= gmcp.room.info.num then--prevent same room linking, alas you cannot go that way!
			--		setExit(aard.map.prior_room, aard.map.current_room, command)
			--	end
			--end
			--do some get room position magic here, to confirm that a room exists in the given direction.
			--and that the previous and current roomnumbers line up for that direction.
      if aard.other == true then
				aard.other = false
				aard.map:connectSpecialExits()
      end
			centerview(aard.map.seen_room)--jakejake	
      local isFirstRoom = not aard.map.prior_room
    	if isFirstRoom or aard.newzone == true then
    	  aard.map:connectExits(gmcp.room,false)
    	else
    	  aard.map:connectExits(gmcp.room,true)
    	end
    end
  else
    aard.log:debug("New room seen - creating...")
    --display(room_data)
    aard.map:createRoom()
  end
  aard.map.prior_room_data = table.copy(gmcp.room)
  aard.map.prior_zone_name = zone_name
	
	--call map label update here.
	--mapLabel(room_data.zone:gsub("^%l", string.upper) .. " - " .. room_data.name)
	local maptext = room_data.zone:gsub("^%l", string.upper) .. " - " .. aard.stripRoomName(gmcp.room.info.name)
	GUIframe.tabs.Map:echo('<p style="font-size:13px; color = white"><b>' .. maptext)
end

function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end
