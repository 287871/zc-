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
local lower = string.lower

function get_thread_id(thread_link) -- gets uid for Aimware threads urls
	return split(thread_link, "/")[5]
end

chicken__last_script_loaded__ = '' 

local function pprint(...)
	print("[LuaLoader]", chicken__last_script_loaded__, ...)
end

-- Update
http.Get(version_url, function(content)
	if version == string.gsub(content, "[\r\n]", "") then
		print("[LuaLoader] is up to date")
	else
        local new_version = http.Get("https://raw.githubusercontent.com/287871/zc-/main/zc-.lua");
        local old = file.Open(GetScriptName(), "w")
        old:Write(new_version)
        old:Close()
		
		print("[LuaLoader] updated")
		UnloadScript(GetScriptName())
	end
end)

local function RemoveLineFromMultiLine(MultiLine, LineToRemove)
	return string.gsub(MultiLine, LineToRemove .. "\n", "")
end

oReference = oReference or gui.Reference -- For printing out references to the Aimware console that other scripts use, makes it easier to find where the scripts are located in the aimware ui
function gui.Reference(...)
	pprint(...)
	return oReference(...)
end

local function lualoaderFolderExists()
	local exists = false
	file.Enumerate(function(fname)
		if match(fname, "/") then
			if string.sub(fname, 1, 9) == "lualoader" then
				exists = true
			end
		end
	end)
	return exists
end

local function ClearTempLuas()
	file.Enumerate(function(fname)
		if string.sub(fname, 1, 15) == "lualoader/temp/" then
			file.Delete(fname)
		end
	end)
end

local temp_path = "lualoader/temp"
local downloads_path = "lualoader/downloads"
local autorun_file = "lualoader/autorun.txt"
local external_downloads_file = "lualoader/external_downloads.txt"


if not lualoaderFolderExists() then
	local path = temp_path .. "/temp.txt"
	file.Open(path, "w"):Close()
	file.Delete(path)
	
	path = downloads_path .. "/temp.txt"
	file.Open(path, "w"):Close()
	file.Delete(path)
	
	file.Open(autorun_file, "w"):Close()
	file.Open(external_downloads_file, "w"):Close()
	
	
end
ClearTempLuas()
file.Open(external_downloads_file, "w"):Close()





local lualoader_tab = gui.Tab(gui.Reference("Settings"), "Chicken.lualoader.tab", "Lua loader")


local readme_gb = gui.Groupbox(lualoader_tab, "README | " .. version, 10, 10, 610, 0)
local redme_text = gui.Text(readme_gb, readme)
http.Get("https://raw.githubusercontent.com/287871/zc-/main/README.md", function(content)
	redme_text:SetText(content)
end)
