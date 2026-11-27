module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_disconnect(disconnect discord.GatewayDisconnectEvent) {
	h.app.log_info('Disconnected from Gateway [code: ${disconnect.code}, reason: ${disconnect.reason}]')
}
