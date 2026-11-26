module guild

import model

pub struct Class_GuildEventHandler {
pub mut:
	moonvine &model.MoonVine
}

pub fn register(mut moonvine model.MoonVine) {
	mut handler := &Class_GuildEventHandler{
		moonvine: moonvine
	}

	moonvine.client.on_message_create(handler.on_message_create)
}
