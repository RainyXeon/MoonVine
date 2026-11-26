module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_resumed(resumed discord.ResumedEvent) {
	h.moonvine.log.info('Resumed from Gateway [trace: ${resumed.trace.str()}]')
}
