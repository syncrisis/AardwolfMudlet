-- AardwolfMudlet: speedwalk
-- Group: aard > aardMap

function buildSpeedWalk(startID,toID)
	if startID then
		if getPath(startID,toID) then
			--doable
		end
	end
  if #speedWalkPath == 0 then
    aard.log:error("No speedwalk path found!")
  end
	
	local previousID = startID or aard.map.current_room
	local exits = aard.map:getAllExits(previousID)
  local path = {}
	
	
	local shrinkExits = {north = "n", south = "s", east = "e", west = "w", northeast = "ne", northwest = "nw", southeast = "se", southwest = "sw", up = "up", down = "down"}
	
  for i, room_id in pairs(speedWalkPath) do
    for j, exit in pairs(exits) do
      if tonumber(room_id) == exit then
				local door = checkDoor(previousID,shrinkExits[j])
				if door then
					table.insert(path, door)
				end
        table.insert(path, j)
				previousID = room_id
      end
    end
		exits = aard.map:getAllExits(room_id)
  end
	
	local run = ""
	local runFunc = {}
	local samedir = 1
	local es = {north = "n", south = "s", east = "e", west = "w", northeast = "ne", northwest = "nw", southeast = "se", southwest = "sw", up = "u", down = "d"}
	
	--if string.match("sendhian", matches[2]) then
	
	if es[path[1]] then
		run = run.."run "
	else
    if path[2] and path[3] then
    	if es[path[2]] and es[path[3]] then
    		run = run..path[1]..";run "
    	else
    		run = run..path[1]..";"
    	end
    else
			if path[1] then
    		run = run..path[1]..";"
			end
    end
		table.remove(path, 1)
	end

  while path[1] do
    local dir = path[1]
    table.remove(path, 1)
		
		if dir == path[1] then--dir is same as previous direction
			samedir = samedir+1--as long as the direction is same, increment a counter eg 2e 3e 4e until direction change			
		elseif samedir == 1 then--direction changed, single direction
    	if es[dir] then
    		run = run..es[dir]
    	else--only append ;run when direction was not a member of es[dir]
        if path[1] and path[2] then
        	if es[path[1]] and es[path[2]] then
        		run = run..";"..dir..";run "
        	else
        		run = run..";"..dir..";"
        	end
        else
        	run = run..";"..dir..";"
        end				
    	end			
		else--direction changed multiple in direction eg 2e 3e 4e		
    	if es[dir] then
    		run = run..samedir..es[dir]--no ; or semi colon, this one can be continuance
    	else--only append ;run when direction was not a member of es[dir]
				run = run..";run "..samedir..dir..";run "
    	end
			samedir = 1
		end
  end--while path[1]	
	run = string.gsub(run,";;",";")
	--display(run)
	return run
end

function showSpeedWalk(startID,toID)
	run = buildSpeedWalk(tonumber(startID),tonumber(toID))
	echo("\n"..run)
end

function doSpeedWalk()
	run = buildSpeedWalk()
	display(run)
	send(run)
end

function aard.map:getAllExits(room_id)
  local exits = getRoomExits(room_id)
  local sexits = getSpecialExitsSwap(room_id)
  return aard.map:concatTables(exits, sexits)
end

function aard.map:concatTables(table1, table2)
  local output = {}
  for i,v in pairs(table1) do
    output[i] = v
  end
  for i,v in pairs(table2) do
    output[i] = v
  end
  return output
end
