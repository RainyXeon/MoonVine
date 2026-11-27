module guild

import context

pub struct Class_GuildEventHandler {
pub mut:
	app &context.App
}

pub fn register(mut app context.App) {
	mut handler := &Class_GuildEventHandler{
		app: app
	}

	app.client.on_message_create(handler.on_message_create)
}
