-- AardwolfMudlet: areas
-- Group: aard > aardMap

-- Handles all zone related functions

function aard.map:resetZone(zone_name)
  local zone_found, zone_id = aard.map:isKnownZone(zone_name)

  if not zone_found then
    aard.log:error("Zone not found - can't reset")
  else
    local rooms = getAreaRooms(zone_id)

    if not rooms then
      aard.log:info("No rooms to remove in "..zone_name)
      return
    end

    for room_name, room_id in pairs(rooms) do
      deleteRoom(room_id)
    end
    aard.log:info("Removed all rooms from zone "..zone_name)
  end
end

function aard.map:isKnownZone(zone_name)
  local zones = getAreaTable()
  local zone_found = false
  local found_zone_id = nil
  
  for known_zone_name, zone_id in pairs(zones) do
    if known_zone_name == zone_name then
      zone_found = true
      found_zone_id = zone_id
      aard.log:debug("Found zone as id "..zone_id)
      break
    end
  end

  
  return zone_found, found_zone_id

end

function aard.map:createZone(new_zone_name)
  local new_zone_id = nil

  if not aard.map:isKnownZone() then
    new_zone_id = addAreaName(new_zone_name)
    aard.log:debug("New zone "..new_zone_name.." created with id: "..new_zone_id)
  else
    aard.log:debug("Zone already exists, not creating new zone")
  end

  return new_zone_id
end

function aard.map:getZoneId(zone_name)
  local found, zone_id = aard.map:isKnownZone(zone_name)
  if not found then
    zone_id = aard.map:createZone(zone_name)
  end

  return zone_id
end

function aard.map:setZone(zone_name)
  
  -- Set this zone as the active zone
  local zone_id = aard.map:getZoneId(zone_name)
  if zone_id then
    aard.map.current_zone = zone_name
  else
    aard.map:error("Failed to set zone!")
  end
  aard.log:debug("Current zone is now: "..aard.map.current_zone)
	aard.newzone = true
end
