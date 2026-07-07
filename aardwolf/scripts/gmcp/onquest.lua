-- AardwolfMudlet: onQuest
-- Group: aard > gmcp
-- Events: gmcp.comm.quest

function onQuest()
	if (gmcp.comm.quest.wait) then
		aard.qtime = gmcp.comm.quest.wait
		aard.timerQuest=math.floor(getEpoch() + 0.5)+gmcp.comm.quest.wait*60
	elseif (gmcp.comm.quest.status == "ready") then
		aard.timerQuest=math.floor(getEpoch())
	elseif (gmcp.comm.quest.action == "start" or gmcp.comm.quest.action == "status") then
		if (gmcp.comm.quest.timer) then
			--questing
		elseif (gmcp.comm.quest.time) then
			--qtime
		end
	end
	aard.qTimeNOexp()
end
