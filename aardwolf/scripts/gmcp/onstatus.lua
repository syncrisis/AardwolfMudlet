-- AardwolfMudlet: onStatus
-- Group: aard > gmcp
-- Events: gmcp.char.status

function onStatus()
	aard.state = gmcp.char.status.state
	aard.ename, aard.epct = gmcp.char.status.enemy, gmcp.char.status.enemypct or 0
	aard.tnl = gmcp.char.status.tnl

	if aard.cpLevel then
  	if aard.noexp == "" and tonumber(gmcp.char.status.level) > tonumber(aard.cpLevel) and tonumber(aard.config["cpexp"]) > tonumber(aard.tnl) and tonumber(gmcp.char.status.level) <= tonumber(aard.config["cplvl"]) then
      aard.noexp = " *NO EXP*"
      aard.qTimeNOexp()
  		send("noexp")
  	end
	end

	local align = gmcp.char.status.align	
	if aard.ename == "" then
		aard.ename = "enemy"
	end
	Enemy:setValue(aard.epct, 100, "<b> &nbsp; "..aard.ename.." | "..string.format("%i", aard.epct).."%</b>")	
	gStyleW = '<font style="color:#ffffff">'
	gStyleR = '<font style="color:#1aa41a">'
	aard.qTimeNOexp()
	if align > 875 then
		GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.goodc1..", stop: 1 "..aard.goodc2..")")--good
		Align:setValue(align, 2500, "<b> &nbsp; Align: "..align.."</b>")
	elseif align > -1 then
		GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.neutralc1..", stop: 1 "..aard.neutralc2..")")--neutral
		Align:setValue(align, 2500, "<b> &nbsp; Align: "..align.."</b>")
	elseif align > -874 then
		GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.neutralc1..", stop: 1 "..aard.neutralc2..")")--neutral negative		
		Align:setValue(-1*align, 2500, "<b> &nbsp; Align: "..align.."</b>")
	else
		GaugeFrontCSS:set("background-color","QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 "..aard.evilc1..", stop: 1 "..aard.evilc2..")")--evil negative
		Align:setValue(-1*align, 2500, "<b> &nbsp; Align: "..align.."</b>")
	end
	Align.front:setStyleSheet(GaugeFrontCSS:getCSS())
end
