-- AardwolfMudlet: coordrun
-- Group: aard > aardMap

--run 2s10e2n7e7n11e4n4e;enter hole
function vidblain(str)
  if string.match("sendhian", str) then
  	tempTimer(1,[[aard.coordrun(20286)]])
  elseif string.match("darklight", str) then
  	tempTimer(1,[[aard.coordrun(19643)]])
  elseif string.match("imperial nation", str) then
  	tempTimer(1,[[aard.coordrun(16966)]])
  else
  	echo("gt no vidblain match for: "..matches[2])
  end
end

function aard.coordrun(roomid)
  aard._coordrun_attempts = (aard._coordrun_attempts or 0) + 1
  if aard._coordrun_attempts > 30 then
    aard.log:error("coordrun: Timed out waiting to reach Vidblain for room "..tostring(roomid))
    aard._coordrun_attempts = nil
    if aard.crun then killTimer(aard.crun); aard.crun = nil end
    return
  end
  
  if aard.state == 3 and getRoomAreaName(getRoomArea(aard.map.seen_room)) == "vidblain" then
    aard._coordrun_attempts = nil
    gotoRoom(roomid)
  else
    aard.crun = tempTimer(1, function () aard.coordrun(roomid) end)
  end
end
