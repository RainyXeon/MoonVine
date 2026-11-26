module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_debug(log discord.GatewayDebugEvent) {
	h.moonvine.log.debug(log.message)
}
