module client

import libs.discord

pub fn (mut h ClientEventHandler) on_reconnect(reconnect discord.GatewayReconnectEvent) {
	h.app.log_info('Reconnect from Gateway [attempt: ${reconnect.attempt}, session_id: ${reconnect.session_id}]')
}
