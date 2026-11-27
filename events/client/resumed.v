module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_resumed(resumed discord.ResumedEvent) {
	h.app.log_info('Resumed from Gateway [trace: ${resumed.trace.str()}]')
}
