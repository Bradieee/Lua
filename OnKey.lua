-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_screen_size, entity_get_local_player, entity_get_prop, entity_is_alive, globals_curtime, math_abs, math_floor, renderer_indicator, renderer_rectangle, renderer_text, string_format, ui_get, ui_new_combobox, ui_reference, ui_set_callback = client.screen_size, entity.get_local_player, entity.get_prop, entity.is_alive, globals.curtime, math.abs, math.floor, renderer.indicator, renderer.rectangle, renderer.text, string.format, ui.get, ui.new_combobox, ui.reference, ui.set_callback
local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall
local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_classname
local local_player = entity.get_local_player()

local ffi = require('ffi')
local ffi_cast = ffi.cast

local js = panorama.open()
local persona_api = js.MyPersonaAPI
local name = persona_api.GetName()

local nickname = name
local ctag = 'OnKey.lua'


--Menu
local lua_name = ui.new_label("LUA", "B", "OnKey.lua")
local color_picker = ui.new_color_picker('LUA', 'B', 'OnKey Watermark color picker', 89, 119, 239, 255)
local Label1 = ui.new_label("LUA", "B", "====================")
local Shoot = ui.new_hotkey("LUA", "B", "RageBot")
local Autowall = ui.new_hotkey("LUA", "B", "Awall")
local enable_awall_fov = ui.new_checkbox("LUA", "B", "Enable AutoWall FOV")
local Awall_Fov = ui.new_slider("LUA", "B", "AutoWall FOV", 0, 180, 30, true, "°")
local Fov_restore = ui.new_slider("LUA", "B", "Default FOV", 0, 180, 5, true, "°")
local AntiAim = ui.new_hotkey("LUA", "B", "AA")
local FakeLag = ui.new_hotkey("LUA", "B", "FL")
local override_checkbox = ui.new_hotkey("LUA", "B", "Anti-aim correction Override")
local Enable_clantag = ui.new_checkbox("LUA", "B", "Clantag")
local Label1 = ui.new_label("LUA", "B", "====================")

--References
--Ragebot_ref
local ragebot = { ui.reference("RAGE", "Aimbot", "Enabled") }
local autoshoot = ui.reference("RAGE", "Other", "Automatic Fire")
local awall = ui.reference("RAGE", "Other", "Automatic penetration")
local fov = ui.reference("RAGE", "Other", "Maximum FOV")

--AA_ref
local AA = ui.reference("AA", "Anti-Aimbot Angles", "Enabled")
local Pitch = ui.reference("AA", "Anti-Aimbot Angles", "Pitch")
local Yaw_base = ui.reference("AA", "Anti-Aimbot Angles", "Yaw base")
local Yaw = ui.reference("AA", "Anti-Aimbot Angles", "Yaw")
local Body_yaw = ui.reference("AA", "Anti-Aimbot Angles", "Body yaw")

--Fakelag_ref
local FL = ui.reference("AA", "Fake Lag", "Enabled")
local FL_limit = ui.reference("AA", "Fake Lag", "Limit")

local resolver = ui.reference("RAGE", "OTHER", "Anti-aim correction")



--Console
client.exec "clear"
client_color_log(255, 255, 255, "====================")
client_color_log(0, 150, 255, 	"Welcome to OnKey.lua, ", name)
client_color_log(255, 255, 255, "The settings is on LUA - B")
client_color_log(255, 255, 255, "====================")
client_color_log()
client.exec("play UI/competitive_accept_beep.wav")


--Watermark (Obv pasted)

-- Things
local interface_ptr = ffi.typeof('void***')
local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')

local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
local ivengineclient = ffi.cast(interface_ptr, rawivengineclient) or error('rawivengineclient is nil', 2)

local get_net_channel_info = ffi.cast('void*(__thiscall*)(void*)', ivengineclient[0][78]) or error('ivengineclient is nil')
local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')

local notes = (function(b)local c=function(d,e)local f={}for g in pairs(d)do table.insert(f,g)end;table.sort(f,e)local h=0;local i=function()h=h+1;if f[h]==nil then return nil else return f[h],d[f[h]]end end;return i end;local j={get=function(k)local l,m=0,{}for n,o in c(package.cnotes)do if o==true then l=l+1;m[#m+1]={n,l}end end;for p=1,#m do if m[p][1]==b then return k(m[p][2]-1)end end end,set_state=function(q)package.cnotes[b]=q;table.sort(package.cnotes)end,unset=function()client.unset_event_callback('shutdown',callback)end}client.set_event_callback('shutdown',function()if package.cnotes[b]~=nil then package.cnotes[b]=nil end end)if package.cnotes==nil then package.cnotes={}end;return j end)('a_watermark')

-- Local vars
local ui_get = ui.get
local string_format = string.format
local client_screen_size = client.screen_size
local client_system_time = client.system_time
local globals_tickinterval = globals.tickinterval
local renderer_measure_text = renderer.measure_text
local renderer_rectangle = renderer.rectangle
local renderer_text = renderer.text

local paint_handler = function()
    notes.set_state(true)
    notes.get(function(id)
        local sys_time = { client_system_time() }
        local actual_time = string_format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])

        local text = string_format('%s | %s | %s', ctag, nickname, actual_time)

        if is_in_game(is_in_game) == true then
            local INetChannelInfo = ffi.cast(interface_ptr, get_net_channel_info(ivengineclient)) or error('netchaninfo is nil')
            local get_avg_latency = ffi.cast(latency_ptr, INetChannelInfo[0][10])
            local latency = get_avg_latency(INetChannelInfo, 0) * 1000
            local tick = 1/globals_tickinterval()

            text = string_format('%s | %s | delay: %dms | %dtick | %s', ctag, nickname, latency, tick, actual_time)
        end

        local r, g, b, a = ui_get(color_picker)
        local h, w = 18, renderer_measure_text(nil, text) + 8
        local x, y = client_screen_size(), 10 + (25*id)

        x = x - w - 10

        renderer_rectangle(x, y, w, 2, r, g, b, 255)
        renderer_rectangle(x, y + 2, w, h, 17, 17, 17, a)
        renderer_text(x+4, y + 4, 255, 255, 255, 255, '', 0, text)
    end)
end

client.set_event_callback('paint_ui', paint_handler)



--Functions
client.set_event_callback('run_command', function()
    --RageBot    
    if (ui.get(Shoot)) == true then
        ui.set(ragebot[1], true)
        ui.set(ragebot[2], "Always On")
    else
        ui.set(ragebot[1], false)
        ui.set(ragebot[2], "On hotkey")
    end

    --AutoWall
    if ui.get(Autowall) then
        ui.set(awall, true)
    else
        ui.set(awall, false)
    end

    --AutoWall FOV
    if ui.get(Autowall) and ui.get(enable_awall_fov) then
        ui.set(fov, ui.get(Awall_Fov))
    else
        ui.set(fov, ui.get(Fov_restore))
    end
    
        --AA
        if ui.get(AntiAim) then
            ui.set(AA, true)
            client.delay_call(0.5, function() -- Introduce a delay of 0.5 seconds before executing the next part
                ui.set(Pitch, "Off")
                ui.set(Yaw_base, "Local view")
                ui.set(Yaw, "Off")
                ui.set(Body_yaw, "Opposite")
            end)
        else
            ui.set(AA, false)
            ui.set(Pitch, "Off")
            ui.set(Yaw_base, "Local view")
            ui.set(Yaw, "Off")
            ui.set(Body_yaw, "Off")
        end
    
        --FL
        if ui.get(FakeLag) then
            ui.set(FL, true)
        else
            ui.set(FL, false)
        end
    end)
-- Resolver Override
local original_state = false

local function DrawOverrideIndicator()
    if ui.get(override_checkbox) then
        renderer.indicator(255, 255, 255, 255, "Override")
    end
end

client.set_event_callback('run_command', function()
    local state = ui.get(resolver)

    if ui.get(override_checkbox) == true then
        if not original_state then
            original_state = state  -- Store the original state before disabling.
        end
        ui.set(resolver, false)  -- Disable the "Anti-aim correction" option.
    else
        if original_state then
            ui.set(resolver, original_state)  -- Restore the "Anti-aim correction" option to its original state.
            original_state = false  -- Reset the original state flag after restoring.
        end
    end
end)

client.set_event_callback('paint', function()
    DrawOverrideIndicator()
end)

-- client.set_event_callback("paint_ui", function()
--     local x, y = client.screen_size()
--     renderer.text(x/2+880, y/2-50, 255, 255, 255, 255, "", nil, "OnKey.lua")
--     end)


local function indicator()
    --RageBot    
    if (ui.get(Shoot)) == true then
        renderer_indicator(255, 255, 255, 255, "RageBot")
    end
    --Awall   
    if (ui.get(Autowall)) == true then
        renderer_indicator(255, 51, 51, 255, "Awall")
    end
    --FOV
    renderer_indicator(175, 255, 0, 255, "FOV: ", ui.get(fov), "°")

        --AA
    if (ui.get(AntiAim)) == true then
        renderer_indicator(255, 255, 255, 255, "AA")
    end
        --FL
    if (ui.get(FakeLag)) == true then
        renderer_indicator(255, 255, 255, 255, "FL")
    end
end

client.set_event_callback("paint", indicator)

--Clantag


local c = {
	"",
	"O",
	"On",
	"OnK",
	"OnKe",
	"OnKey",
	"OnKey.",
	"OnKey.l",
	"OnKey.lu",
	"OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lua",
    "OnKey.lu",
    "OnKey.l",
    "OnKey.",
    "OnKe",
    "OnK",
    "On",
    "O",
	""
}


local b = ""

local function d(time)
    return math.floor(time / globals.tickinterval() + 0.5)
end

local function e()
    local tickinterval = globals.tickinterval()
    local tickcount = globals.tickcount() + d(client.latency())
    local i = tickcount / d(0.3)
    i = math.floor(i % #c)
    i = c[i+1]
    
    if ui.get(Enable_clantag) then
        if b ~= i then
            client.set_clan_tag(i)
            b = i
        end
    end

    if not ui.get(Enable_clantag) then
        client.set_clan_tag()
    end
end
client.set_event_callback("paint", e)
