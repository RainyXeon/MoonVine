module discord

pub struct GuildRoleDeletePayload {
pub:
	guild_id string
	role_id  string
}

pub struct ChannelPinsUpdatePayload {
pub:
	guild_id           ?string
	channel_id         string
	last_pin_timestamp ?string
}

pub struct ChannelUpdatePayload {
pub:
	channel Channel
}

pub struct ChannelDeletePayload {
pub:
	channel Channel
}

pub struct MessageCreatePayload {
pub:
	message Message
}

pub struct MessageUpdatePayload {
pub:
	message Message
}

pub struct ApplicationCommandPermissionsUpdatePayload {
pub:
	application_command_permissions_update ApplicationCommandPermissionsUpdateEvent
}

pub struct AutoModerationActionExecutionPayload {
pub:
	auto_moderation_action_execution AutoModerationActionExecutionEvent
}

pub struct VoiceStateUpdatePayload {
pub:
	voice_state VoiceStateEvent
}

pub struct VoiceServerUpdatePayload {
pub:
	voice_server VoiceServerEvent
}

pub struct PresenceUpdatePayload {
pub:
	presence PresenceUpdateEvent
}

pub struct TypingStartPayload {
pub:
	typing_start TypingStartEvent
}

pub struct InteractionCreatePayload {
pub:
	interaction InteractionCreateEvent
}

pub struct InviteCreatePayload {
pub:
	invite InviteCreateEvent
}

pub struct InviteDeletePayload {
pub:
	invite InviteDeleteEvent
}

pub struct IntegrationCreatePayload {
pub:
	integration IntegrationEvent
}

pub struct IntegrationUpdatePayload {
pub:
	integration IntegrationEvent
}

pub struct IntegrationDeletePayload {
pub:
	integration IntegrationEvent
}

pub struct WebhooksUpdatePayload {
pub:
	webhooks_update WebhooksUpdateEvent
}

pub struct StageInstanceCreatePayload {
pub:
	stage_instance StageInstanceEvent
}

pub struct StageInstanceUpdatePayload {
pub:
	stage_instance StageInstanceEvent
}

pub struct StageInstanceDeletePayload {
pub:
	stage_instance StageInstanceEvent
}

pub struct VoiceChannelEffectSendPayload {
pub:
	voice_channel_effect_send VoiceChannelEffectSendEvent
}
