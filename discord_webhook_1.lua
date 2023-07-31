--Made by LosAngeles originally

-- Libraries
local Discord = require('gamesense/discord_webhooks')

-- Variables
local Webhook = Discord.new('')
local RichEmbed = Discord.newEmbed()

-- Get Time (added by me)
local client_system_time
local sys_time = { client.system_time() }
local actual_time = string.format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])

--Get Steam username (added by me)
local persona_api = js.MyPersonaAPI
local name = persona_api.GetName()

--Get steamID3 (added by me)
local steam = entity.get_steam64(1)

-- Properties
Webhook:setUsername('')
Webhook:setAvatarURL('')

RichEmbed:setTitle('Title')
RichEmbed:setDescription('Description')
RichEmbed:setThumbnail('')
RichEmbed:setColor(7447295)
RichEmbed:addField('Time', actual_time, true)
RichEmbed:addField('User', name, true)
RichEmbed:addField('SteamID3', steam, true)

-- Send it!
Webhook:send(RichEmbed)
