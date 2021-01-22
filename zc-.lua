local version = "版本 1.0"
local version_url = "https://raw.githubusercontent.com/287871/zc-/main/ZC-VERSION.txt"

-- pasted functions
local function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end
-- end of paste


local match = string.match

-- Update
http.Get(version_url, function(content)
	if version == string.gsub(content, "[\r\n]", "") then
		print("[LuaLoader] 最新版本")
	else
        local new_version = http.Get("https://raw.githubusercontent.com/287871/zc-/main/zc-.lua");
        local old = file.Open(GetScriptName(), "w")
        old:Write(new_version)
        old:Close()
		
		print("[LuaLoader] 请更新")
		UnloadScript(GetScriptName())
	end
end)


