-- AardwolfMudlet: onName
-- Group: aard > gmcp
-- Events: gmcp.char.base

function onName()
	aard.name = gmcp.char.base.name
	aard.tnlmax = gmcp.char.base.perlevel
	aard.config = aard.config or aard.configDefault or {}
  if io.exists(getMudletHomeDir().."/aardwolf/config-"..gmcp.char.base.name..".lua") then
    table.load(getMudletHomeDir().."/aardwolf/config-"..gmcp.char.base.name..".lua", aard.config)
    for k, v in pairs(aard.configDefault) do
    	if not aard.config[k] then
				--new config parameter, add it to the config with default value
				aard.config[k] = v
				table.save(getMudletHomeDir().."/aardwolf/config-"..gmcp.char.base.name..".lua", aard.config)
			end
    end
	else
		table.save(getMudletHomeDir().."/aardwolf/config-"..gmcp.char.base.name..".lua", aard.config)
  end
end
