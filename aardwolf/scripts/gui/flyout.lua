-- AardwolfMudlet: flyout
-- Group: aard > favMenu

function populatelist()
  cshops = {}
  cshopmenu = cshopmenu or {}
  cshopsubmenu = cshopsubmenu or {}

  table.insert(cshops, "30525")--bard
  table.insert(cshops, "30531")--bard
  table.insert(cshops, "30532")--bard
  table.insert(cshops, "30533")--bard
	
  table.insert(cshops, "49256")--boot
  table.insert(cshops, "49392")--boot
  table.insert(cshops, "50102")--boot
  table.insert(cshops, "50103")--boot
	
  table.insert(cshops, "31123")--crusader
  table.insert(cshops, "49217")--crusader
  table.insert(cshops, "47187")--crusader
  table.insert(cshops, "31150")--crusader
  table.insert(cshops, "31158")--crusader
  table.insert(cshops, "31128")--crusader
  table.insert(cshops, "31156")--crusader
	
  table.insert(cshops, "49335")--gaardian
  table.insert(cshops, "20029")--gaardian
  table.insert(cshops, "20035")--gaardian
			
  table.insert(cshops, "14162")--seekers
  table.insert(cshops, "14141")--seekers
  table.insert(cshops, "14168")--seekers

  table.insert(cshops, "31594")--tanelorn
  table.insert(cshops, "31584")--tanelorn
  table.insert(cshops, "31566")--tanelorn
	  
  table.insert(cshops, "29214")--tao
  table.insert(cshops, "29220")--tao
  table.insert(cshops, "29221")--tao
  table.insert(cshops, "29223")--tao
  table.insert(cshops, "49373")--tao
  
  table.insert(cshops, "50152")--touchstone
  table.insert(cshops, "28358")--touchstone
  table.insert(cshops, "28361")--touchstone
  table.insert(cshops, "28359")--touchstone
  table.insert(cshops, "50123")--touchstone
	
  table.insert(cshops, "34210")--amazon
	--baal NONE?
  table.insert(cshops, "15704")--cabal
	table.insert(cshops, "28910")--chaos
	table.insert(cshops, "27991")--crimson
  table.insert(cshops, "30949")--daoine
  table.insert(cshops, "16803")--doh
	table.insert(cshops, "5865")--dominion
	table.insert(cshops, "642")--dragon
	table.insert(cshops, "29580")--druid
  table.insert(cshops, "831")--emerald
	table.insert(cshops, "2292")--hook
	table.insert(cshops, "30415")--imperium  NO SHOP!!!
	table.insert(cshops, "2339")--light
	table.insert(cshops, "28580")--loqui
	table.insert(cshops, "15855")--masaki
	table.insert(cshops, "19967")--perdition
	table.insert(cshops, "15141")--pyre
	table.insert(cshops, "1961")--retribution
	table.insert(cshops, "502")--rhabdo	
  table.insert(cshops, "24182")--romani
	table.insert(cshops, "32408")--shadokil
	table.insert(cshops, "15574")--twinlobe
  table.insert(cshops, "879")--vanir  
  table.insert(cshops, "32342")--watchmen
  table.insert(cshops, "49572")--xunti
	
end

function testFunc(name)
  if roomExists(tonumber(name)) then
    gotoRoom(tonumber(name))
  else
    echo("\n[ClanShop] Room "..tostring(name).." not found in mapper. You may need to map this area first.\n")
  end
end

function checkShopMenu(roomid)
	subIndex = #cshopsubmenu + 1
  for j, room_id in pairs(cshopmenu) do
    if room_id.name == getRoomAreaName(getRoomArea(roomid)) then
      cshopsubmenu[subIndex]=cshopmenu[j]:addChild({name=getRoomAreaName(getRoomArea(roomid))..subIndex,height=aard.menuHeight,width=aard.subWidth, layoutDir="RV", flyOut=true, message=getRoomName(roomid)})
			cshopsubmenu[subIndex]:setClickCallback("testFunc", roomid)
			cshopsubmenu[subIndex]:setStyleSheet([[background-color: grey;   border-width: 1px;  border-style: solid;   border-color: green;  border-width: 1px;  font-size: 7pt;]])
			return 1
		end
  end
	return 0
end

function checkShopArea(roomid)
	areaIndex = #cshopmenu + 1
	areaPlus = 0
  for j, room_id in pairs(cshops) do
    if getRoomAreaName(getRoomArea(roomid)) == getRoomAreaName(getRoomArea(room_id)) then
			areaPlus = areaPlus + 1
		end
  end	
	if areaPlus > 1 then
		--multiple shops with that area name, add next/submenu for this area.
  	cshopmenu[areaIndex] = mainlabel:addChild({
    name=getRoomAreaName(getRoomArea(roomid)),
    height=aard.menuHeight,width=100,
    layoutDir="BV", flyOut=true,
    message=getRoomAreaName(getRoomArea(roomid))})  		
    cshopmenu[areaIndex]:setStyleSheet([[background-color: purple; border-width: 1px; border-style: solid; border-color: blue; border-radius: 1px;]])
		checkShopMenu(roomid)--add to sub menu
	else
		--only shop entry, no submenu
  	cshopmenu[areaIndex] = mainlabel:addChild({
    name=getRoomAreaName(getRoomArea(roomid)),
    height=aard.menuHeight,width=100,
    layoutDir="BV", flyOut=true,
    message=getRoomAreaName(getRoomArea(roomid))})
		cshopmenu[areaIndex]:setClickCallback("testFunc", roomid)
    cshopmenu[areaIndex]:setStyleSheet([[background-color: purple; border-width: 1px; border-style: solid; border-color: blue; border-radius: 1px;]])
	end
	return areaPlus
end

--options to layoutDir are the direction the window should go (R for right, L for left, T for top, B for bottom), followed by how the nested labels should be oriented (V for vertical or H for horizontal). So "BH" here means it'll go on the bottom of the label, while expanding horizontally
function cShopMenu()
  populatelist()--create the list of rooms
  mainlabel = Geyser.Label:new({name="cshopmenu0",x=0,y=0,height=25,width=100,nestflyout=true,message="<center>ClanShops</center>"})
  local skipped = 0
  for i, room_id in pairs(cshops) do
    if not roomExists(tonumber(room_id)) then
      skipped = skipped + 1
    else
      if cshopmenu[1] then		
        if checkShopMenu(cshops[i]) > 0 then
        else
          checkShopArea(cshops[i])
        end
      else
        checkShopArea(cshops[i])
      end
    end
  end
  if skipped > 0 then
    echo(string.format("\n[ClanShop] %d shop rooms not in mapper (skipped). Map more areas to unlock.\n", skipped))
  end
end
