module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_reconnect(reconnect discord.GatewayReconnectEvent) {
	h.moonvine.log.info('Reconnect from Gateway [attempt: ${reconnect.attempt}, session_id: ${reconnect.session_id}]')
}
