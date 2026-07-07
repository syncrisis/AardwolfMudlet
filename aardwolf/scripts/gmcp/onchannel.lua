-- AardwolfMudlet: onChannel
-- Group: aard > gmcp
-- Events: gmcp.comm.channel

local path = getMudletHomeDir()
path = path:gsub("[\\/]","/")

-- Derive spoken definitions from sound definitions
GUIframe.speech = {}

GUIframe.sounds = {
  Alert = [[/aardwolf/alert.wav]],
  Quest = [[/aardwolf/alert.wav]],
  Gquest = [[/aardwolf/alert.wav]],
  Clan = [[/aardwolf/clan.wav]],
  Friend = [[/aardwolf/friend.wav]],
  Group = [[/aardwolf/group.wav]],
  Say = [[/aardwolf/say.wav]],
  Spouse = [[/aardwolf/spouse.wav]],
  Tell = [[/aardwolf/tell.wav]],
}

-- Update paths for sound files and define default spoken announcements
for alertType, _ in pairs(GUIframe.sounds) do
  GUIframe.sounds[alertType] = path .. GUIframe.sounds[alertType]:gsub("[\\/]","/")
  GUIframe.speech[alertType] = alertType
end

-- Override speech announcements, if desired
GUIframe.speech["Quest"] = "Quest ready"
GUIframe.speech["Gquest"] = "Global quest starting"

--refactor associative table for sounds, loop them
if not (io.exists(GUIframe.sounds["Alert"]) and io.exists(GUIframe.sounds["Clan"])) then
    aard.log:error("Unable to locate sound files, please check path and configuration.")
end

function chanpEcho(chan,msg)
	decho(chan,msg.."\n")
	decho("Private",msg .. "\n")--send a copy to "Private" tab
	decho("All",msg .. "\n")--send a copy to "All" tab
	local atab = GUIframe.configs.activeLast
	if atab ~= chan and atab ~= "Private" and atab ~= "All" then
		GUIframe.configs.tabsToBlink[chan] = true--set the tab to be blinked
		GUIframe.configs.tabsToBlink["Private"] = true--set the tab to be blinked
	end
	if not string.find(msg,gmcp.char.base.name..": ") then
    aard.audioAlert(chan)
	end
end


function onChannel()
  local comm_data = gmcp.comm.channel
	local chan = gmcp.comm.channel.chan
	local replaced = ansi2decho(comm_data.msg)
	--display(comm_data)
	
	if chan == "tell" then
		chanpEcho("Tell",replaced)
	elseif chan == "say" then
		chanpEcho("Say",replaced)
	elseif chan == "gtell" then
		chanpEcho("Group",replaced)
	elseif chan == "ftalk" then
		chanpEcho("Friend",replaced)	
	elseif chan == "clantalk" then
		chanpEcho("Clan",replaced)
	elseif chan == "spouse" then
		chanpEcho("Spouse",replaced)
	else
		decho("All",replaced .. "\n")--send a copy to "All" tab
	end
end
