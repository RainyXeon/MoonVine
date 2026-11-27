module client

import context

pub struct Class_ClientEventHandler {
pub mut:
	app &context.App
}

pub fn register(mut app context.App) {
	mut handler := &Class_ClientEventHandler{
		app: app
	}

	app.client.on_error(handler.on_error)
	app.client.on_debug(handler.on_debug)
	app.client.on_disconnect(handler.on_disconnect)
	app.client.on_rate_limited(handler.on_rate_limited)
	app.client.on_ready(handler.on_ready)
	app.client.on_reconnect(handler.on_reconnect)
	app.client.on_resumed(handler.on_resumed)
}
