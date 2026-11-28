module guild

import libs.discord

pub fn (mut h GuildEventHandler) on_interaction_create(interaction discord.InteractionCreateEvent) {
	command_name := (interaction.full_command_name('-') or { 'unknown' })

	h.app.log_info('Command executed: ' + command_name)

	interaction.defer_reply(true) or {
		h.app.log_error(err.str())
		return
	}

	if command_name == 'ping' {
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

		interaction.edit_reply(discord.EditMessageParams{
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

		return
	}

	interaction.edit_reply('Hello world!') or {
		h.app.log_error(err.str())
		return
	}
}
