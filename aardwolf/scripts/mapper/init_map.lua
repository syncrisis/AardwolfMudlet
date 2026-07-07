-- AardwolfMudlet: init_map
-- Group: aard > aardMap

function aard:init_map()
  
  --sendGMCP("rawcolor on")
  
  aard.map.current_zone = nil
  aard.map.current_room = nil
  aard.map.prior_room = nil
  aard.map.prior_room_data = {}
  aard.map.seen_room = nil
  aard.map.terrain = {}
  aard.map.sectors = nil
  
  aard.map.init = true
  aard.log:info("Initalized aard mapper")
	
end
