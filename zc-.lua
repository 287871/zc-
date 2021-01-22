local version = "版本 1.0"
local version_url = "https://raw.githubusercontent.com/287871/zc-/main/ZC-VERSION.txt"

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


