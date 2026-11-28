module info

import context
import libs.discord

pub fn new_info_ping_command() (string, context.Command) {
	mut command := context.Command{
		name: ["ping"]
		description: 'Shows the ping information of the Bot'
		category: 'info'
		accessableby: context.AccessableBy.member
		usage: ''
		aliases: []
		audio: false
		player_check: false
		using_interaction: false
		same_voice_check: false
	}
	command.execute = execute
	return command.name.join("-"), command
}

pub fn execute(mut app context.App, mut invocation context.CommandInvocation) !bool {
	invocation.defer_reply() or { return err }
	ws_ping := app.client.gateway.ping()

	text := if ws_ping >= 0 {
		'${ws_ping}'
	} else {
		'(awaiting first heartbeat ACK)'
	}

	user := app.client.users.me.fetch() or {
		app.log_error(err.str())
		return err
	}

	invocation.edit_reply(discord.EditMessageParams{
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
		return err
	}
	return true
}