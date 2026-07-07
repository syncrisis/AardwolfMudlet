-- AardwolfMudlet: config
-- Group: aard

-----------------------
-- User Config - BACKUP settings here to notepad prior to upgrading to new version.
-----------------------
aard.configDefault = {
["hpot"]="elixir",
["mpot"]="moonlight",
["vpot"]="refreshing",
["pbag"]="bag",
["wield"]="dagger",
["dual"]="dagger",
["port"]="hold duff;enter;hold flute",
["attack1"]="hammer",
["debuff1"]="marbu",
["debuff2"]="dirt",
["cplvl"]=150,
["cpexp"]=700,
["group"]=1,
["tdiff"]=-3,
["speak"]="false", -- Stringly typed because of user input in vconfig
}

--Automatically toggle noexp once your TNL is less than this amount on CP level +1
--This is to get in 1 CP every level, without mistakenly leveling +2 levels during a CP.
--The default is assumed CP leveling
--aard.cplvl = 150--set to 0 to disable
--aard.cpexp = 700

--group window format group: 0=normal, 1=compact, 2=compact minimal

--Aardwolf is based on Eastern Time (ET), so to adjust set this to a positive or negative number to correct for local time.
--My local time is Pacific Time (PT) so I use -3

--gauge bar colors
aard.hpc1="#1aa41a"
aard.hpc2="#005500"

aard.mnc1="#4570fc"
aard.mnc2="#1133cc"

aard.mvc1="#b0b051"
aard.mvc2="#555511"

aard.tnlc1="#a343cd"
aard.tnlc2="#4c006e"

aard.goodc1="#d98839"
aard.goodc2="#814100"
aard.neutralc1="#888"
aard.neutralc2="#444"
aard.evilc1="#8c2929"
aard.evilc2="#410000"

aard.enemyc1="#f04141"
aard.enemyc2="#cc0000"

aard.menuHeight = 25
aard.subWidth = 200

-- Set to true to enable the GUI functionality
aard.gui.enable = true--currently unused

-- Set to true to enable the mapping script
aard.map.enable = true

-- Turn on debug output. very spammy.
aard.log.enableDebug = false

--scrollbar StyleSheet
function styleLoad()
  local grey = "#31363b"
  local blue = "#2478c8"
	local black = "#000000"
  setAppStyleSheet([[
    QScrollBar:vertical {
       background: ]]..black..[[;
       margin: 9px 0 9px 0;
  		 border-radius: 7px;
    }
    QScrollBar:vertical:hover {
       background: ]]..grey..[[;
    }
    QScrollBar::handle:vertical {
       background-color: ]]..grey..[[;
       min-height: 20px;
       border-width: 4px;
       border-style: solid;
       border-color: ]]..black..[[;
       border-radius: 7px;
    }
    QScrollBar::handle:vertical:hover {
       background-color: ]]..blue..[[;
       border-width: 1px;
    }
    QScrollBar::add-line:vertical {
      background-color: #000000;
      height: 1px;
      subcontrol-position: bottom;
      subcontrol-origin: margin;
    }
    QScrollBar::sub-line:vertical {
      background-color: #000000;
      height: 1px;
      subcontrol-position: top;
      subcontrol-origin: margin;
    }
    QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {
      background: none;
    }
    QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
      background: none;
    }
  ]])
end
