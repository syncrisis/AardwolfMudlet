-- AardwolfMudlet: onGroup
-- Group: aard > gmcp
-- Events: gmcp.group

function onGroup()
	--display(gmcp.group)
	--if not (aard.gui.init) then return end
	--local g1hp, g1mhp = 99999, 99999
	if aard.config["group"] == 0 then

		
	elseif aard.config["group"] == 1 then
  	--begin create
  	group = group or {}
  	gAlignBar = gAlignBar or {}
  	gHpBar = gHpBar or {}
  	gMnBar = gMnBar or {}
  	gMvBar = gMvBar or {}
		gDamBar = gDamBar or {}
  	
  	local barHb = 14
		local barHs = 4
  	local barW = 150
  	
  	if not gInfo then
      gInfo = Geyser.Label:new({
        name = "gInfo",
        x=0, y=0,
        width=barW, height=barHb,
        fgColor = "white",
        color = "#31363b",
      })
  	end
  	--gmcp.group.count  this value if larger than x amount could be used for alternate compact EPIC layout.
  	
  	--Does Group Exist?
  	if not gmcp.group.count then
			--echo clickable link to clear group data
			--aard.group = {}
  		gInfo:hide()
    	for i=1,50 do
    		if group[i] then
    			group[i]:hide()
  				--echo("\ngroup["..i.."]:hide()\n")
    		else
    			break--exit the loop, no containers exist beyond this index.
    		end
    	end
  	else
  		gInfo:hide()
  	end
  	
		if gmcp.group.members then
		
			aard.group = aard.group or {}
      for _, member in ipairs(gmcp.group.members) do
				aard.group[member.name] = aard.group[member.name] or {alldam=1,pheal=0}--give 1 free point of damage show the gauges initialize properly
    		--display(member.name)
    		--display(member.info)
    		if not group[_] then
      		--echo("\nNope, group ".._.." Create\n")
    			if _ == 1 then--group member containers
            group[_] = Geyser.Container:new({
            name = "group".._,
            x=0, y=0,
            width=barW, height=barHb+(3*barHs),
            },gInfo)
    			else
            group[_] = Geyser.Container:new({
            name = "group".._,
            x=0, y=barHb+(3*barHs),
            width=barW, height=barHb+(3*barHs),
            },group[_-1])
      		end
          gHpBar[_] = Geyser.Gauge:new({
          	name = "gHpBar".._,
          	x=0,y=0,
          	width=barW,height=barHb
          },group[_])
          gMnBar[_] = Geyser.Gauge:new({
          	name = "gMnBar".._,
          	x=0,y=barHb,
          	width=barW,height=barHs
          },gHpBar[_])
          gMvBar[_] = Geyser.Gauge:new({
          	name = "gMvBar".._,
          	x=0,y=barHs,
          	width=barW,height=barHs
          },gMnBar[_])
          gAlignBar[_] = Geyser.Gauge:new({
          	name = "gAlignBar".._,
          	x=0,y=barHs,
          	width=barW,height=barHs
          },gMvBar[_])
					gDamBar[_] = Geyser.Gauge:new({
          	name = "gDamBar".._,
						orientation = "goofy",
          	x=(82+barW)*-1,y=0,
          	width=82,height=barHb+barHs+barHs
          },group[_])
  				
          gAlignBar[_].back:setStyleSheet(GaugeBackGCSS1:getCSS())
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.neutralc1..", stop: 1 "..aard.neutralc2..")")
          gAlignBar[_].front:setStyleSheet(GaugeFrontGCSS1:getCSS())
          gAlignBar[_]:setValue(100,100)
          
          gHpBar[_].back:setStyleSheet(GaugeBackGCSS1:getCSS())
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.hpc1..", stop: 1 "..aard.hpc2..")")
          gHpBar[_].front:setStyleSheet(GaugeFrontGCSS1:getCSS())
          gHpBar[_]:setValue(100,100)
          
          gMnBar[_].back:setStyleSheet(GaugeBackGCSS1:getCSS())
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.mnc1..", stop: 1 "..aard.mnc2..")")
          gMnBar[_].front:setStyleSheet(GaugeFrontGCSS1:getCSS())
          gMnBar[_]:setValue(100,100)
          
          gMvBar[_].back:setStyleSheet(GaugeBackGCSS1:getCSS())
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.mvc1..", stop: 1 "..aard.mvc2..")")
          gMvBar[_].front:setStyleSheet(GaugeFrontGCSS1:getCSS())
          gMvBar[_]:setValue(100,100)
					
          gDamBar[_].back:setStyleSheet(GaugeBackGCSS2:getCSS())
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.evilc1..", stop: 1 "..aard.evilc2..")")
          gDamBar[_].front:setStyleSheet(GaugeFrontGCSS1:getCSS())
          gDamBar[_]:setValue(1,100)
					
  				gAlignBar[_]:hide()
    		else
    			if _ <= gmcp.group.count then
    				group[_]:show()
    			end
    		end
				
				--get total group damage
				local gmdam = 0
        for k, v in pairs(aard.group) do
					gmdam = gmdam + v.alldam
        end
				--im not sure this is done properly, look at it later to make sure general stats dont overwrite personal ones later
    		if aard.name == gmcp.group.members[_].name then
    			aard.gindex = _
    			
        	if not (gmcp.char.maxstats) then return end
        	local hp_pct = tostring(getPercent(aard.hp, aard.maxhp))
        	local mp_pct = tostring(getPercent(aard.mp, aard.maxmp))
        	local mv_pct = tostring(getPercent(aard.mv, aard.maxmv))
    
          gHpBar[_]:setValue(aard.hp, aard.maxhp,"<b>&nbsp;hp&nbsp;"..aard.hp.."&nbsp;/&nbsp;"..aard.maxhp.."&nbsp;"..string.format("%i", hp_pct).."%</b>")
          gMnBar[_]:setValue(aard.mp, aard.maxmp)
          gMvBar[_]:setValue(aard.mv, aard.maxmv)
    		end
    		
        local ghp, gmhp = gmcp.group.members[_].info.hp, gmcp.group.members[_].info.mhp
        local gmn, gmmn = gmcp.group.members[_].info.mn, gmcp.group.members[_].info.mmn
        local gmv, gmmv = gmcp.group.members[_].info.mv, gmcp.group.members[_].info.mmv
				
				if gmdam == 0 then
					gmdam = 100
				end
				local gdam = 0
				if aard.group[gmcp.group.members[_].name] then
					gdam = aard.group[gmcp.group.members[_].name].alldam
				end
				
				local galign = gmcp.group.members[_].info.align
        
        local hp_pct = tostring(getPercent(ghp, gmhp))
        local mp_pct = tostring(getPercent(gmn, gmmn))
        local mv_pct = tostring(getPercent(gmv, gmmv))
				local dam_pct = tostring(getPercent(gdam, gmdam))
				

        
				if ghp > gmhp then
          ghp = gmhp
        end
        
        if gmcp.group.members[_].info.here == 0 then
          gh = "*"
        else
          gh = "&nbsp;"
        end
        
  			gStyleW = '<font style="color:white">'
    		gStyleR = '<font style="color:'..aard.goodc1..'">'
				
				local lvl = gmcp.group.members[_].info.lvl
				lvl = string.format("%3s", lvl)
				lvl = string.gsub(lvl," ","&nbsp;")
  			
				local name = gmcp.group.members[_].name
				name = string.format("%-9s", string.sub(name, 1, 9))
				name = string.gsub(name," ","&nbsp;")
				
				local qt = gmcp.group.members[_].info.qt
				qt = string.format("%2s", qt)
				qt = string.gsub(qt," ","&nbsp;")

				local tnl = gmcp.group.members[_].info.tnl
				tnl = string.format("%4s", tnl)
				tnl = string.gsub(tnl," ","&nbsp;")
				
				--local dpct = aard.group[gmcp.group.members[_].name].pheal.."  "..string.format("%i", dam_pct).."%"
				local dpct = string.format("%i", dam_pct).."%"
				dpct = string.format("%12s", dpct)
				dpct = string.gsub(dpct," ","&nbsp;")
				
  			if gmcp.group.members[_].name == gmcp.group.leader then
        	gHpBar[_]:setValue(ghp, gmhp,"<font face='Bitstream Vera Sans Mono'><b>"..gh..lvl.."&nbsp;"..gStyleR..name..gStyleW.."&nbsp;"..qt.."&nbsp;"..tnl.."</b></font>")
				else
  				gHpBar[_]:setValue(ghp, gmhp,"<font face='Bitstream Vera Sans Mono'><b>"..gh..lvl.."&nbsp;"..name.."&nbsp;"..qt.."&nbsp;"..tnl.."</b></font>")
  			end
        gMnBar[_]:setValue(gmn, gmmn)
        gMvBar[_]:setValue(gmv, gmmv)
				
				gDamBar[_]:setValue(gdam, gmdam,"<font face='Bitstream Vera Sans Mono'><b>"..dpct.."&nbsp;</b></font>")
				
        if galign > 875 then
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.goodc1..", stop: 1 "..aard.goodc2..")")--good
          gAlignBar[_]:setValue(galign, 2500)
        elseif galign > -1 then
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.neutralc1..", stop: 1 "..aard.neutralc2..")")--neutral
          gAlignBar[_]:setValue(galign, 2500)
        elseif galign > -874 then
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.neutralc1..", stop: 1 "..aard.neutralc2..")")--neutral negative		
          gAlignBar[_]:setValue(-1*galign, 2500)
        else
          GaugeFrontGCSS1:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.evilc1..", stop: 1 "..aard.evilc2..")")--evil negative
          gAlignBar[_]:setValue(-1*galign, 2500)
        end
        gAlignBar[_].front:setStyleSheet(GaugeFrontGCSS1:getCSS())
  			gAlignBar[_]:hide()
      end
	
  		--hide any extra containers
    	for i=gmcp.group.count+1,50 do
    		if group[i] then
    			group[i]:hide()
    			--echo("\ngroup["..i.."]:hide()\n")
    		else
    			break--exit the loop, no containers exist beyond this index.
    		end
    	end
			
		end
		
	elseif aard.config["group"] == 2 then
	
	end
end
