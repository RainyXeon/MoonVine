module client

import libs.discord

pub fn (mut h ClientEventHandler) on_debug(log discord.GatewayDebugEvent) {
	h.app.log_debug(log.message)
}
