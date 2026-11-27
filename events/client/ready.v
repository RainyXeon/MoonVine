module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_ready(ready discord.ReadyEvent) {
	h.app.log_info('Logged in ${ready.user.username}!')
	h.app.client.set_presence(discord.PresenceUpdateParams{
		activities: [
			discord.new_presence_activity('ALPHA | /play', discord.ActivityType.listening),
		]
	}) or {}
}
