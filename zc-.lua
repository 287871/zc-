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


local function GO_SetSize(GO, width, height)
	GO:SetWidth(width)
	GO:SetHeight(height)
end

local function GO_SetPos(GO, width, height)
	GO:SetPosX(width)
	GO:SetPosY(height)
end


local lualoader_tab = gui.Tab(gui.Reference("Settings"), "Chicken.lualoader.tab", "Lua loader")


local readme_gb = gui.Groupbox(lualoader_tab, "README | " .. version, 10, 10, 610, 0)
local redme_text = gui.Text(readme_gb, readme)
http.Get("https://raw.githubusercontent.com/287871/zc-/main/README.md", function(content)
	redme_text:SetText(content)
end)

local filter_gb = gui.Groupbox(lualoader_tab, "Filter options", 10, 145)

local search_entry = gui.Editbox(filter_gb, "Chicken.lualoader.search", "Search")

local show = "all online"
local autorun_btn = gui.Button(filter_gb, "", function()
	show = "autorun"
end)

local online_scripts_btn = gui.Button(filter_gb, "", function()
	show = "all online"
end)

local running_btn = gui.Button(filter_gb, "", function()
	show = "running"
end)

local downloads_btn = gui.Button(filter_gb, "", function()
	show = "downloads"
end)

local custom_btn = gui.Button(filter_gb, "", function()
	show = "external"
end)

GO_SetSize(autorun_btn, 110, 32)
GO_SetSize(online_scripts_btn, 110, 32)
GO_SetSize(running_btn, 110, 32)
GO_SetSize(downloads_btn, 110, 32)
GO_SetSize(custom_btn, 110, 32)

local x = 116
GO_SetPos(autorun_btn, 0, 50)
GO_SetPos(online_scripts_btn, x, 50)
GO_SetPos(running_btn, (x * 2), 50)
GO_SetPos(downloads_btn, (x * 3), 50)
GO_SetPos(custom_btn, (x * 4), 50)

local autorun_btn_text = gui.Text(filter_gb, "自动运行 (0)")
local all_scripts_btn_text = gui.Text(filter_gb, "在线脚本 (0)")
local running_btn_text = gui.Text(filter_gb, "Running (0)")
local downloads_btn_text = gui.Text(filter_gb, "下载 (0)")
local custom_btn_text = gui.Text(filter_gb, "外部下载")
custom_btn:SetDisabled(true)
local x = 110
GO_SetPos(autorun_btn_text, 22, 62)
GO_SetPos(all_scripts_btn_text, 9 + x, 62)
GO_SetPos(running_btn_text, 36 + (x * 2), 62)
GO_SetPos(downloads_btn_text, 36 + (x * 3), 62)
GO_SetPos(custom_btn_text, 26 + (x * 4), 62)



local function add_temp_lua(script_url, id)
	local path = temp_path .. "/" .. id .. ".lua"
	http.Get(script_url, function(content)
		local f = file.Open(path, "w")
		f:Write(content)
		f:Close()
		LoadScript(path)
	end)
end


local function remove_temp_lua(id)
	local path = temp_path .. "/" .. id .. ".lua"
	UnloadScript(path)
	file.Delete(path)
end


local function add_downlaod_lua(script_url, id)
	http.Get(script_url, function(content)
		local f = file.Open(downloads_path .. "/" .. id .. ".lua" , "w")
		f:Write(content)
		f:Close()
	end)
end


local function remove_downloaded_lua(id)
	local path = downloads_path .. "/" .. id .. ".lua"
	file.Delete(path)
end


local function add_to_autorun(id)
	if not match(file.Read(autorun_file), id) then
		local f = file.Open(autorun_file, "a")
		f:Write(id .. ".lua\n")
		f:Close()
	end
end


local function remove_from_autorun(id)
	local new_autorun = RemoveLineFromMultiLine(file.Read(autorun_file), id .. ".lua")
	local f = file.Open(autorun_file, "w")
	f:Write(new_autorun)
	f:Close()
end


local function should_autorun(id)
	return match(file.Read(autorun_file), id) == id
end


local function is_downloaded(id)
	local downloaded = false
	file.Enumerate(function(fname)
		if match(fname, "/") then
			if string.sub(fname, 1, 19) == "lualoader/downloads" then
				if match(fname, id) then
					downloaded = true
					return downloaded
				end	
			end
		end
	end)
	return downloaded
end

local function add_external_download(script_name, script_url, cb)
	local data = script_name .. "," .. script_url

	http.Get(script_url, function(content)
		local f = file.Open(downloads_path .. "/" .. script_name .. ".lua" , "w")
		f:Write(content)
		f:Close()
		
		local f2 = file.Open(external_downloads_file , "a")
		f2:Write(data .. "\n")
		f2:Close()
		cb()
	end)
end

local function remove_external_download(id)
	file.Delete(downloads_path .. "/" .. id .. ".lua")
	
	local new_external_file = RemoveLineFromMultiLine(file.Read(external_downloads_file), id .. ".lua")
	print("ID", id)
	
	
	local f = file.Open(external_downloads_file, "w")
	f:Write(new_external_file)
	f:Close()
end

local function get_external_scripts()
	local contents = file.Read(external_downloads_file)
	local external_downloaded_data = {}
	
	local split_contents = split(contents, "\n")
	
	for _, script_data in pairs(split_contents) do
		local split_data = split(script_data, ",")
		table.insert(external_downloaded_data, {
			script_name = split_data[1],
			script_url = split_data[2]
		})
	end
	return external_downloaded_data
end




local all_scripts = 0
local all_autorun = 0
local running_scripts = 0
local all_downloads = 0	

local script_boxes = {}
local y_pos_counter = 300





local function filter_script_boxes(filter)
	y_pos_counter = 300 -- reset starting y position for script_boxes
	for k, script_box in pairs(script_boxes) do
		if filter(script_box) then
			script_box.GO_objects.header_gb:SetInvisible(false)
			GO_SetPos(script_box.GO_objects.header_gb, 10, y_pos_counter)
			y_pos_counter = y_pos_counter + 90
		else
			script_box.GO_objects.header_gb:SetInvisible(true)
		end
	end
end

local function update_scriptbox_display()
	local search_value = string.lower(search_entry:GetValue())
	filter_script_boxes(function(script_box)
		-- if show == "external" then
			-- custom_gb:SetInvisible(false)
			
		-- else
			-- custom_gb:SetInvisible(true)
		-- end
		
		if show == "all online" then
			return match(lower(script_box.script_name), search_value) or match(lower(script_box.author), search_value)
		elseif show == "autorun" then
			return (match(lower(script_box.script_name), search_value) or match(lower(script_box.author), search_value)) and script_box.autorun
		elseif show == "running" then
			return (match(lower(script_box.script_name), search_value) or match(lower(script_box.author), search_value)) and script_box.running
		elseif show == "downloads" then
			return (match(lower(script_box.script_name), search_value) or match(lower(script_box.author), search_value)) and script_box.downloaded
		end
		
		
	
	end)
end

local action_delay = 0

local function CreateScriptBox(script_name, author, script_url, thread_url, external)
	local script_box = {GO_objects = {}}
	script_box.script_name = script_name
	script_box.author = author
	script_box.script_url = script_url
	script_box.thread_url = thread_url
	script_box.id = get_thread_id(thread_url) or split(thread_url, "/")[1]


	script_box.running = false
	
	script_box.autorun = should_autorun(script_box.id) -- OR, For externally downloaded scripts
	script_box.downloaded = is_downloaded(script_box.id)
	
	
	script_box.downloads_path = downloads_path .. "/" .. script_box.id .. ".lua"
	script_box.temp_path = temp_path .. "/" ..script_box.id .. ".lua"

	-- ui shit

	script_box.GO_objects.header_gb = gui.Groupbox(lualoader_tab, "        " .. script_name, 10, y_pos_counter, 610, 0)
	
	script_box.GO_objects.autorun_cb = gui.Checkbox(script_box.GO_objects.header_gb, "Chicken.lualoader.checkbox", "", false)
	script_box.GO_objects.autorun_cb:SetValue(script_box.autorun)
	script_box.oautorun_cb_v = false

	GO_SetPos(script_box.GO_objects.autorun_cb, 0, -36)
	GO_SetSize(script_box.GO_objects.autorun_cb, 22, 22)
	
	if script_box.downloaded then		
		all_downloads = all_downloads + 1
		downloads_btn_text:SetText("Downloads (" .. all_downloads .. ")")
	end
	
	if external then
		local remove_btn = gui.Button(script_box.GO_objects.header_gb, "Remove", function()
			if globals.CurTime() > action_delay then
				remove_external_download(script_box.id)
				print(1)
				update_scriptbox_display()
				action_delay = globals.CurTime() + 0.3
			end
		end)
		GO_SetPos(remove_btn, 370,-42)
		GO_SetSize(remove_btn, 100, 20)
	else

	end
	
	
	


	local author_text = gui.Text(script_box.GO_objects.header_gb, "Author: " .. author)

	script_box.GO_objects.run_btn = gui.Button(script_box.GO_objects.header_gb, "Run", function()
		LoadScript(script_box.downloads_path)
		script_box.running = true
		running_scripts = running_scripts + 1
		running_btn_text:SetText("Running (" .. running_scripts .. ")")
	end)
	
	
	script_box.GO_objects.temp_run_btn = gui.Button(script_box.GO_objects.header_gb, "Temp run", function() 
		add_temp_lua(script_url, script_box.id)
		
		chicken__last_script_loaded__ = script_name
		script_box.running = true
		running_scripts = running_scripts + 1
		running_btn_text:SetText("Running (" .. running_scripts .. ")")
	end)
	

	script_box.GO_objects.unload_btn = gui.Button(script_box.GO_objects.header_gb, "Unload", function()
		if globals.CurTime() > action_delay then
			UnloadScript(script_box.downloads_path)
			remove_temp_lua(script_box.id)
			script_box.running = false
			running_scripts = running_scripts - 1
			running_btn_text:SetText("Running (" .. running_scripts .. ")")
			
			update_scriptbox_display()
			action_delay = globals.CurTime() + 0.01
		end
	end)
	
	
	script_box.GO_objects.download_btn = gui.Button(script_box.GO_objects.header_gb, "Download", function()
		add_downlaod_lua(script_url, script_box.id)
		script_box.downloaded = true
		all_downloads = all_downloads + 1
		downloads_btn_text:SetText("Downloads (" .. all_downloads .. ")")
	end)
	
	script_box.GO_objects.uninstall_btn = gui.Button(script_box.GO_objects.header_gb, "Uninstall", function()
		if globals.CurTime() > action_delay then
			action_delay = globals.CurTime() + 0.01
			remove_downloaded_lua(script_box.id)			
			script_box.downloaded = false			
			all_downloads = all_downloads - 1
			downloads_btn_text:SetText("Downloads (" .. all_downloads .. ")")
			if script_box.autorun then
				remove_from_autorun(script_box.id)			
				script_box.GO_objects.autorun_cb:SetValue(false)
			end
			update_scriptbox_display()
		end
	end)
	
	
	GO_SetSize(script_box.GO_objects.temp_run_btn, 220, 25); GO_SetSize(script_box.GO_objects.unload_btn, 220, 25); GO_SetSize(script_box.GO_objects.run_btn, 220, 25)
	GO_SetSize(script_box.GO_objects.download_btn, 220, 25); GO_SetSize(script_box.GO_objects.uninstall_btn, 220, 25)
	
	GO_SetPos(script_box.GO_objects.temp_run_btn, 130, -7); GO_SetPos(script_box.GO_objects.unload_btn, 130, -7); GO_SetPos(script_box.GO_objects.run_btn, 130, -7)
	GO_SetPos(script_box.GO_objects.download_btn, 360, -7); GO_SetPos(script_box.GO_objects.uninstall_btn, 360, -7)
		
	y_pos_counter = y_pos_counter + 90
	if script_box.autorun then
		LoadScript(script_box.downloads_path)
		script_box.running = true
		
		running_scripts = running_scripts + 1
		running_btn_text:SetText("Running (" .. running_scripts .. ")")
	end

	all_scripts = all_scripts + 1
	all_scripts_btn_text:SetText("Online scripts (" .. all_scripts .. ")")
	
	table.insert(script_boxes, script_box)
	
	return script_box
end



local external_scripts = get_external_scripts()

for k, external_script in pairs(external_scripts) do
	CreateScriptBox(external_script.script_name, "N/A", external_script.script_url, "/" .. external_script.script_name, true)
	-- all_autorun = all_autorun + 1
	-- autorun_btn_text:SetText("Autorun (" .. all_autorun .. ")")
end



http.Get("https://raw.githubusercontent.com/287871/zc-/main/luas.txt", function(content)
	local luas = split(content, "\n")
	for k, lua in pairs(luas) do
		local lua_data = split(lua, ",")
		local lua_thread_link = lua_data[1]
		local lua_author = lua_data[2]
		local lua_name = lua_data[3]
		local lua_url = lua_data[4]
		
		CreateScriptBox(lua_author, lua_name, lua_url, lua_thread_link)
	end
end)


local oSearchValue = ""
local oShow = "all"



callbacks.Register("Draw", "Chicken.lualoader.UI", function()
	local search_value = string.lower(search_entry:GetValue())
	if search_value ~= oSearchValue or oShow ~= show  then
		update_scriptbox_display()
		oSearchValue = search_value
		oShow = show
	end
	
	for k, script_box in pairs(script_boxes) do
		script_box.GO_objects.run_btn:SetInvisible(script_box.running or not script_box.downloaded)
		
		script_box.GO_objects.temp_run_btn:SetInvisible(script_box.running or script_box.downloaded)
		script_box.GO_objects.unload_btn:SetInvisible(not script_box.running)
		
		script_box.GO_objects.download_btn:SetInvisible(script_box.downloaded)
		script_box.GO_objects.uninstall_btn:SetInvisible(not script_box.downloaded)
		
		
		script_box.GO_objects.autorun_cb:SetDisabled(not script_box.downloaded)
		

		if script_box.GO_objects.autorun_cb:GetValue() ~= script_box.oautorun_cb_v then
			
			if script_box.GO_objects.autorun_cb:GetValue() then
				add_to_autorun(script_box.id)
				script_box.autorun = true
				all_autorun = all_autorun + 1
				print("Setting autorun")
				autorun_btn_text:SetText("Autorun (" .. all_autorun .. ")")
			else
				remove_from_autorun(script_box.id)
				script_box.autorun = false
				all_autorun = all_autorun - 1
				autorun_btn_text:SetText("Autorun (" .. all_autorun .. ")")
			end
			update_scriptbox_display()
			script_box.oautorun_cb_v = script_box.GO_objects.autorun_cb:GetValue()
		end
	end
end)


local unload_all_btn = gui.Button(lualoader_tab, "全部卸载", function()
	for k, script_box in pairs(script_boxes) do
		if script_box.running then
			UnloadScript(script_box.temp_path)
			UnloadScript(script_box.downloads_path)
			script_box.running = false
			running_scripts = running_scripts - 1
		end
		running_btn_text:SetText("Running (" .. running_scripts .. ")")
	end
	ClearTempLuas()
end)

GO_SetPos(unload_all_btn, 545, 21)
GO_SetSize(unload_all_btn, 65, 15)

callbacks.Register("Unload", "Chicken.lualoader.unloadluas", function()
	for k, script_box in pairs(script_boxes) do
		if script_box.running then
			UnloadScript(script_box.temp_path)
			UnloadScript(script_box.downloads_path)
			running_scripts = running_scripts - 1
		end
		running_btn_text:SetText("Running (" .. running_scripts .. ")")
	end
	ClearTempLuas()
end)
