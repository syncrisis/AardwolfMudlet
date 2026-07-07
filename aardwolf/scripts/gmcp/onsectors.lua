-- AardwolfMudlet: onSectors
-- Group: aard > gmcp
-- Events: gmcp.room.sectors

function onSectors()
  if(aard.map.sectors) then return end

  aard.map:setCustomColors()
  aard.map.sectors = true
end
