module guild

import context

pub struct GuildEventHandler {
pub mut:
	app &context.App
}

pub fn register(mut app context.App) {
	mut handler := &GuildEventHandler{
		app: app
	}

	app.client.on_message_create(handler.on_message_create)
	app.client.on_interaction_create(handler.on_interaction_create)
}
