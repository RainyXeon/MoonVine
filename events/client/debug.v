module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_debug(log discord.GatewayDebugEvent) {
	h.app.log_debug(log.message)
}
