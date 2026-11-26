module guild

import libs.discord

pub fn (mut h Class_GuildEventHandler) on_message_create(msg discord.Message) {
	if msg.content == '!ping' {
		ws_ping := h.moonvine.client.gateway.ping()
		text := if ws_ping >= 0 {
			'Pong! Gateway latency: ${ws_ping}ms'
		} else {
			'Pong! (awaiting first heartbeat ACK)'
		}
		h.moonvine.client.channels.send_message(msg.channel_id, discord.CreateMessageParams{
			content: text
		}) or {}
	}
}
