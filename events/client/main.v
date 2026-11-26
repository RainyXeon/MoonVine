module client

import model

pub struct Class_ClientEventHandler {
pub mut:
	moonvine &model.MoonVine
}

pub fn register(mut moonvine model.MoonVine) {
	mut handler := &Class_ClientEventHandler{
		moonvine: moonvine
	}

	moonvine.client.on_error(handler.on_error)
	moonvine.client.on_debug(handler.on_debug)
	moonvine.client.on_disconnect(handler.on_disconnect)
	moonvine.client.on_rate_limited(handler.on_rate_limited)
	moonvine.client.on_ready(handler.on_ready)
	moonvine.client.on_reconnect(handler.on_reconnect)
	moonvine.client.on_resumed(handler.on_resumed)
}
