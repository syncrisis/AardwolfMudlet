-- AardwolfMudlet: tools
-- Group: aard > aardMap

function minimapsnap()
  if minimap and asciiContainer then
    -- Use container's screen position since minimap is inside it
    local mapx = tonumber(asciiContainer.x:gsub("px","")) or 800
    local mapy = tonumber(asciiContainer.y:gsub("px","")) or 0
    local mapw = tonumber(asciiContainer.width:gsub("px","")) or 232
    local maph = tonumber(asciiContainer.height:gsub("px","")) or 255
    
    if gInfo then
      local barW = 150
      local gx = mapx + mapw - barW
      local gy = mapy + maph
      gInfo:move(gx, gy)
    end
  end
end

function mapStarter()
  setMapUserData("last_modified", getTime(true,"yyyy.MM.ddThh:mm:ss.zzz"))
  
  local saveString = getMudletHomeDir().."/aardwolf/mapBackup_"..getTime(true,"yyyy.MM.ddThh.mm.ss.zzz")..".dat"
	local savedok = saveMap(saveString)
	
  if not savedok then
    echo("Couldn't save map :(\n")
		return 0--bail out, map didnt save.
  else
    echo("Map saved to: "..saveString.."\n")
		loadMap(getMudletHomeDir().."/aardwolf/mapStarter.dat")
  end
  --lua display(getMapUserData("last_modified"))
  --lua display(getAllMapUserData())	
end

function mapCheck()
	--MAP Backup, save, load
  local myRoomsTable = getRooms()
  local count = count or 0
  for _ in pairs(myRoomsTable) do count = count + 1 end
	if count > 14906 then
		echo("\n")
		aard.log:info("Your existing map has "..count.." rooms mapped.")
		aard.log:info("To load the starter map anyway (14907 rooms) type: startermap")
		aard.log:info("startermap will backup your map before loading the starter map.")
	else
		mapStarter()		
	end
end

function checkDoor(id,dir)
  local doors = getDoors(id)
  
  if not next(doors) then
		--cecho("\nThere aren't any doors in the room.")
		return
	end
  
  local door_status = {"open", "closed", "locked"}  
  for direction, door in pairs(doors) do
  	if direction == dir then
			if dir == "up" then--shorten further
				dir = "u"
			elseif dir == "down" then--shorten further
				dir = "d"
			end
  		return "o "..dir..";"
  	end
    --cecho("\nThere's a door leading in "..direction.." that is "..door_status[door]..".")
  end
end

function openDoor(dir)
  local doors = getDoors(aard.map.current_room)
  
  if not next(doors) then
		--cecho("\nThere aren't any doors in the room.")
		return
	end
  
  local door_status = {"open", "closed", "locked"}  
  for direction, door in pairs(doors) do
  	if direction == dir then
  		send("op "..dir,true)
  	end
    --cecho("\nThere's a door leading in "..direction.." that is "..door_status[door]..".")
  end
end

aard.echocolour = "cyan"

function aard_regenerate_areas()
  -- cached data
  aard.areatable = getAreaTable() -- this translates an area name to an ID
  aard.areatabler = {} -- this translates an ID to an area name

  local t = getAreaTable()
  for k,v in pairs(t) do
    aard.areatabler[tonumber(v)] = k
  end

  --aard.clearpathcache()
end
aard_regenerate_areas()

function aard.echoPath(from, to)
	assert(tonumber(from) and tonumber(to), "getPath: both from and to have to be room IDs")
	if getPath(from, to) then
		cecho("<white>Directions from <yellow>" .. string.upper(searchRoom(from)) .. " <white>to <yellow>" .. string.upper(searchRoom(to)) .. "<white>:")
		echo(table.concat(speedWalkDir, ", "))
		return aard.speedWalkDir
	else
	  cecho("<white>I can't find a way from <yellow>" .. string.upper(searchRoom(from)) .. " <white>to <yellow>" .. string.upper(searchRoom(to)) .. "<white>")
	end
end

function aard.roomFind(query)
  if query:ends('.') then query = query:sub(1,-2) end
  local result = aard.searchRoom(query)

  if type(result) == "string" or not next(result) then
    cecho("\n<grey> You have no recollection of any room with that name.\n") return end

  cecho("\n<DarkSlateGrey> You know the following relevant rooms:\n")

  local function showmeropis(roomid)
    if aard.game ~= "achaea" then return '' end

    return aard.oncontinent(getRoomArea(roomid), "Main") and '' or ' (Meropis)'
  end

  if not tonumber(select(2, next(result))) then -- old style
    for roomid, roomname in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (",
        tostring(roomname)))
      cechoLink("<"..aard.echocolour..">"..roomid, 'gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("<DarkSlateGrey>) in <LightSlateGray>%s%s<DarkSlateGrey>.", aard.stripRoomName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" > Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" > Show recall path\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end

  else -- new style
    for roomname, roomid in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (",
        tostring(roomname)))
      cechoLink("<"..aard.settings.echocolour..">"..roomid, 'aard.gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("<DarkSlateGrey>) in <LightSlateGray>%s%s<DarkSlateGrey>.", aard.cleanAreaName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" > Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" > Show recall path\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end
  end

  cecho(string.format("  <DarkSlateGrey>%d rooms found.\n", table.size(result)))
end

function aard.roomFindArea(query)
  if query:ends('.') then query = query:sub(1,-2) end
  local result = aard.searchRoomArea(query)

  if type(result) == "string" or not next(result) then
    cecho("\n<grey> You have no recollection of any room with that name.\n") return end

  cecho("\n<DarkSlateGrey> You know the following relevant rooms:\n")

  local function showmeropis(roomid)
    if aard.game ~= "achaea" then return '' end

    return aard.oncontinent(getRoomArea(roomid), "Main") and '' or ' (Meropis)'
  end

  if not tonumber(select(2, next(result))) then -- old style
    for roomid, roomname in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (",
        tostring(roomname)))
      cechoLink("<"..aard.echocolour..">"..roomid, 'gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("<DarkSlateGrey>) in <LightSlateGray>%s%s<DarkSlateGrey>.", aard.stripRoomName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" > Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" > Show speedwalk\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end

  else -- new style
    for roomname, roomid in pairs(result) do roomid = tonumber(roomid)
      cecho(string.format("  <LightSlateGray>%s<DarkSlateGrey> (",
        tostring(roomname)))
      cechoLink("<"..aard.settings.echocolour..">"..roomid, 'aard.gotoRoom('..roomid..')', string.format("Go to %s (%s)", roomid, tostring(roomname)), true)
      cecho(string.format("<DarkSlateGrey>) in <LightSlateGray>%s%s<DarkSlateGrey>.", aard.cleanAreaName(tostring(getRoomAreaName(getRoomArea(roomid)))), showmeropis(roomid)))
      fg("DarkSlateGrey") echoLink(" > Show path", [[aard.echoPath(]]..aard.map.current_room..[[, ]]..roomid..[[)]], "Display directions from here to "..roomname, true) echo("  ")
			fg("DarkSlateGrey") echoLink(" > Show speedwalk\n", [[showSpeedWalk(32418, ]]..roomid..[[)]], "Display directions from here to "..roomname, true)
			resetFormat()
    end
  end

  cecho(string.format("  <DarkSlateGrey>%d rooms found.\n", table.size(result)))
end

-- searchRoom with a cache!
local cache = {}
setmetatable(cache, {__mode = "kv"}) -- weak keys/values = it'll periodically get cleaned up by gc

function aard.searchRoom(what)
  local result = cache[what]
  if not result then
    result = searchRoom(what)
    local realResult = {}
    for key, value in pairs(type(result) == "table" and result or {}) do
        -- both ways, because searchRoom can return either id-room name or the reverse
        if type(key) == "string" then					
          realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
        else
          realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
        end
    end
    cache[what] = realResult
    result = realResult
  end
  return result
end

function aard.searchRoomExact(what)
  local result = cache[what]
  if not result then
    result = searchRoom(what,true,true)
    local realResult = {}
    for key, value in pairs(type(result) == "table" and result or {}) do
        -- both ways, because searchRoom can return either id-room name or the reverse
        if type(key) == "string" then					
          realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
        else
          realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
        end
    end
    cache[what] = realResult
    result = realResult
  end
  return result
end

function aard.searchRoomArea(what)
  local result = cache[what]
  if not result then
    result = searchRoom(what)
    local realResult = {}
    for key, value in pairs(type(result) == "table" and result or {}) do
        -- both ways, because searchRoom can return either id-room name or the reverse
        if type(key) == "string" then					
          realResult[key:ends(" (road)") and key:sub(1, -8) or key] = value
        else
					--search room by string value
					--display(value)
					if getRoomArea(key) == getRoomArea(aard.map.seen_room) then
						realResult[key] = value:ends(" (road)") and value:sub(1, -8) or value
					end
					--display(getRoomArea(key))
					--display(getRoomArea(aard.map.seen_room))          
        end
    end
    cache[what] = realResult
    result = realResult
  end
  return result
end
