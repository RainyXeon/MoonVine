module discord

pub fn (mut this Class_BotClient) on_ready(handler fn (ReadyEvent)) &Class_BotClient {
	this.events.on_ready = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_create(handler fn (Message)) &Class_BotClient {
	this.events.on_message_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_interaction_create(handler fn (InteractionCreateEvent)) &Class_BotClient {
	this.events.on_interaction_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_error(handler GatewayErrorHandler) &Class_BotClient {
	this.events.on_error = handler
	return this
}

pub fn (mut this Class_BotClient) on_resumed(handler fn (ResumedEvent)) &Class_BotClient {
	this.events.on_resumed = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_update(handler fn (Message)) &Class_BotClient {
	this.events.on_message_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_delete(handler fn (MessageDeleteEvent)) &Class_BotClient {
	this.events.on_message_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_delete_bulk(handler fn (MessageDeleteBulkEvent)) &Class_BotClient {
	this.events.on_message_delete_bulk = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_reaction_add(handler fn (MessageReactionEvent)) &Class_BotClient {
	this.events.on_message_reaction_add = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_reaction_remove(handler fn (MessageReactionRemoveEvent)) &Class_BotClient {
	this.events.on_message_reaction_remove = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_create(handler fn (GuildCreateEvent)) &Class_BotClient {
	this.events.on_guild_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_update(handler fn (GuildCreateEvent)) &Class_BotClient {
	this.events.on_guild_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_delete(handler fn (GuildDeleteEvent)) &Class_BotClient {
	this.events.on_guild_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_member_add(handler fn (GuildMemberAddEvent)) &Class_BotClient {
	this.events.on_guild_member_add = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_member_update(handler fn (GuildMemberUpdateEvent)) &Class_BotClient {
	this.events.on_guild_member_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_member_remove(handler fn (GuildMemberRemoveEvent)) &Class_BotClient {
	this.events.on_guild_member_remove = handler
	return this
}

pub fn (mut this Class_BotClient) on_voice_state_update(handler fn (VoiceStateEvent)) &Class_BotClient {
	this.events.on_voice_state_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_voice_server_update(handler fn (VoiceServerEvent)) &Class_BotClient {
	this.events.on_voice_server_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_presence_update(handler fn (PresenceUpdateEvent)) &Class_BotClient {
	this.events.on_presence_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_typing_start(handler fn (TypingStartEvent)) &Class_BotClient {
	this.events.on_typing_start = handler
	return this
}

pub fn (mut this Class_BotClient) on_raw_dispatch(handler GatewayDispatchHandler) &Class_BotClient {
	this.events.on_raw_dispatch = handler
	return this
}

pub fn (mut this Class_BotClient) on_rate_limited(handler fn (RateLimitedEvent)) &Class_BotClient {
	this.events.on_rate_limited = handler
	return this
}

pub fn (mut this Class_BotClient) on_application_command_permissions_update(handler fn (ApplicationCommandPermissionsUpdateEvent)) &Class_BotClient {
	this.events.on_application_command_permissions_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_auto_moderation_rule_create(handler fn (AutoModerationRule)) &Class_BotClient {
	this.events.on_auto_moderation_rule_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_auto_moderation_rule_update(handler fn (AutoModerationRule)) &Class_BotClient {
	this.events.on_auto_moderation_rule_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_auto_moderation_rule_delete(handler fn (AutoModerationRule)) &Class_BotClient {
	this.events.on_auto_moderation_rule_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_auto_moderation_action_execution(handler fn (AutoModerationActionExecutionEvent)) &Class_BotClient {
	this.events.on_auto_moderation_action_execution = handler
	return this
}

pub fn (mut this Class_BotClient) on_channel_create(handler fn (Channel)) &Class_BotClient {
	this.events.on_channel_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_channel_update(handler fn (Channel)) &Class_BotClient {
	this.events.on_channel_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_channel_delete(handler fn (Channel)) &Class_BotClient {
	this.events.on_channel_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_channel_info(handler fn (ChannelInfoEvent)) &Class_BotClient {
	this.events.on_channel_info = handler
	return this
}

pub fn (mut this Class_BotClient) on_channel_pins_update(handler fn (ChannelPinsUpdateEvent)) &Class_BotClient {
	this.events.on_channel_pins_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_thread_create(handler fn (ThreadCreateEvent)) &Class_BotClient {
	this.events.on_thread_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_thread_update(handler fn (ThreadUpdateEvent)) &Class_BotClient {
	this.events.on_thread_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_thread_delete(handler fn (ThreadDeleteEvent)) &Class_BotClient {
	this.events.on_thread_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_thread_list_sync(handler fn (ThreadListSyncEvent)) &Class_BotClient {
	this.events.on_thread_list_sync = handler
	return this
}

pub fn (mut this Class_BotClient) on_thread_member_update(handler fn (ThreadMemberUpdateEvent)) &Class_BotClient {
	this.events.on_thread_member_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_thread_members_update(handler fn (ThreadMembersUpdateEvent)) &Class_BotClient {
	this.events.on_thread_members_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_entitlement_create(handler fn (Entitlement)) &Class_BotClient {
	this.events.on_entitlement_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_entitlement_update(handler fn (Entitlement)) &Class_BotClient {
	this.events.on_entitlement_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_entitlement_delete(handler fn (Entitlement)) &Class_BotClient {
	this.events.on_entitlement_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_audit_log_entry_create(handler fn (GuildAuditLogEntryCreateEvent)) &Class_BotClient {
	this.events.on_guild_audit_log_entry_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_ban_add(handler fn (GuildBanEvent)) &Class_BotClient {
	this.events.on_guild_ban_add = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_ban_remove(handler fn (GuildBanEvent)) &Class_BotClient {
	this.events.on_guild_ban_remove = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_emojis_update(handler fn (GuildEmojisUpdateEvent)) &Class_BotClient {
	this.events.on_guild_emojis_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_stickers_update(handler fn (GuildStickersUpdateEvent)) &Class_BotClient {
	this.events.on_guild_stickers_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_integrations_update(handler fn (GuildIntegrationsUpdateEvent)) &Class_BotClient {
	this.events.on_guild_integrations_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_members_chunk(handler fn (GuildMembersChunkEvent)) &Class_BotClient {
	this.events.on_guild_members_chunk = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_role_create(handler fn (GuildRoleEvent)) &Class_BotClient {
	this.events.on_guild_role_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_role_update(handler fn (GuildRoleEvent)) &Class_BotClient {
	this.events.on_guild_role_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_role_delete(handler fn (GuildRoleDeleteEvent)) &Class_BotClient {
	this.events.on_guild_role_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_scheduled_event_create(handler fn (GuildScheduledEvent)) &Class_BotClient {
	this.events.on_guild_scheduled_event_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_scheduled_event_update(handler fn (GuildScheduledEvent)) &Class_BotClient {
	this.events.on_guild_scheduled_event_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_scheduled_event_delete(handler fn (GuildScheduledEvent)) &Class_BotClient {
	this.events.on_guild_scheduled_event_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_scheduled_event_user_add(handler fn (GuildScheduledEventUserAddEvent)) &Class_BotClient {
	this.events.on_guild_scheduled_event_user_add = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_scheduled_event_user_remove(handler fn (GuildScheduledEventUserRemoveEvent)) &Class_BotClient {
	this.events.on_guild_scheduled_event_user_remove = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_soundboard_sound_create(handler fn (SoundboardSound)) &Class_BotClient {
	this.events.on_guild_soundboard_sound_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_soundboard_sound_update(handler fn (SoundboardSound)) &Class_BotClient {
	this.events.on_guild_soundboard_sound_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_soundboard_sound_delete(handler fn (GuildSoundboardSoundDeleteEvent)) &Class_BotClient {
	this.events.on_guild_soundboard_sound_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_guild_soundboard_sounds_update(handler fn (SoundboardSoundsUpdateEvent)) &Class_BotClient {
	this.events.on_guild_soundboard_sounds_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_integration_create(handler fn (IntegrationCreateUpdateEvent)) &Class_BotClient {
	this.events.on_integration_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_integration_update(handler fn (IntegrationCreateUpdateEvent)) &Class_BotClient {
	this.events.on_integration_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_integration_delete(handler fn (IntegrationEvent)) &Class_BotClient {
	this.events.on_integration_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_invite_create(handler fn (InviteCreateEvent)) &Class_BotClient {
	this.events.on_invite_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_invite_delete(handler fn (InviteDeleteEvent)) &Class_BotClient {
	this.events.on_invite_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_reaction_remove_all(handler fn (MessageReactionRemoveAllEvent)) &Class_BotClient {
	this.events.on_message_reaction_remove_all = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_reaction_remove_emoji(handler fn (MessageReactionRemoveEmojiEvent)) &Class_BotClient {
	this.events.on_message_reaction_remove_emoji = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_poll_vote_add(handler fn (MessagePollVoteEvent)) &Class_BotClient {
	this.events.on_message_poll_vote_add = handler
	return this
}

pub fn (mut this Class_BotClient) on_message_poll_vote_remove(handler fn (MessagePollVoteRemoveEvent)) &Class_BotClient {
	this.events.on_message_poll_vote_remove = handler
	return this
}

pub fn (mut this Class_BotClient) on_stage_instance_create(handler fn (StageInstance)) &Class_BotClient {
	this.events.on_stage_instance_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_stage_instance_update(handler fn (StageInstance)) &Class_BotClient {
	this.events.on_stage_instance_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_stage_instance_delete(handler fn (StageInstance)) &Class_BotClient {
	this.events.on_stage_instance_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_subscription_create(handler fn (SubscriptionEvent)) &Class_BotClient {
	this.events.on_subscription_create = handler
	return this
}

pub fn (mut this Class_BotClient) on_subscription_update(handler fn (SubscriptionEvent)) &Class_BotClient {
	this.events.on_subscription_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_subscription_delete(handler fn (SubscriptionEvent)) &Class_BotClient {
	this.events.on_subscription_delete = handler
	return this
}

pub fn (mut this Class_BotClient) on_user_update(handler fn (User)) &Class_BotClient {
	this.events.on_user_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_voice_channel_effect_send(handler fn (VoiceChannelEffectSendEvent)) &Class_BotClient {
	this.events.on_voice_channel_effect_send = handler
	return this
}

pub fn (mut this Class_BotClient) on_webhooks_update(handler fn (WebhooksUpdateEvent)) &Class_BotClient {
	this.events.on_webhooks_update = handler
	return this
}

pub fn (mut this Class_BotClient) on_heartbeat_ack(handler fn (i64)) &Class_BotClient {
	this.events.on_heartbeat_ack = handler
	return this
}

pub fn (mut this Class_BotClient) on_disconnect(handler fn (GatewayDisconnectEvent)) &Class_BotClient {
	this.events.on_disconnect = handler
	return this
}

pub fn (mut this Class_BotClient) on_reconnect(handler fn (GatewayReconnectEvent)) &Class_BotClient {
	this.events.on_reconnect = handler
	return this
}

pub fn (mut this Class_BotClient) on_debug(handler fn (GatewayDebugEvent)) &Class_BotClient {
	this.events.on_debug = handler
	return this
}
