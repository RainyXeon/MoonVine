module main

import libs.discord
import configs

pub fn main() {
	config_data := configs.reader() or {
		eprintln('app.yml is missing')
		return
	}

	mut client := discord.new_class_bot_client()
	client
		.intents(discord.GatewayIntent.default_with(.guilds, .guild_messages, .message_content))
		.on_ready(fn (ready discord.ReadyEvent) {
			println('Ready as ${ready.user.username}')
		})
		.on_message_create(fn [mut client] (msg discord.Message) {
			if msg.content == '!ping' {
				client.channels.send_message(msg.channel_id, discord.CreateMessageParams{
					content: 'Pong!'
				}) or {}
			}
		})
		.on_error(fn (err discord.GatewayError) {
			eprintln('[Gateway] ${err}')
		})
		.login(config_data.bot.token)!
}
