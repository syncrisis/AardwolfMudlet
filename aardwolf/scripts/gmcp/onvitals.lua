-- AardwolfMudlet: onVitals
-- Group: aard > gmcp
-- Events: gmcp.char.vitals, gmcp.char.maxstats

function onVitals()

	--if not (aard.gui.init) then return end

	-- On startup, char.vitals can come in before maxstats
	if not (gmcp.char.maxstats) then return end

	aard.hp, aard.maxhp = gmcp.char.vitals.hp, gmcp.char.maxstats.maxhp
	aard.mp, aard.maxmp = gmcp.char.vitals.mana, gmcp.char.maxstats.maxmana
	aard.mv, aard.maxmv = gmcp.char.vitals.moves, gmcp.char.maxstats.maxmoves

	local hp_pct = tostring(getPercent(aard.hp, aard.maxhp))
	local mp_pct = tostring(getPercent(aard.mp, aard.maxmp))
	local mv_pct = tostring(getPercent(aard.mv, aard.maxmv))
	
	if aard.hp > aard.maxhp then
		aard.hp = aard.maxhp
	end
	Health:setValue(aard.hp, aard.maxhp,"<b> &nbsp; "..aard.hp.."hp | "..string.format("%i", hp_pct).."% &nbsp; ("..aard.hpot..")</b>")
	Mana:setValue(aard.mp, aard.maxmp,"<b> &nbsp; "..aard.mp.."mp | "..string.format("%i", mp_pct).."% &nbsp; ("..aard.spot..")</b>")
	Moves:setValue(aard.mv, aard.maxmv,"<b> &nbsp; "..aard.mv.."mv | "..string.format("%i", mv_pct).."% &nbsp; ("..aard.mpot..")</b>")
	
	--update group values for my character from char.vitals because it updates faster than group info that is only every 2-3 seconds.
	if aard.gindex ~= 0 then
		if aard.config["group"] == 1 then
			gHpBar[aard.gindex]:setValue(aard.hp, aard.maxhp)
    	gMnBar[aard.gindex]:setValue(aard.mp, aard.maxmp)
    	gMvBar[aard.gindex]:setValue(aard.mv, aard.maxmv)
		else		
    	gHpBar[aard.gindex]:setValue(aard.hp, aard.maxhp,"<b>&nbsp;hp&nbsp;"..aard.hp.."&nbsp;/&nbsp;"..aard.maxhp.."&nbsp;"..string.format("%i", hp_pct).."%</b>")
    	gMnBar[aard.gindex]:setValue(aard.mp, aard.maxmp,"<b>&nbsp;mn&nbsp;"..aard.mp.."&nbsp;/&nbsp;"..aard.maxmp.."&nbsp;"..string.format("%i", mp_pct).."%</b>")
    	gMvBar[aard.gindex]:setValue(aard.mv, aard.maxmv,"<b>&nbsp;mv&nbsp;"..aard.mv.."&nbsp;/&nbsp;"..aard.maxmv.."&nbsp;"..string.format("%i", mv_pct).."%</b>")
		end
	end

end

function getPercent(top, bottom)
	return (tonumber(top)/tonumber(bottom)) * 100
end
