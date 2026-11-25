module discord

pub enum GatewayIntent as u32 {
	guilds                        = 1 << 0
	guild_members                 = 1 << 1 // Privileged
	guild_moderation              = 1 << 2
	guild_expressions             = 1 << 3
	guild_integrations            = 1 << 4
	guild_webhooks                = 1 << 5
	guild_invites                 = 1 << 6
	guild_voice_states            = 1 << 7
	guild_presences               = 1 << 8 // Privileged
	guild_messages                = 1 << 9
	guild_message_reactions       = 1 << 10
	guild_message_typing          = 1 << 11
	direct_messages               = 1 << 12
	direct_message_reactions      = 1 << 13
	direct_message_typing         = 1 << 14
	message_content               = 1 << 15 // Privileged
	guild_scheduled_events        = 1 << 16
	auto_moderation_configuration = 1 << 20
	auto_moderation_execution     = 1 << 21
	guild_message_polls           = 1 << 24
	direct_message_polls          = 1 << 25
}

// Helper methods for combining and checking intents
pub fn GatewayIntent.all() u32 {
	return u32(GatewayIntent.guilds) | u32(GatewayIntent.guild_members) | u32(GatewayIntent.guild_moderation) | u32(GatewayIntent.guild_expressions) | u32(GatewayIntent.guild_integrations) | u32(GatewayIntent.guild_webhooks) | u32(GatewayIntent.guild_invites) | u32(GatewayIntent.guild_voice_states) | u32(GatewayIntent.guild_presences) | u32(GatewayIntent.guild_messages) | u32(GatewayIntent.guild_message_reactions) | u32(GatewayIntent.guild_message_typing) | u32(GatewayIntent.direct_messages) | u32(GatewayIntent.direct_message_reactions) | u32(GatewayIntent.direct_message_typing) | u32(GatewayIntent.message_content) | u32(GatewayIntent.guild_scheduled_events) | u32(GatewayIntent.auto_moderation_configuration) | u32(GatewayIntent.auto_moderation_execution) | u32(GatewayIntent.guild_message_polls) | u32(GatewayIntent.direct_message_polls)
}

pub fn GatewayIntent.default_non_privileged() u32 {
	return GatewayIntent.all() & ~(u32(GatewayIntent.guild_members) | u32(GatewayIntent.guild_presences) | u32(GatewayIntent.message_content))
}

pub fn intents_from(intents ...GatewayIntent) u32 {
	mut mask := u32(0)
	for intent in intents {
		mask |= u32(intent)
	}
	return mask
}

// Merge any combination of u32 intent bitmasks (e.g. default_non_privileged() | intents_from(...))
pub fn merge_intents(masks ...u32) u32 {
	mut combined := u32(0)
	for mask in masks {
		combined |= mask
	}
	return combined
}

// Convenience helper: start from default_non_privileged() and add extra intents (like .message_content)
pub fn GatewayIntent.default_with(extra ...GatewayIntent) u32 {
	return GatewayIntent.default_non_privileged() | intents_from(...extra)
}

// Remove specific intents from an existing bitmask
pub fn without_intents(base u32, remove ...GatewayIntent) u32 {
	return base & ~intents_from(...remove)
}
