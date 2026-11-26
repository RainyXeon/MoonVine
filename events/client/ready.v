module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_ready(ready discord.ReadyEvent) {
	h.moonvine.log.info('Logged in ${ready.user.username}!')
	h.moonvine.client.set_presence(discord.PresenceUpdateParams{
		activities: [
			discord.new_presence_activity('ALPHA | /play', discord.ActivityType.listening),
		]
	}) or { }
}
