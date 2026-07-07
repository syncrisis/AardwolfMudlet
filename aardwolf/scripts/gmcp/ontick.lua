-- AardwolfMudlet: onTick
-- Group: aard > gmcp
-- Events: gmcp.comm.tick

function onTick()
  if math.floor((aard.timerQuest-math.floor(getEpoch()+0.5))/60) <= 0 then
  	aard.qtime = 0--its quest time
  else
		local myQT = math.floor((aard.timerQuest-getEpoch())/60)
		if myQT > 0 then
  		aard.qtime = myQT
		else
			aard.qtime = 1
		end
  end
  if math.floor((aard.timerDaily-math.floor(getEpoch()+0.5))/60) <= 0 then
  	aard.dtime = 0--its daily blessing time
  else
		local myDT = math.floor((aard.timerDaily-getEpoch())/60)
		--local myDT = aard.timerDaily-getEpoch()
		if myDT > 0 then
  		aard.dtime = myDT
		else
			aard.dtime = 1
		end
  end
	aard.qTimeNOexp()
end
--aard.timerDaily = getEpoch()+(matches[2]*60*60)+(matches[3]*60)+matches[4]
--aard.dtime
