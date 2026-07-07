-- AardwolfMudlet: onInGame
-- Group: aard
-- Events: inGame

-- Actions to occur once we are truly 'in' the game. 
-- Will only fire on first connect/reconnect
function onInGame()
	setServerEncoding("UTF-8")	
	aard.command = nil -- clear this so that the mapper does not think our mud password is a special exit command
	
	-- Need to be fully in-game before getting room/sector info	
	sendGMCP('Core.Supports.Set [ "Char 1", "Comm 1", "Room 1" ]')
	sendGMCP("tags on")
	sendGMCP("maptype 1")
	sendGMCP("group on")
	
	sendGMCP("request room")
	sendGMCP("request sectors")
	sendGMCP("request char")
	sendGMCP("request quest") --used for quest time
	
	--sendGMCP("gmcpchannels on") -- ommit channels from main output
	

	send("tags map on",false)-- enable maptags so we can capture minimap.
	send("map",false)-- sends the command "map" to the mud without echoing to the screen.	
	send("look in "..aard.config["pbag"],false)-- look in potion container so we can update our count when logging in.
	send("daily",false)--daily blessing status not available via GMCP, so we need to check it, to set the timer.
	
	aard.command = nil -- clear this so that the mapper does not think our mud password is a special exit command
	
	--map off:
	--sendGMCP("maptype -1")
	
	 --"0 - Standard ASCII based map|"
   --"1 - Solid single line map|"
   --"2 - Solid double line map|"
   --"3 - Solid single line map (no end caps)|"
   --"4 - Solid double line map (no end caps)|"
   --"5 - Solid single line map (extended walls)|"
   --"6 - Solid double line map (extended walls)|"

	--send("P",false) -- Force a prompt to display to init various prompt-based flags
	--send("look",false)
end
