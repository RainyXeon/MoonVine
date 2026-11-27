module guild

import libs.discord

pub fn (mut h Class_GuildEventHandler) on_message_create(msg discord.Message) {
	if msg.content == '!ping' {
		ws_ping := h.app.client.gateway.ping()

		text := if ws_ping >= 0 {
			'${ws_ping}'
		} else {
			'(awaiting first heartbeat ACK)'
		}

		user := h.app.client.users.me.fetch() or {
			h.app.log_error(err.str())
			return
		}

		msg.send(discord.CreateMessageParams{
			content: ''
			embeds:  [
				discord.Embed{
					author:      discord.EmbedAuthor{
						name: '🏓 ' + user.username
					}
					description: '**Ping:** `${text}ms`'
				},
			]
		}) or {
			h.app.log_error(err.str())
			return
		}
	}
}
