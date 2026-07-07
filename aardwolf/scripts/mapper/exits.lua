-- AardwolfMudlet: exits
-- Group: aard > aardMap

aard.CARDINAL_EXITS_LONG = {"north", "south", "east", "west", "northeast", "northwest", "southeast", "southwest", "up", "down"}

-- NOTE: Ordering reflects mudlet defaults for converting exits to numeric values
aard.CARDINAL_EXITS_SHORT = {"n", "ne", "nw", "e", "w", "s", "se", "sw", "u", "d"}

aard.reverse = {6,8,7,5,4,1,3,2,10,9}

aard.reverse_dirs = {
		n = "s", s = "n", w = "e", e = "w", u = "d", d = "u", nw = "se", ne = "sw", sw = "ne", se = "nw",
    north = "south", south = "north", west = "east", east = "west", up = "down",
    down = "up", northwest = "southeast", northeast = "southwest", southwest = "northeast",
    southeast = "northwest", ["in"] = "out", out = "in",
}

aard.CARDINAL_EXITS_SHRINK = {north = "n", south = "s", east = "e", west = "w", northeast = "ne", northwest = "nw", southeast = "se", southwest = "sw", up = "u", down = "d"}

aard.CARDINAL_EXITS_EXPAND = {n = "north", s = "south", e = "east", w = "west", ne = "northeast", nw = "northwest", se = "southeast", sw = "southwest", u = "up", d = "down"}

function aard.map:getExitNum(dir)
  if not aard.map:isCardinalExit(dir) then
    aard.log:error("Can't get an exit number for a non-cardinal direction!")
    return
  end
  local exit = aard.map:getShortExit(dir)
  for k,v in pairs(aard.CARDINAL_EXITS_SHORT) do
    if exit == v then
      return k
    end
  end

  aard.log:error("Unable to find exit number for direction "..exit)
end

function aard.map:isCardinalExit(command)
  local isCardinal = false

  if table.contains(aard.CARDINAL_EXITS_LONG, command) or table.contains(aard.CARDINAL_EXITS_SHORT, command) then
    isCardinal = true
  end

  return isCardinal
end

function aard.map:getShortExit(command)
  if table.contains(aard.CARDINAL_EXITS_SHORT, command) then
    return command
  elseif table.contains(aard.CARDINAL_EXITS_LONG, command) then
    
    return aard.CARDINAL_EXITS_SHRINK[command]
  end
end

function aard.map:connectExits(room_data,extraRooms)
  local exits = room_data.info.exits
  local room_id = room_data.info.num
  
  for direction, room in pairs(exits) do-- this is where exits are scanned
    local dir_num = aard.map:getExitNum(direction)
    if roomExists(room) then
      aard.log:debug("Room " .. room .. " exists, connecting room " .. room_id .. " stubs")
      setExitStub(room_id, dir_num, true)
      --aard.log:debug("room_id: " .. room_id .. " room: " .. room .. " dir_num: " .. dir_num .. " reverse_dir: " .. aard.reverse[dir_num])
      setExit(room_id, room, dir_num)
      local stubs = getExitStubs(room_id)
--      if stubs and table.contains(stubs, dir_num) then
--        aard.log:debug("Removing stub in dir "..dir_num)
--        setExitStub(room_id, dir_num, 0)
--      end
    else
			if extraRooms == true then
				aard.map:createUnexploredRoom(direction, room)
			end
      aard.log:debug("Unexplored exit, creating stub in direction "..dir_num)
      setExitStub(room_id, dir_num, true)
    end
  end
  aard.log:debug("Leaving connectExits()") 
end

function aard.map:connectSpecialExits()
  if not aard.map:isCardinalExit(aard.command) 
    and aard.command ~= "l" 
    and aard.command ~= "look" 
    and aard.command ~= "recall" 
		and aard.command ~= "home" 
		and not string.match(aard.command, "dual") --dual wielding after using aardwolf amulet portal is not a portal!
		and not string.match(aard.command, "run") then--run/runto is not a portal command!
    aard.log:debug("Saw special exit command ("..aard.command.."), linking to prior room")
		aard.audioAlert("Alert")

    local special_exits = getSpecialExits(gmcp.room.info.num)
    if not table.contains(special_exits, aard.command) then
      addSpecialExit(aard.map.prior_room, gmcp.room.info.num, aard.command)
    end
  end
end
