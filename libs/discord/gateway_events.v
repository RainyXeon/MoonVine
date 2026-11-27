module discord

// Typed event handlers (add more event fields here anytime as needed)
pub struct GatewayEvents {
pub mut:
	on_disconnect                             ?fn (GatewayDisconnectEvent)
	on_reconnect                              ?fn (GatewayReconnectEvent)
	on_debug                                  ?fn (GatewayDebugEvent)
	on_heartbeat_ack                          ?fn (i64)
	on_ready                                  ?fn (ReadyEvent)
	on_resumed                                ?fn (ResumedEvent)
	on_rate_limited                           ?fn (RateLimitedEvent)
	on_application_command_permissions_update ?fn (ApplicationCommandPermissionsUpdateEvent)
	on_auto_moderation_rule_create            ?fn (AutoModerationRule)
	on_auto_moderation_rule_update            ?fn (AutoModerationRule)
	on_auto_moderation_rule_delete            ?fn (AutoModerationRule)
	on_auto_moderation_action_execution       ?fn (AutoModerationActionExecutionEvent)
	on_channel_create                         ?fn (Channel)
	on_channel_update                         ?fn (Channel)
	on_channel_delete                         ?fn (Channel)
	on_channel_info                           ?fn (ChannelInfoEvent)
	on_channel_pins_update                    ?fn (ChannelPinsUpdateEvent)
	on_thread_create                          ?fn (ThreadCreateEvent)
	on_thread_update                          ?fn (ThreadUpdateEvent)
	on_thread_delete                          ?fn (ThreadDeleteEvent)
	on_thread_list_sync                       ?fn (ThreadListSyncEvent)
	on_thread_member_update                   ?fn (ThreadMemberUpdateEvent)
	on_thread_members_update                  ?fn (ThreadMembersUpdateEvent)
	on_entitlement_create                     ?fn (Entitlement)
	on_entitlement_update                     ?fn (Entitlement)
	on_entitlement_delete                     ?fn (Entitlement)
	on_guild_create                           ?fn (GuildCreateEvent)
	on_guild_update                           ?fn (GuildCreateEvent)
	on_guild_delete                           ?fn (GuildDeleteEvent)
	on_guild_audit_log_entry_create           ?fn (GuildAuditLogEntryCreateEvent)
	on_guild_ban_add                          ?fn (GuildBanEvent)
	on_guild_ban_remove                       ?fn (GuildBanEvent)
	on_guild_emojis_update                    ?fn (GuildEmojisUpdateEvent)
	on_guild_stickers_update                  ?fn (GuildStickersUpdateEvent)
	on_guild_integrations_update              ?fn (GuildIntegrationsUpdateEvent)
	on_guild_member_add                       ?fn (GuildMemberAddEvent)
	on_guild_member_update                    ?fn (GuildMemberUpdateEvent)
	on_guild_member_remove                    ?fn (GuildMemberRemoveEvent)
	on_guild_members_chunk                    ?fn (GuildMembersChunkEvent)
	on_guild_role_create                      ?fn (GuildRoleEvent)
	on_guild_role_update                      ?fn (GuildRoleEvent)
	on_guild_role_delete                      ?fn (GuildRoleDeleteEvent)
	on_guild_scheduled_event_create           ?fn (GuildScheduledEvent)
	on_guild_scheduled_event_update           ?fn (GuildScheduledEvent)
	on_guild_scheduled_event_delete           ?fn (GuildScheduledEvent)
	on_guild_scheduled_event_user_add         ?fn (GuildScheduledEventUserAddEvent)
	on_guild_scheduled_event_user_remove      ?fn (GuildScheduledEventUserRemoveEvent)
	on_guild_soundboard_sound_create          ?fn (SoundboardSound)
	on_guild_soundboard_sound_update          ?fn (SoundboardSound)
	on_guild_soundboard_sound_delete          ?fn (GuildSoundboardSoundDeleteEvent)
	on_guild_soundboard_sounds_update         ?fn (SoundboardSoundsUpdateEvent)
	on_integration_create                     ?fn (IntegrationCreateUpdateEvent)
	on_integration_update                     ?fn (IntegrationCreateUpdateEvent)
	on_integration_delete                     ?fn (IntegrationEvent)
	on_interaction_create                     ?fn (InteractionCreateEvent)
	on_invite_create                          ?fn (InviteCreateEvent)
	on_invite_delete                          ?fn (InviteDeleteEvent)
	on_message_create                         ?fn (Message)
	on_message_update                         ?fn (Message)
	on_message_delete                         ?fn (MessageDeleteEvent)
	on_message_delete_bulk                    ?fn (MessageDeleteBulkEvent)
	on_message_reaction_add                   ?fn (MessageReactionEvent)
	on_message_reaction_remove                ?fn (MessageReactionRemoveEvent)
	on_message_reaction_remove_all            ?fn (MessageReactionRemoveAllEvent)
	on_message_reaction_remove_emoji          ?fn (MessageReactionRemoveEmojiEvent)
	on_message_poll_vote_add                  ?fn (MessagePollVoteEvent)
	on_message_poll_vote_remove               ?fn (MessagePollVoteRemoveEvent)
	on_presence_update                        ?fn (PresenceUpdateEvent)
	on_stage_instance_create                  ?fn (StageInstance)
	on_stage_instance_update                  ?fn (StageInstance)
	on_stage_instance_delete                  ?fn (StageInstance)
	on_subscription_create                    ?fn (SubscriptionEvent)
	on_subscription_update                    ?fn (SubscriptionEvent)
	on_subscription_delete                    ?fn (SubscriptionEvent)
	on_typing_start                           ?fn (TypingStartEvent)
	on_user_update                            ?fn (User)
	on_voice_channel_effect_send              ?fn (VoiceChannelEffectSendEvent)
	on_voice_state_update                     ?fn (VoiceStateEvent)
	on_voice_server_update                    ?fn (VoiceServerEvent)
	on_webhooks_update                        ?fn (WebhooksUpdateEvent)
	on_error                                  ?GatewayErrorHandler
	on_raw_dispatch                           ?GatewayDispatchHandler
}

pub struct HelloEvent {
pub:
	heartbeat_interval int
}

pub struct ReadyEvent {
pub:
	v                  int
	user               User
	guilds             []UnavailableGuild
	session_id         string
	resume_gateway_url string
	application        Application
}

pub struct UnavailableGuild {
pub:
	id          string
	unavailable ?bool
}

pub struct ResumedEvent {
pub:
	trace []string @[json: '_trace']
}

pub struct ClientStatus {
pub:
	desktop ?string
	mobile  ?string
	web     ?string
}

pub struct WebhooksUpdateEvent {
pub:
	guild_id   string
	channel_id string
}

pub struct RateLimitedEvent {
pub:
	opcode      int
	retry_after f64
	meta        RateLimitMeta
}

pub struct RateLimitMeta {
pub:
	guild_id ?string
	nonce    ?string
}

pub struct GatewayDisconnectEvent {
pub:
	code      int
	reason    string
	resumable bool
}

pub struct GatewayReconnectEvent {
pub:
	attempt    int
	resuming   bool
	session_id string
}

pub struct GatewayDebugEvent {
pub:
	message string
}
