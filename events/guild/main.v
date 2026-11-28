module guild

import context

pub struct GuildEventHandler {
pub mut:
	app &context.App
}

const command_prefix = "!"

pub fn register(mut app context.App) {
	app.log_info('[Event Register] Register [guild] events.')
	mut handler := &GuildEventHandler{
		app: app
	}

	app.client.on_message_create(handler.on_message_create)
	app.client.on_interaction_create(handler.on_interaction_create)
}
