-- AardwolfMudlet: aard (group init)
-- Group: aard

uninstallPackage("generic_mapper")

aard = aard or {}
aard.gui = aard.gui or {}
aard.map = aard.map or {}
aard.log = aard.log or {}
aard.command = nil
aard.other = false
aard.newzone = false
aard.state = aard.state or 0
aard.tnl = aard.tnl or 0
aard.qtime = aard.qtime or 0
aard.dtime = aard.dtime or 0
aard.timerQuest = aard.timerQuest or 0
aard.timerDaily = aard.timerDaily or 0
aard.tnlmax = aard.tnlmax or 1000
aard.noexp = aard.noexp or ""
aard.name = aard.name or ""
aard.gindex = aard.gindex or 0
aard.ename = aard.ename or ""
aard.epct = aard.epct or 0
aard.hp = aard.hp or 100
aard.mp = aard.mp or 100
aard.mv = aard.mv or 100
aard.maxhp = aard.maxhp or 100
aard.maxmp = aard.maxmp or 100
aard.maxmv = aard.maxmv or 100
aard.hpot = aard.hpot or 0
aard.spot = aard.spot or 0
aard.mpot = aard.mpot or 0

function aard.log:debug(msg)
  if aard.log.enableDebug then
    cecho("<dark_slate_grey>[<white>::<dark_orchid>(debug):<light_grey> "..msg.." <white>::<dark_slate_grey>]\n")
  end
end

function aard.log:info(msg)
  cecho("<dark_slate_grey>[<white>::<light_slate_grey>(info):<light_grey> "..msg.." <white>::<dark_slate_grey>]\n")
end

function aard.log:error(msg)
  cecho("<dark_slate_grey>[<white>::<firebrick>(error):<light_grey> "..msg.." <white>::<dark_slate_grey>]\n")
end

function aard.audioAlert(event)
  if aard.config["speak"] == "true" then
    if GUIframe.speech[event] == nil then
      aard.log:error("Undefined speech audio alert: " .. event)
      return
    end
  
    ttsSpeak(GUIframe.speech[event])
    return
  end
  
  if GUIframe.sounds[event] == nil then
    aard.log:error("Undefined audio alert: " .. event)
    return
  end
  
  playSoundFile(GUIframe.sounds[event])
end

function round(n)
  return math.floor(n + 0.5)
end
