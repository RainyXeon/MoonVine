module events

import context
import events.client as client_events
import events.guild as guild_events

pub fn register(mut app context.App) {
	app.log_info("[Event Register] Starting to register events...")
	client_events.register(mut app)
	guild_events.register(mut app)
	app.log_info("[Event Register] Finished register events!")
}
