-- AardwolfMudlet: questinfo
-- Group: aard > aardMap

function findAreaID(areaname)
	
  local list = getAreaTable()

  -- iterate over the list of areas, matching them with substring match. 
  -- if we get match a single area, then return it's ID, otherwise return
  -- 'false' and a message that there are than one are matches
  local returnid, fullareaname
  for area, id in pairs(list) do
    if area:find(areaname, 1, true) then
			--display(returnid)--debug
      --if returnid then return false, "\nmore than one area matches" end
      returnid = id; fullareaname = area
		--else try exact match
    end
		
  end
  
  --return returnid, fullareaname
	return returnid
end

function lookupAreaID(areaname)
	
  local list = getAreaTable()
	
  for area, id in pairs(list) do
    if area == areaname then
      return id--found exact match
    end		
  end
	
	return nil--did not find exact match
end

function echoRoomListArea(areaname)
  --local id, msg = findAreaID(areaname)
	--id, msg = findAreaID(areaname)
	id = areaname
  if id then
    --display(id)
		local roomlist, endresult = getAreaRooms(id), {}
		--echo("\nTESTING\n")
    -- obtain a room list for each of the room IDs we got
    for _, id in pairs(roomlist) do
      --endresult[id] = getRoomName(id)
			if getRoomName(id) == aard.qRoom then
				endresult[id] = getRoomName(id)
			end
    end
  
    -- now display something half-decent looking
    --cecho(string.format("\nList of all rooms in %s (%d):\n", msg, table.size(endresult)))
		local count = 1
    for roomid, roomname in pairs(endresult) do
			echo(" ")
			hechoLink("|cFF0000"..count, [[gotoRoom(]]..roomid..[[)]], "runto "..roomid, true)
			count = count + 1
    end
		
  elseif not id and msg then
    echo("\nID not found; " .. msg)
  else
    echo("No areas matched the query.")
  end
end

function echoRoomListAreaSearch(areaname)
  --local id, msg = findAreaID(areaname)
	--id = findAreaID(areaname)
	id = lookupAreaID(areaname)
  if id then
    local roomlist, endresult = getAreaRooms(id), {}
  
    -- obtain a room list for each of the room IDs we got
    for _, id in pairs(roomlist) do
      --endresult[id] = getRoomName(id)
			if getRoomName(id) == aard.qRoom then
				endresult[id] = getRoomName(id)
			end
    end
  
    -- now display something half-decent looking
    --cecho(string.format("\nList of all rooms in %s (%d):\n", msg, table.size(endresult)))
		local count = 1
    for roomid, roomname in pairs(endresult) do
			echo(" ")
			hechoLink("|cFF0000"..roomid, [[gotoRoom(]]..roomid..[[)]], "runto "..roomname, true)
    end
		
  --elseif not id and msg then
	elseif not id then
    echo("\nID not found; " .. areaname)
  else
    echo("No areas matched the query.")
  end
end

function echoRoomList(what)
	ids = aard.searchRoomExact(what)--creates and uses cache	
	--display(ids)
	local count = 1
  for roomid, roomname in pairs(ids) do		
		--exclude areas with max level of 0, those are continents or special areas
		if aard.areaIndex[getRoomAreaName(getRoomArea(roomid))].max > 0 then
		--jakejake
			if aard.cpLevel >= aard.areaIndex[getRoomAreaName(getRoomArea(roomid))].min and aard.cpLevel <= aard.areaIndex[getRoomAreaName(getRoomArea(roomid))].max then
    		echo(" ")
    		hechoLink("|cFF0000"..count, [[gotoRoom(]]..roomid..[[)]], "runto "..roomid, true)
    		count = count + 1
  			--echo(aard.areaIndex[getRoomAreaName(getRoomArea(roomid))].min.."-"..aard.areaIndex[getRoomAreaName(getRoomArea(roomid))].max)
			end
		end
  end
end
