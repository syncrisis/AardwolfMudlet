-- AardwolfMudlet: guiLoad
-- Group: aard

function aard.qTimeNOexp()
  gStyleW = '<font style="color:#ffffff">'
  gStyleG = '<font style="color:#1aa41a">'
	
  if aard.qtime == 0 then
    Tnl:setValue(aard.tnlmax-aard.tnl, aard.tnlmax, "<b>&nbsp;TNL: "..aard.tnl..gStyleG.."&nbsp; QT:"..aard.qtime.."&nbsp;"..aard.noexp.."&nbsp;"..aard.dtime.."</b>")
  else
    Tnl:setValue(aard.tnlmax-aard.tnl, aard.tnlmax, "<b>&nbsp;TNL: "..aard.tnl.."&nbsp; QT:"..aard.qtime..gStyleG.."&nbsp;"..aard.noexp.."&nbsp;"..aard.dtime.."</b>")
  end	
end

function guiLoad()
--Chat Tabs
	All = Geyser.MiniConsole:new({name = "All",autoWrap = true,color = "black",fontSize = 10})
  Private = Geyser.MiniConsole:new({name = "Private",autoWrap = true,color = "black",fontSize = 10})
  Group = Geyser.MiniConsole:new({name = "Group",autoWrap = true,color = "black",fontSize = 10})
	Tell = Geyser.MiniConsole:new({name = "Tell",autoWrap = true,color = "black",fontSize = 10})
	Say = Geyser.MiniConsole:new({name = "Say",autoWrap = true,color = "black",fontSize = 10})
	Spouse = Geyser.MiniConsole:new({name = "Spouse",autoWrap = true,color = "black",fontSize = 10})
	Clan = Geyser.MiniConsole:new({name = "Clan",autoWrap = true,color = "black",fontSize = 10})
	Friend = Geyser.MiniConsole:new({name = "Friend",autoWrap = true,color = "black",fontSize = 10})
	--ItemDB = Geyser.MiniConsole:new({name = "ItemDB",autoWrap = true,color = "black",fontSize = 10})

	GUIframe.addWindow(All,"All","bottomright")
  GUIframe.addWindow(Private,"Private","bottomright")
  GUIframe.addWindow(Group,"Group","bottomright")
	GUIframe.addWindow(Tell,"Tell","bottomright")
	GUIframe.addWindow(Say,"Say","bottomright")
	GUIframe.addWindow(Spouse,"Spouse","bottomright")
	GUIframe.addWindow(Clan,"Clan","bottomright")
	GUIframe.addWindow(Friend,"Friend","bottomright")
	--GUIframe.addWindow(ItemDB,"ItemDB","bottomleft")

--Footer Gauges
	Footer = Geyser.HBox:new({name = "Footer", x = 0, y = 0, width = "100%", height = "100%"})
	GUIframe.addWindow(Footer, 'Gauges', 'bottom')

  Column1 = Geyser.VBox:new({name = "Column1"},Footer)
  Column2 = Geyser.VBox:new({name = "Column2"},Footer)
  Column3 = Geyser.VBox:new({name = "Column3"},Footer)

	--regular group style
  GaugeBackGCSS = CSSMan.new([[
    background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #666,  stop: 1 #333);
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 1;
    padding: 1px;
    margin: 1px;
  ]])
  GaugeFrontGCSS = CSSMan.new([[
    background-color: rgba(0,0,0,0);
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 1;
    padding: 1px;
    margin: 1px;
  ]])

	--compact group style
  GaugeBackGCSS2 = CSSMan.new([[
    background-color: rgba(0,0,0,0%);
    border: 0px;
    padding: 0px;
    margin: 0px;
  ]])
	--compact group style
  GaugeBackGCSS1 = CSSMan.new([[
    background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #666,  stop: 1 #333);
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 1;
    padding: 0px;
    margin: 0px;
  ]])
  GaugeFrontGCSS1 = CSSMan.new([[
    background-color: rgba(0,0,0,0);
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 1;
    padding: 0px;
    margin: 0px;
  ]])

	--gauges style
  GaugeBackCSS = CSSMan.new([[
    background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #666,  stop: 1 #333);
    border-width: 1px;
    border-color: black;
    border-style: solid;
    border-radius: 2;
    padding: 1px;
    margin: 2px;
  ]])
  GaugeFrontCSS = CSSMan.new([[
    background-color: rgba(0,0,0,0);
    border-top: 1px black solid;
    border-left: 1px black solid;
    border-bottom: 1px black solid;
    border-radius: 2;
    padding: 1px;
    margin: 2px;
  ]])

  Enemy = Geyser.Gauge:new({
    name = "Enemy",
  },Column1)
  Enemy.back:setStyleSheet(GaugeBackCSS:getCSS())
  GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.enemyc1..", stop: 1 "..aard.enemyc2..")")
  Enemy.front:setStyleSheet(GaugeFrontCSS:getCSS())
  Enemy:setValue(0,100,"<b> &nbsp; enemy</b>")

  Health = Geyser.Gauge:new({
    name = "Health",
  },Column1)
  Health.back:setStyleSheet(GaugeBackCSS:getCSS())
  GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.hpc1..", stop: 1 "..aard.hpc2..")")
  Health.front:setStyleSheet(GaugeFrontCSS:getCSS())
  Health:setValue(100,100,"<b> &nbsp; hp</b>")

	Moves = Geyser.Gauge:new({
    name = "Moves",
  },Column2)
  Moves.back:setStyleSheet(GaugeBackCSS:getCSS())
  GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.mvc1..", stop: 1 "..aard.mvc2..")")
  Moves.front:setStyleSheet(GaugeFrontCSS:getCSS())
  Moves:setValue(100,100,"<b> &nbsp; mv</b>")

  Mana = Geyser.Gauge:new({
    name = "Mana",
  },Column2)
  Mana.back:setStyleSheet(GaugeBackCSS:getCSS())
  GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.mnc1..", stop: 1 "..aard.mnc2..")")
  Mana.front:setStyleSheet(GaugeFrontCSS:getCSS())
  Mana:setValue(100,100,"<b> &nbsp; mp</b>")

  Tnl = Geyser.Gauge:new({
    name = "Tnl",
  },Column3)
  Tnl.back:setStyleSheet(GaugeBackCSS:getCSS())
  GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.tnlc1..", stop: 1 "..aard.tnlc2..")")
  Tnl.front:setStyleSheet(GaugeFrontCSS:getCSS())
  Tnl:setValue(100,100,"<b> &nbsp; tnl</b>")

	Align = Geyser.Gauge:new({
    name = "Align",
  },Column3)
  Align.back:setStyleSheet(GaugeBackCSS:getCSS())
  GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.neutralc1..", stop: 1 "..aard.neutralc2..")")
  Align.front:setStyleSheet(GaugeFrontCSS:getCSS())
  Align:setValue(100,100,"<b> &nbsp; align</b>")
end

if not guiLoaded then--only run once per launch of mudlet
	guiLoaded = true
	guiLoad()
end

--this section is to load the map and events following it seperately because of a current bug:
-- https://github.com/Mudlet/Mudlet/issues/2076
-- basically by using a tempTimer to load this part of the GUI it will load the settings properly.
registerAnonymousEventHandler(
  'sysLoadEvent',
  function()
    if GUIframe then
      if not mapcontainer then
        mapcontainer = Geyser.Container:new({name = 'mapcontainer', x = 0, y = 0, width = 300, height = 400})
        mapwin = Geyser.Mapper:new({name = "mapwin", x = 0, y = 0, width = '100%', height = '100%'}, mapcontainer)
        tempTimer(0.1, function()
          GUIframe.addWindow(mapcontainer, "Map", "topright")
					print('MainWindowSize: ' .. tostring(getMainWindowSize()))
        	mapCheck()
        	setMapZoom(35)
					GUIframe.loadSettings()
					GUIframe.activate("All")
					styleLoad()--set scrollbar stylesheet
        		local mapw = 232
        		local maph = 255
        		-- Free-floating minimap with drag handle
        		asciiContainer = Geyser.Container:new({name='asciiContainer', x='54%', y='72%', width=mapw, height=maph})
        		local dragBar = Geyser.Label:new({name='asciiDragBar', x=0, y=0, width='100%', height=12, color='#444444', message='<center>ASCII Map (drag)</center>'}, asciiContainer)
        		dragBar:setMoveCallback(function() local mx, my = getMousePosition() asciiContainer:move(mx, my) end)
        		minimap = Geyser.MiniConsole:new({name="minimap",x=0,y=12,width='100%',height='100%-12px',color="black",font="Source Code Pro Black",fontSize=10}, asciiContainer)
        		minimapsnap()
					if (aard.map.enable) then aard:init_map() end
					aard.init = true
					aard.log:info("Scripts initialized")
					cShopMenu()--if rooms are missing from map this can break loading, do it last.
        end)
      end
    end
  end
)
