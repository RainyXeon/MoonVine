module client

import libs.discord

pub fn (mut h ClientEventHandler) on_error(err discord.GatewayError) {
	h.app.log_error(err.str())
}
