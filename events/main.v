module events

import model
import events.client as client_events
import events.guild as guild_events

pub fn register(mut moonvine model.MoonVine) {
	moonvine.log.info("Register [client] events.")
	client_events.register(mut moonvine)
	guild_events.register(mut moonvine)
}
