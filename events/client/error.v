module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_error(err discord.GatewayError) {
	h.moonvine.log.error(err.str())
}
