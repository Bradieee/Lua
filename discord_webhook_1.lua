-- Libraries
local Discord = require('gamesense/discord_webhooks')

-- Variables
local Webhook = Discord.new('https://ptb.discord.com/api/webhooks/867034223578841128/mR0qSTZhPOf3sZ-UeB1DtST7ArEEjqORUVcQugRJsqlUPuR2kmEEtW6w3NmNUVKOarJ4')
local RichEmbed = Discord.newEmbed()

-- Get Time
local client_system_time
local sys_time = { client.system_time() }
local actual_time = string.format('%02d:%02d:%02d', sys_time[1], sys_time[2], sys_time[3])

--Get Steam username
local name = entity.get_player_name(1)

-- Properties
Webhook:setUsername('LUA NAME')
Webhook:setAvatarURL('')

RichEmbed:setTitle('Script Name')
RichEmbed:setDescription('User has loaded your script')
RichEmbed:setThumbnail('')
RichEmbed:setColor(7447295)
RichEmbed:addField('Time', actual_time, true)
RichEmbed:addField('User', name, true)

-- Send it!
Webhook:send(RichEmbed)