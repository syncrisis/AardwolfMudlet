-- AardwolfMudlet: adt pup level death
-- Group: aard > adt

function pup(clan,player)
	aard.foundmatch=true
  aard.adt.pups[clan] = aard.adt.pups[clan] or {}
  if aard.adt.pups[clan][player] then
  	aard.adt.pups[clan][player] = aard.adt.pups[clan][player] + 1
  else
  	aard.adt.pups[clan][player] = 1
  end
	setTriggerStayOpen("infogate",0)
	deleteLine()	
end

function lvl(clan,player)
	aard.foundmatch=true
  aard.adt.lvls[clan] = aard.adt.lvls[clan] or {}
  if aard.adt.lvls[clan][player] then
  	aard.adt.lvls[clan][player] = aard.adt.lvls[clan][player] + 1
  else
  	aard.adt.lvls[clan][player] = 1
  end
	setTriggerStayOpen("infogate",0)
	deleteLine()	
end

function death(clan,player)
	if string.find(player, "HARDCORE") then-- was still testing this as hardcore deaths should probably go in their own table.
		appendBuffer("All")
		appendBuffer("Spouse")
	else
  	aard.foundmatch=true
    aard.adt.deaths[clan] = aard.adt.deaths[clan] or {}
    if aard.adt.deaths[clan][player] then
    	aard.adt.deaths[clan][player] = aard.adt.deaths[clan][player] + 1
    else
    	aard.adt.deaths[clan][player] = 1
    end
  	setTriggerStayOpen("infogate",0)
  	deleteLine()
	end
end
