module discord

module discord

import net.http
import net.websocket
import rand
import time
import x.json2

pub struct LobbyMemberInput {
pub mut:
	id       string
	metadata ?map[string]string
	flags    ?int // e.g., 1 << 0 (CAN_LINK_LOBBY)
}

pub struct CreateLobbyParams {
pub mut:
	metadata             ?map[string]string
	members              ?[]LobbyMemberInput
	idle_timeout_seconds ?int // 5 to 604800 seconds (7 days)
}

pub struct ModifyLobbyParams {
pub mut:
	metadata             ?map[string]string
	members              ?[]LobbyMemberInput
	idle_timeout_seconds ?int
}

@[heap]
pub struct Class_BotClient {
	api_base_url string = 'https://discord.com/api'
	api_version  string = '10'
mut:
	token           string
	gateway_intents u32 = GatewayIntent.default_non_privileged()
	user_token      bool
	base_url        string
pub mut:
	events           GatewayEvents
	application      &Class_Application    = unsafe { nil }
	users            &Class_Users          = unsafe { nil }
	channels         &Class_Channels       = unsafe { nil }
	guilds           &Class_Guilds         = unsafe { nil }
	invites          &Class_Invites        = unsafe { nil }
	webhooks         &Class_Webhooks       = unsafe { nil }
	entitlements     &Class_Entitlements   = unsafe { nil }
	auto_moderation  &Class_AutoModeration = unsafe { nil }
	emojis           &Class_Emojis         = unsafe { nil }
	gateway          &Gateway              = unsafe { nil }
	gateway_listener &GatewayListener      = unsafe { nil }
	ws               &websocket.Client     = unsafe { nil }
}

pub fn new_class_bot_client() &Class_BotClient {
	mut bc := &Class_BotClient{}
	bc.application = new_class_application(bc)
	bc.users = new_class_users(bc)
	bc.channels = new_class_channels(bc)
	bc.guilds = new_class_guilds(bc)
	bc.invites = new_class_invites(bc)
	bc.webhooks = new_class_webhooks(bc)
	bc.entitlements = new_class_entitlements(bc)
	bc.auto_moderation = new_class_auto_moderation(bc)
	bc.emojis = new_class_emojis(bc)
	return bc
}

pub fn (this Class_BotClient) api_url() string {
	return '${this.api_base_url}/v${this.api_version}'
}

pub fn (mut this Class_BotClient) login_user(token string) &Class_BotClient {
	this.token = token
	this.user_token = true
	return this
}

pub fn (mut this Class_BotClient) api_base(url string) &Class_BotClient {
	this.base_url = url.trim_right('/')
	return this
}

pub fn (mut this Class_BotClient) intents(intents u32) &Class_BotClient {
	this.gateway_intents = intents
	return this
}

pub fn (mut this Class_BotClient) login(token string) !&Class_BotClient {
	this.user_token = false
	this.token = token
	this.gateway = new_gateway(this, this.gateway_intents)
	this.gateway_listener = new_gateway_listener(this.gateway)
	this.gateway_listener.events = this.events

	info := this.fetch_gateway()!
	this.ws = this.gateway_listener.connect(info.url)!

	spawn this.start_heartbeat_loop()
	this.gateway_listener.listen(mut this.ws)!

	if err := this.gateway_listener.last_error {
		if err.code != 1000 {
			return error(err.str())
		}
	}

	return this
}

// Chainable event helpers on Class_BotClient:
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

fn (mut this Class_BotClient) start_heartbeat_loop() {
	// Wait until OP 10 HELLO sets heartbeat_interval
	for this.gateway.heartbeat_interval <= 0 && this.gateway.state != .closed {
		time.sleep(50 * time.millisecond)
	}

	// Discord requires initial jitter: interval * random(0.0..1.0)
	jitter_ms := int(f64(this.gateway.heartbeat_interval) * rand.f64())
	time.sleep(jitter_ms * time.millisecond)

	for this.gateway.state != .closed {
		this.gateway_listener.heartbeat(mut this.ws, time.now().unix_milli()) or {
			eprintln('Heartbeat error: ${err}')
			break
		}
		// Poll every 250ms; HeartbeatTracker.heartbeat() only sends once interval_ms has elapsed
		time.sleep(250 * time.millisecond)
	}
}

pub fn (this &Class_BotClient) fetch_lobby(lobby_id string) !Lobby {
	res := this.raw_request(.get, '/lobbies/${lobby_id}', http.FetchConfig{})!
	return decode_response[Lobby](res)
}

pub fn (this &Class_BotClient) create_lobby(data CreateLobbyParams) !Lobby {
	res := this.raw_request(.post, '/lobbies', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[Lobby](res)
}

pub fn (this &Class_BotClient) edit_lobby(lobby_id string, data ModifyLobbyParams) !Lobby {
	res := this.raw_request(.patch, '/lobbies/${lobby_id}', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[Lobby](res)
}

pub fn (this &Class_BotClient) delete_lobby(lobby_id string) ! {
	res := this.raw_request(.delete, '/lobbies/${lobby_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (mut this Class_BotClient) raw_request(method http.Method, route string, override_config http.FetchConfig) !http.Response {
	if this.token.len == 0 {
		return error('BOT_TOKEN_NOT_FOUND')
	}

	mut header := http.new_header()
	header.add(.content_type, 'application/json')
	header.add(.authorization, if auth := override_config.header.get(.authorization) {
		auth
	} else if this.user_token {
		this.token
	} else {
		'Bot ' + this.token
	})

	base_fetch_config := http.FetchConfig{
		url:    if this.base_url != '' { this.base_url + route } else { this.api_url() + route }
		method: method
		header: header
	}

	final_cfg := merge_fetch_config(base_fetch_config, override_config) or {
		return err
	}

	res := http.fetch(final_cfg) or {
		return err
	}

	return res
}

pub fn merge_fetch_config(base http.FetchConfig, override http.FetchConfig) !http.FetchConfig {
	mut merged_cookies := base.cookies.clone()
	for k, v in override.cookies {
		merged_cookies[k] = v
	}

	mut merged_header := base.header
	for key in override.header.keys() {
		vals := override.header.custom_values(key)
		for i, val in vals {
			if i == 0 {
				merged_header.set_custom(key, val)!
			} else {
				merged_header.add_custom(key, val)!
			}
		}
	}

	return http.FetchConfig{
		...base
		url:            if override.url != '' { override.url } else { base.url }
		method:         if override.method != .get { override.method } else { base.method }
		data:           if override.data != '' { override.data } else { base.data }
		user_agent:     if override.user_agent != '' {
			override.user_agent
		} else {
			base.user_agent
		}
		verbose:        override.verbose || base.verbose
		allow_redirect: override.allow_redirect
		max_retries:    if override.max_retries != 0 {
			override.max_retries
		} else {
			base.max_retries
		}
		read_timeout:   if override.read_timeout != 0 {
			override.read_timeout
		} else {
			base.read_timeout
		}
		write_timeout:  if override.write_timeout != 0 {
			override.write_timeout
		} else {
			base.write_timeout
		}
		enable_http2:   override.enable_http2 || base.enable_http2
		header:         merged_header
		cookies:        merged_cookies
	}
}
