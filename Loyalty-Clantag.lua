local a = ui.new_checkbox("LUA", "B", "Loyalty Clantag")

local c = {
	"[]",
	"[L]",
	"[Lo]",
	"[Loy]",
	"[Loya]",
	"[Loyal]",
	"[Loyalt]",
	"[Loyalty]",
	"[Loyalty.]",
	"[Loyalty.l]",
    "[Loyalty.lu]",
    "[Loyalty.lua]",
    "[Loyalty.lua]",
    "[Loyalty.lua]",
    "[Loyalty.lua]",
    "[Loyalty.lua]",
    "[Loyalty.lua]",
    "[Loyalty.lu]",
    "[Loyalty.l]",
    "[Loyalty.]",
    "[Loyalty]",
    "[Loyalt]",
    "[Loyal]",
    "[Loya]",
    "[Loy",
    "[Lo]",
    "[L]",
    "[]"
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
    
    if ui.get(a) then
        if b ~= i then
            client.set_clan_tag(i)
            b = i
        end
    end

    if not ui.get(a) then
        client.set_clan_tag()
    end
end
client.set_event_callback("paint", e)
