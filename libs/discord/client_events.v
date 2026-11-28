module discord

pub fn (mut this Client) on_ready(handler fn (ReadyEvent)) &Client {
	this.events.on_ready = handler
	return this
}

pub fn (mut this Client) on_message_create(handler fn (Message)) &Client {
	this.events.on_message_create = handler
	return this
}

pub fn (mut this Client) on_interaction_create(handler fn (InteractionCreateEvent)) &Client {
	this.events.on_interaction_create = handler
	return this
}

pub fn (mut this Client) on_error(handler GatewayErrorHandler) &Client {
	this.events.on_error = handler
	return this
}

pub fn (mut this Client) on_resumed(handler fn (ResumedEvent)) &Client {
	this.events.on_resumed = handler
	return this
}

pub fn (mut this Client) on_message_update(handler fn (Message)) &Client {
	this.events.on_message_update = handler
	return this
}

pub fn (mut this Client) on_message_delete(handler fn (MessageDeleteEvent)) &Client {
	this.events.on_message_delete = handler
	return this
}

pub fn (mut this Client) on_message_delete_bulk(handler fn (MessageDeleteBulkEvent)) &Client {
	this.events.on_message_delete_bulk = handler
	return this
}

pub fn (mut this Client) on_message_reaction_add(handler fn (MessageReactionEvent)) &Client {
	this.events.on_message_reaction_add = handler
	return this
}

pub fn (mut this Client) on_message_reaction_remove(handler fn (MessageReactionRemoveEvent)) &Client {
	this.events.on_message_reaction_remove = handler
	return this
}

pub fn (mut this Client) on_guild_create(handler fn (GuildCreateEvent)) &Client {
	this.events.on_guild_create = handler
	return this
}

pub fn (mut this Client) on_guild_update(handler fn (GuildCreateEvent)) &Client {
	this.events.on_guild_update = handler
	return this
}

pub fn (mut this Client) on_guild_delete(handler fn (GuildDeleteEvent)) &Client {
	this.events.on_guild_delete = handler
	return this
}

pub fn (mut this Client) on_guild_member_add(handler fn (GuildMemberAddEvent)) &Client {
	this.events.on_guild_member_add = handler
	return this
}

pub fn (mut this Client) on_guild_member_update(handler fn (GuildMemberUpdateEvent)) &Client {
	this.events.on_guild_member_update = handler
	return this
}

pub fn (mut this Client) on_guild_member_remove(handler fn (GuildMemberRemoveEvent)) &Client {
	this.events.on_guild_member_remove = handler
	return this
}

pub fn (mut this Client) on_voice_state_update(handler fn (VoiceStateEvent)) &Client {
	this.events.on_voice_state_update = handler
	return this
}

pub fn (mut this Client) on_voice_server_update(handler fn (VoiceServerEvent)) &Client {
	this.events.on_voice_server_update = handler
	return this
}

pub fn (mut this Client) on_presence_update(handler fn (PresenceUpdateEvent)) &Client {
	this.events.on_presence_update = handler
	return this
}

pub fn (mut this Client) on_typing_start(handler fn (TypingStartEvent)) &Client {
	this.events.on_typing_start = handler
	return this
}

pub fn (mut this Client) on_raw_dispatch(handler GatewayDispatchHandler) &Client {
	this.events.on_raw_dispatch = handler
	return this
}

pub fn (mut this Client) on_rate_limited(handler fn (RateLimitedEvent)) &Client {
	this.events.on_rate_limited = handler
	return this
}

pub fn (mut this Client) on_application_command_permissions_update(handler fn (ApplicationCommandPermissionsUpdateEvent)) &Client {
	this.events.on_application_command_permissions_update = handler
	return this
}

pub fn (mut this Client) on_auto_moderation_rule_create(handler fn (AutoModerationRule)) &Client {
	this.events.on_auto_moderation_rule_create = handler
	return this
}

pub fn (mut this Client) on_auto_moderation_rule_update(handler fn (AutoModerationRule)) &Client {
	this.events.on_auto_moderation_rule_update = handler
	return this
}

pub fn (mut this Client) on_auto_moderation_rule_delete(handler fn (AutoModerationRule)) &Client {
	this.events.on_auto_moderation_rule_delete = handler
	return this
}

pub fn (mut this Client) on_auto_moderation_action_execution(handler fn (AutoModerationActionExecutionEvent)) &Client {
	this.events.on_auto_moderation_action_execution = handler
	return this
}

pub fn (mut this Client) on_channel_create(handler fn (Channel)) &Client {
	this.events.on_channel_create = handler
	return this
}

pub fn (mut this Client) on_channel_update(handler fn (Channel)) &Client {
	this.events.on_channel_update = handler
	return this
}

pub fn (mut this Client) on_channel_delete(handler fn (Channel)) &Client {
	this.events.on_channel_delete = handler
	return this
}

pub fn (mut this Client) on_channel_info(handler fn (ChannelInfoEvent)) &Client {
	this.events.on_channel_info = handler
	return this
}

pub fn (mut this Client) on_channel_pins_update(handler fn (ChannelPinsUpdateEvent)) &Client {
	this.events.on_channel_pins_update = handler
	return this
}

pub fn (mut this Client) on_thread_create(handler fn (ThreadCreateEvent)) &Client {
	this.events.on_thread_create = handler
	return this
}

pub fn (mut this Client) on_thread_update(handler fn (ThreadUpdateEvent)) &Client {
	this.events.on_thread_update = handler
	return this
}

pub fn (mut this Client) on_thread_delete(handler fn (ThreadDeleteEvent)) &Client {
	this.events.on_thread_delete = handler
	return this
}

pub fn (mut this Client) on_thread_list_sync(handler fn (ThreadListSyncEvent)) &Client {
	this.events.on_thread_list_sync = handler
	return this
}

pub fn (mut this Client) on_thread_member_update(handler fn (ThreadMemberUpdateEvent)) &Client {
	this.events.on_thread_member_update = handler
	return this
}

pub fn (mut this Client) on_thread_members_update(handler fn (ThreadMembersUpdateEvent)) &Client {
	this.events.on_thread_members_update = handler
	return this
}

pub fn (mut this Client) on_entitlement_create(handler fn (Entitlement)) &Client {
	this.events.on_entitlement_create = handler
	return this
}

pub fn (mut this Client) on_entitlement_update(handler fn (Entitlement)) &Client {
	this.events.on_entitlement_update = handler
	return this
}

pub fn (mut this Client) on_entitlement_delete(handler fn (Entitlement)) &Client {
	this.events.on_entitlement_delete = handler
	return this
}

pub fn (mut this Client) on_guild_audit_log_entry_create(handler fn (GuildAuditLogEntryCreateEvent)) &Client {
	this.events.on_guild_audit_log_entry_create = handler
	return this
}

pub fn (mut this Client) on_guild_ban_add(handler fn (GuildBanEvent)) &Client {
	this.events.on_guild_ban_add = handler
	return this
}

pub fn (mut this Client) on_guild_ban_remove(handler fn (GuildBanEvent)) &Client {
	this.events.on_guild_ban_remove = handler
	return this
}

pub fn (mut this Client) on_guild_emojis_update(handler fn (GuildEmojisUpdateEvent)) &Client {
	this.events.on_guild_emojis_update = handler
	return this
}

pub fn (mut this Client) on_guild_stickers_update(handler fn (GuildStickersUpdateEvent)) &Client {
	this.events.on_guild_stickers_update = handler
	return this
}

pub fn (mut this Client) on_guild_integrations_update(handler fn (GuildIntegrationsUpdateEvent)) &Client {
	this.events.on_guild_integrations_update = handler
	return this
}

pub fn (mut this Client) on_guild_members_chunk(handler fn (GuildMembersChunkEvent)) &Client {
	this.events.on_guild_members_chunk = handler
	return this
}

pub fn (mut this Client) on_guild_role_create(handler fn (GuildRoleEvent)) &Client {
	this.events.on_guild_role_create = handler
	return this
}

pub fn (mut this Client) on_guild_role_update(handler fn (GuildRoleEvent)) &Client {
	this.events.on_guild_role_update = handler
	return this
}

pub fn (mut this Client) on_guild_role_delete(handler fn (GuildRoleDeleteEvent)) &Client {
	this.events.on_guild_role_delete = handler
	return this
}

pub fn (mut this Client) on_guild_scheduled_event_create(handler fn (GuildScheduledEvent)) &Client {
	this.events.on_guild_scheduled_event_create = handler
	return this
}

pub fn (mut this Client) on_guild_scheduled_event_update(handler fn (GuildScheduledEvent)) &Client {
	this.events.on_guild_scheduled_event_update = handler
	return this
}

pub fn (mut this Client) on_guild_scheduled_event_delete(handler fn (GuildScheduledEvent)) &Client {
	this.events.on_guild_scheduled_event_delete = handler
	return this
}

pub fn (mut this Client) on_guild_scheduled_event_user_add(handler fn (GuildScheduledEventUserAddEvent)) &Client {
	this.events.on_guild_scheduled_event_user_add = handler
	return this
}

pub fn (mut this Client) on_guild_scheduled_event_user_remove(handler fn (GuildScheduledEventUserRemoveEvent)) &Client {
	this.events.on_guild_scheduled_event_user_remove = handler
	return this
}

pub fn (mut this Client) on_guild_soundboard_sound_create(handler fn (SoundboardSound)) &Client {
	this.events.on_guild_soundboard_sound_create = handler
	return this
}

pub fn (mut this Client) on_guild_soundboard_sound_update(handler fn (SoundboardSound)) &Client {
	this.events.on_guild_soundboard_sound_update = handler
	return this
}

pub fn (mut this Client) on_guild_soundboard_sound_delete(handler fn (GuildSoundboardSoundDeleteEvent)) &Client {
	this.events.on_guild_soundboard_sound_delete = handler
	return this
}

pub fn (mut this Client) on_guild_soundboard_sounds_update(handler fn (SoundboardSoundsUpdateEvent)) &Client {
	this.events.on_guild_soundboard_sounds_update = handler
	return this
}

pub fn (mut this Client) on_integration_create(handler fn (IntegrationCreateUpdateEvent)) &Client {
	this.events.on_integration_create = handler
	return this
}

pub fn (mut this Client) on_integration_update(handler fn (IntegrationCreateUpdateEvent)) &Client {
	this.events.on_integration_update = handler
	return this
}

pub fn (mut this Client) on_integration_delete(handler fn (IntegrationEvent)) &Client {
	this.events.on_integration_delete = handler
	return this
}

pub fn (mut this Client) on_invite_create(handler fn (InviteCreateEvent)) &Client {
	this.events.on_invite_create = handler
	return this
}

pub fn (mut this Client) on_invite_delete(handler fn (InviteDeleteEvent)) &Client {
	this.events.on_invite_delete = handler
	return this
}

pub fn (mut this Client) on_message_reaction_remove_all(handler fn (MessageReactionRemoveAllEvent)) &Client {
	this.events.on_message_reaction_remove_all = handler
	return this
}

pub fn (mut this Client) on_message_reaction_remove_emoji(handler fn (MessageReactionRemoveEmojiEvent)) &Client {
	this.events.on_message_reaction_remove_emoji = handler
	return this
}

pub fn (mut this Client) on_message_poll_vote_add(handler fn (MessagePollVoteEvent)) &Client {
	this.events.on_message_poll_vote_add = handler
	return this
}

pub fn (mut this Client) on_message_poll_vote_remove(handler fn (MessagePollVoteRemoveEvent)) &Client {
	this.events.on_message_poll_vote_remove = handler
	return this
}

pub fn (mut this Client) on_stage_instance_create(handler fn (StageInstance)) &Client {
	this.events.on_stage_instance_create = handler
	return this
}

pub fn (mut this Client) on_stage_instance_update(handler fn (StageInstance)) &Client {
	this.events.on_stage_instance_update = handler
	return this
}

pub fn (mut this Client) on_stage_instance_delete(handler fn (StageInstance)) &Client {
	this.events.on_stage_instance_delete = handler
	return this
}

pub fn (mut this Client) on_subscription_create(handler fn (SubscriptionEvent)) &Client {
	this.events.on_subscription_create = handler
	return this
}

pub fn (mut this Client) on_subscription_update(handler fn (SubscriptionEvent)) &Client {
	this.events.on_subscription_update = handler
	return this
}

pub fn (mut this Client) on_subscription_delete(handler fn (SubscriptionEvent)) &Client {
	this.events.on_subscription_delete = handler
	return this
}

pub fn (mut this Client) on_user_update(handler fn (User)) &Client {
	this.events.on_user_update = handler
	return this
}

pub fn (mut this Client) on_voice_channel_effect_send(handler fn (VoiceChannelEffectSendEvent)) &Client {
	this.events.on_voice_channel_effect_send = handler
	return this
}

pub fn (mut this Client) on_webhooks_update(handler fn (WebhooksUpdateEvent)) &Client {
	this.events.on_webhooks_update = handler
	return this
}

pub fn (mut this Client) on_heartbeat_ack(handler fn (i64)) &Client {
	this.events.on_heartbeat_ack = handler
	return this
}

pub fn (mut this Client) on_disconnect(handler fn (GatewayDisconnectEvent)) &Client {
	this.events.on_disconnect = handler
	return this
}

pub fn (mut this Client) on_reconnect(handler fn (GatewayReconnectEvent)) &Client {
	this.events.on_reconnect = handler
	return this
}

pub fn (mut this Client) on_debug(handler fn (GatewayDebugEvent)) &Client {
	this.events.on_debug = handler
	return this
}
