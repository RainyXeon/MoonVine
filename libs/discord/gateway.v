module discord

import x.json2
import net.http
import net.websocket
import time

pub struct GatewayDispatch {
pub:
	op       int
	event    string
	sequence ?int
	data     json2.Any
}

pub struct GatewayHello {
pub:
	heartbeat_interval int
}

pub struct GatewayIdentify {
pub:
	token           string
	properties      GatewayIdentifyProperties @[json: 'properties']
	intents         u32
	compress        ?bool
	large_threshold ?int
}

pub struct GatewayIdentifyProperties {
pub:
	os      string
	browser string
	device  string
}

pub struct GatewayResume {
pub:
	token      string
	session_id string
	seq        int
}

pub struct GatewayPayload {
pub:
	op int
	d  json2.Any
	s  ?int
	t  ?string
}

pub struct GatewayInfo {
pub:
	url    string
	shards int
}

pub struct GatewayError {
pub:
	code    int
	message string
	fatal   bool
}

pub fn (e GatewayError) str() string {
	return if e.code != 0 {
		'Gateway error (${e.code}): ${e.message}'
	} else {
		'Gateway error: ${e.message}'
	}
}

pub enum GatewayConnectionState {
	idle
	connecting
	awaiting_hello
	identifying
	ready
	resuming
	reconnecting
	closed
}

@[heap]
pub struct Gateway {
pub mut:
	client              &Class_BotClient
	state               GatewayConnectionState
	intents             u32
	last_sequence       int
	session_id          string
	resume_gateway_url  string
	heartbeat_interval  int
	heartbeat_tracker   HeartbeatTracker
	identify_properties GatewayIdentifyProperties
	listener            &GatewayListener = unsafe { nil }
}

pub fn (this Gateway) ping() i64 {
	return this.heartbeat_tracker.latency_ms
}

pub fn new_gateway(client &Class_BotClient, intents u32) &Gateway {
	mut gw := &Gateway{
		client:              client
		intents:             intents
		identify_properties: GatewayIdentifyProperties{
			os:      'linux'
			browser: 'MoonVine'
			device:  'MoonVine'
		}
	}
	gw.listener = new_gateway_listener(gw, none)
	return gw
}

pub fn (this &Class_BotClient) fetch_gateway() !GatewayInfo {
	res := this.raw_request(.get, '/gateway/bot', http.FetchConfig{})!
	return decode_response[GatewayInfo](res)
}

pub fn decode_gateway_dispatch(raw string) !GatewayDispatch {
	payload := json2.decode[GatewayPayload](raw) or {
		return error('Invalid Gateway payload: ${err}')
	}
	if payload.op != 0 {
		return error('Gateway payload is not a DISPATCH event')
	}
	return GatewayDispatch{
		op:       payload.op
		event:    payload.t or { '' }
		sequence: payload.s
		data:     payload.d
	}
}

pub fn gateway_identify_payload(token string, intents u32, properties GatewayIdentifyProperties) string {
	identify := GatewayIdentify{
		token:      token
		intents:    intents
		properties: properties
	}
	return '{"op":2,"d":${json2.encode(identify)}}'
}

pub fn gateway_resume_payload(token string, session_id string, sequence int) string {
	resume := GatewayResume{
		token:      token
		session_id: session_id
		seq:        sequence
	}
	return '{"op":6,"d":${json2.encode(resume)}}'
}

pub fn gateway_heartbeat_payload(sequence ?int) string {
	return if seq := sequence {
		'{"op":1,"d":${seq}}'
	} else {
		'{"op":1,"d":null}'
	}
}

pub fn gateway_opcode(raw string) !int {
	payload := json2.decode[GatewayPayload](raw) or {
		return error('Invalid Gateway payload: ${err}')
	}
	return payload.op
}

pub fn gateway_heartbeat_interval(raw string) !int {
	payload := json2.decode[GatewayPayload](raw) or {
		return error('Invalid Gateway HELLO payload: ${err}')
	}
	if payload.op != 10 {
		return error('Gateway payload is not HELLO')
	}
	hello := json2.decode[GatewayHello](payload.d.json_str()) or {
		return error('Invalid Gateway HELLO data: ${err}')
	}
	if hello.heartbeat_interval <= 0 {
		return error('Gateway HELLO has invalid heartbeat interval')
	}
	return hello.heartbeat_interval
}

pub type GatewayDispatchHandler = fn (GatewayDispatch) !
pub type GatewayErrorHandler = fn (GatewayError)

@[heap]
pub struct GatewayListener {
pub mut:
	gateway     &Gateway
	events      GatewayEvents
	on_dispatch ?GatewayDispatchHandler
	last_error  ?GatewayError
}

pub fn new_gateway_listener(gateway &Gateway, on_dispatch ?GatewayDispatchHandler) &GatewayListener {
	return &GatewayListener{
		gateway:     gateway
		on_dispatch: on_dispatch
	}
}

fn (mut listener GatewayListener) emit_error(err GatewayError) {
	if err.code == 1000 && listener.last_error != none {
		return
	}
	listener.last_error = err
	if handler := listener.events.on_error {
		handler(err)
	}
}

fn (mut listener GatewayListener) emit_dispatch(dispatch GatewayDispatch) ! {
	match dispatch.event {
		'READY' {
			ready := dispatch.decode[ReadyEvent]()!
			listener.gateway.session_id = ready.session_id
			listener.gateway.resume_gateway_url = ready.resume_gateway_url
			listener.gateway.state = .ready
			if handler := listener.events.on_ready {
				handler(ready)
			}
		}
		'RESUMED' {
			listener.gateway.state = .ready
			if handler := listener.events.on_resumed {
				resumed := dispatch.decode[ResumedEvent]() or { ResumedEvent{} }
				handler(resumed)
			}
		}
		'RATE_LIMITED' {
			if handler := listener.events.on_rate_limited {
				handler(dispatch.decode[RateLimitedEvent]()!)
			}
		}
		'APPLICATION_COMMAND_PERMISSIONS_UPDATE' {
			if handler := listener.events.on_application_command_permissions_update {
				handler(dispatch.decode[ApplicationCommandPermissionsUpdateEvent]()!)
			}
		}
		'AUTO_MODERATION_RULE_CREATE' {
			if handler := listener.events.on_auto_moderation_rule_create {
				handler(dispatch.decode[AutoModerationRule]()!)
			}
		}
		'AUTO_MODERATION_RULE_UPDATE' {
			if handler := listener.events.on_auto_moderation_rule_update {
				handler(dispatch.decode[AutoModerationRule]()!)
			}
		}
		'AUTO_MODERATION_RULE_DELETE' {
			if handler := listener.events.on_auto_moderation_rule_delete {
				handler(dispatch.decode[AutoModerationRule]()!)
			}
		}
		'AUTO_MODERATION_ACTION_EXECUTION' {
			if handler := listener.events.on_auto_moderation_action_execution {
				handler(dispatch.decode[AutoModerationActionExecutionEvent]()!)
			}
		}
		'CHANNEL_CREATE' {
			if handler := listener.events.on_channel_create {
				handler(dispatch.decode[Channel]()!)
			}
		}
		'CHANNEL_UPDATE' {
			if handler := listener.events.on_channel_update {
				handler(dispatch.decode[Channel]()!)
			}
		}
		'CHANNEL_DELETE' {
			if handler := listener.events.on_channel_delete {
				handler(dispatch.decode[Channel]()!)
			}
		}
		'CHANNEL_INFO' {
			if handler := listener.events.on_channel_info {
				handler(dispatch.decode[ChannelInfoEvent]()!)
			}
		}
		'CHANNEL_PINS_UPDATE' {
			if handler := listener.events.on_channel_pins_update {
				handler(dispatch.decode[ChannelPinsUpdateEvent]()!)
			}
		}
		'THREAD_CREATE' {
			if handler := listener.events.on_thread_create {
				handler(dispatch.decode[ThreadCreateEvent]()!)
			}
		}
		'THREAD_UPDATE' {
			if handler := listener.events.on_thread_update {
				handler(dispatch.decode[ThreadUpdateEvent]()!)
			}
		}
		'THREAD_DELETE' {
			if handler := listener.events.on_thread_delete {
				handler(dispatch.decode[ThreadDeleteEvent]()!)
			}
		}
		'THREAD_LIST_SYNC' {
			if handler := listener.events.on_thread_list_sync {
				handler(dispatch.decode[ThreadListSyncEvent]()!)
			}
		}
		'THREAD_MEMBER_UPDATE' {
			if handler := listener.events.on_thread_member_update {
				handler(dispatch.decode[ThreadMemberUpdateEvent]()!)
			}
		}
		'THREAD_MEMBERS_UPDATE' {
			if handler := listener.events.on_thread_members_update {
				handler(dispatch.decode[ThreadMembersUpdateEvent]()!)
			}
		}
		'ENTITLEMENT_CREATE' {
			if handler := listener.events.on_entitlement_create {
				handler(dispatch.decode[Entitlement]()!)
			}
		}
		'ENTITLEMENT_UPDATE' {
			if handler := listener.events.on_entitlement_update {
				handler(dispatch.decode[Entitlement]()!)
			}
		}
		'ENTITLEMENT_DELETE' {
			if handler := listener.events.on_entitlement_delete {
				handler(dispatch.decode[Entitlement]()!)
			}
		}
		'GUILD_CREATE' {
			if handler := listener.events.on_guild_create {
				handler(dispatch.decode[GuildCreateEvent]()!)
			}
		}
		'GUILD_UPDATE' {
			if handler := listener.events.on_guild_update {
				handler(dispatch.decode[GuildCreateEvent]()!)
			}
		}
		'GUILD_DELETE' {
			if handler := listener.events.on_guild_delete {
				handler(dispatch.decode[GuildDeleteEvent]()!)
			}
		}
		'GUILD_AUDIT_LOG_ENTRY_CREATE' {
			if handler := listener.events.on_guild_audit_log_entry_create {
				handler(dispatch.decode[GuildAuditLogEntryCreateEvent]()!)
			}
		}
		'GUILD_BAN_ADD' {
			if handler := listener.events.on_guild_ban_add {
				handler(dispatch.decode[GuildBanEvent]()!)
			}
		}
		'GUILD_BAN_REMOVE' {
			if handler := listener.events.on_guild_ban_remove {
				handler(dispatch.decode[GuildBanEvent]()!)
			}
		}
		'GUILD_EMOJIS_UPDATE' {
			if handler := listener.events.on_guild_emojis_update {
				handler(dispatch.decode[GuildEmojisUpdateEvent]()!)
			}
		}
		'GUILD_STICKERS_UPDATE' {
			if handler := listener.events.on_guild_stickers_update {
				handler(dispatch.decode[GuildStickersUpdateEvent]()!)
			}
		}
		'GUILD_INTEGRATIONS_UPDATE' {
			if handler := listener.events.on_guild_integrations_update {
				handler(dispatch.decode[GuildIntegrationsUpdateEvent]()!)
			}
		}
		'GUILD_MEMBER_ADD' {
			if handler := listener.events.on_guild_member_add {
				handler(dispatch.decode[GuildMemberAddEvent]()!)
			}
		}
		'GUILD_MEMBER_UPDATE' {
			if handler := listener.events.on_guild_member_update {
				handler(dispatch.decode[GuildMemberUpdateEvent]()!)
			}
		}
		'GUILD_MEMBER_REMOVE' {
			if handler := listener.events.on_guild_member_remove {
				handler(dispatch.decode[GuildMemberRemoveEvent]()!)
			}
		}
		'GUILD_MEMBERS_CHUNK' {
			if handler := listener.events.on_guild_members_chunk {
				handler(dispatch.decode[GuildMembersChunkEvent]()!)
			}
		}
		'GUILD_ROLE_CREATE' {
			if handler := listener.events.on_guild_role_create {
				handler(dispatch.decode[GuildRoleEvent]()!)
			}
		}
		'GUILD_ROLE_UPDATE' {
			if handler := listener.events.on_guild_role_update {
				handler(dispatch.decode[GuildRoleEvent]()!)
			}
		}
		'GUILD_ROLE_DELETE' {
			if handler := listener.events.on_guild_role_delete {
				handler(dispatch.decode[GuildRoleDeleteEvent]()!)
			}
		}
		'GUILD_SCHEDULED_EVENT_CREATE' {
			if handler := listener.events.on_guild_scheduled_event_create {
				handler(dispatch.decode[GuildScheduledEvent]()!)
			}
		}
		'GUILD_SCHEDULED_EVENT_UPDATE' {
			if handler := listener.events.on_guild_scheduled_event_update {
				handler(dispatch.decode[GuildScheduledEvent]()!)
			}
		}
		'GUILD_SCHEDULED_EVENT_DELETE' {
			if handler := listener.events.on_guild_scheduled_event_delete {
				handler(dispatch.decode[GuildScheduledEvent]()!)
			}
		}
		'GUILD_SCHEDULED_EVENT_USER_ADD' {
			if handler := listener.events.on_guild_scheduled_event_user_add {
				handler(dispatch.decode[GuildScheduledEventUserAddEvent]()!)
			}
		}
		'GUILD_SCHEDULED_EVENT_USER_REMOVE' {
			if handler := listener.events.on_guild_scheduled_event_user_remove {
				handler(dispatch.decode[GuildScheduledEventUserRemoveEvent]()!)
			}
		}
		'GUILD_SOUNDBOARD_SOUND_CREATE' {
			if handler := listener.events.on_guild_soundboard_sound_create {
				handler(dispatch.decode[SoundboardSound]()!)
			}
		}
		'GUILD_SOUNDBOARD_SOUND_UPDATE' {
			if handler := listener.events.on_guild_soundboard_sound_update {
				handler(dispatch.decode[SoundboardSound]()!)
			}
		}
		'GUILD_SOUNDBOARD_SOUND_DELETE' {
			if handler := listener.events.on_guild_soundboard_sound_delete {
				handler(dispatch.decode[GuildSoundboardSoundDeleteEvent]()!)
			}
		}
		'GUILD_SOUNDBOARD_SOUNDS_UPDATE', 'SOUNDBOARD_SOUNDS_UPDATE' {
			if handler := listener.events.on_guild_soundboard_sounds_update {
				handler(dispatch.decode[SoundboardSoundsUpdateEvent]()!)
			}
		}
		'INTEGRATION_CREATE' {
			if handler := listener.events.on_integration_create {
				handler(dispatch.decode[IntegrationCreateUpdateEvent]()!)
			}
		}
		'INTEGRATION_UPDATE' {
			if handler := listener.events.on_integration_update {
				handler(dispatch.decode[IntegrationCreateUpdateEvent]()!)
			}
		}
		'INTEGRATION_DELETE' {
			if handler := listener.events.on_integration_delete {
				handler(dispatch.decode[IntegrationEvent]()!)
			}
		}
		'INTERACTION_CREATE' {
			if handler := listener.events.on_interaction_create {
				handler(dispatch.decode[InteractionCreateEvent]()!)
			}
		}
		'INVITE_CREATE' {
			if handler := listener.events.on_invite_create {
				handler(dispatch.decode[InviteCreateEvent]()!)
			}
		}
		'INVITE_DELETE' {
			if handler := listener.events.on_invite_delete {
				handler(dispatch.decode[InviteDeleteEvent]()!)
			}
		}
		'MESSAGE_CREATE' {
			if handler := listener.events.on_message_create {
				handler(dispatch.decode[Message]()!)
			}
		}
		'MESSAGE_UPDATE' {
			if handler := listener.events.on_message_update {
				handler(dispatch.decode[Message]()!)
			}
		}
		'MESSAGE_DELETE' {
			if handler := listener.events.on_message_delete {
				handler(dispatch.decode[MessageDeleteEvent]()!)
			}
		}
		'MESSAGE_DELETE_BULK' {
			if handler := listener.events.on_message_delete_bulk {
				handler(dispatch.decode[MessageDeleteBulkEvent]()!)
			}
		}
		'MESSAGE_REACTION_ADD' {
			if handler := listener.events.on_message_reaction_add {
				handler(dispatch.decode[MessageReactionEvent]()!)
			}
		}
		'MESSAGE_REACTION_REMOVE' {
			if handler := listener.events.on_message_reaction_remove {
				handler(dispatch.decode[MessageReactionRemoveEvent]()!)
			}
		}
		'MESSAGE_REACTION_REMOVE_ALL' {
			if handler := listener.events.on_message_reaction_remove_all {
				handler(dispatch.decode[MessageReactionRemoveAllEvent]()!)
			}
		}
		'MESSAGE_REACTION_REMOVE_EMOJI' {
			if handler := listener.events.on_message_reaction_remove_emoji {
				handler(dispatch.decode[MessageReactionRemoveEmojiEvent]()!)
			}
		}
		'MESSAGE_POLL_VOTE_ADD' {
			if handler := listener.events.on_message_poll_vote_add {
				handler(dispatch.decode[MessagePollVoteEvent]()!)
			}
		}
		'MESSAGE_POLL_VOTE_REMOVE' {
			if handler := listener.events.on_message_poll_vote_remove {
				handler(dispatch.decode[MessagePollVoteRemoveEvent]()!)
			}
		}
		'PRESENCE_UPDATE' {
			if handler := listener.events.on_presence_update {
				handler(dispatch.decode[PresenceUpdateEvent]()!)
			}
		}
		'STAGE_INSTANCE_CREATE' {
			if handler := listener.events.on_stage_instance_create {
				handler(dispatch.decode[StageInstance]()!)
			}
		}
		'STAGE_INSTANCE_UPDATE' {
			if handler := listener.events.on_stage_instance_update {
				handler(dispatch.decode[StageInstance]()!)
			}
		}
		'STAGE_INSTANCE_DELETE' {
			if handler := listener.events.on_stage_instance_delete {
				handler(dispatch.decode[StageInstance]()!)
			}
		}
		'SUBSCRIPTION_CREATE' {
			if handler := listener.events.on_subscription_create {
				handler(dispatch.decode[SubscriptionEvent]()!)
			}
		}
		'SUBSCRIPTION_UPDATE' {
			if handler := listener.events.on_subscription_update {
				handler(dispatch.decode[SubscriptionEvent]()!)
			}
		}
		'SUBSCRIPTION_DELETE' {
			if handler := listener.events.on_subscription_delete {
				handler(dispatch.decode[SubscriptionEvent]()!)
			}
		}
		'TYPING_START' {
			if handler := listener.events.on_typing_start {
				handler(dispatch.decode[TypingStartEvent]()!)
			}
		}
		'USER_UPDATE' {
			if handler := listener.events.on_user_update {
				handler(dispatch.decode[User]()!)
			}
		}
		'VOICE_CHANNEL_EFFECT_SEND' {
			if handler := listener.events.on_voice_channel_effect_send {
				handler(dispatch.decode[VoiceChannelEffectSendEvent]()!)
			}
		}
		'VOICE_STATE_UPDATE' {
			if handler := listener.events.on_voice_state_update {
				handler(dispatch.decode[VoiceStateEvent]()!)
			}
		}
		'VOICE_SERVER_UPDATE' {
			if handler := listener.events.on_voice_server_update {
				handler(dispatch.decode[VoiceServerEvent]()!)
			}
		}
		'WEBHOOKS_UPDATE' {
			if handler := listener.events.on_webhooks_update {
				handler(dispatch.decode[WebhooksUpdateEvent]()!)
			}
		}
		else {}
	}

	if handler := listener.events.on_raw_dispatch {
		handler(dispatch)!
	}
	if handler := listener.on_dispatch {
		handler(dispatch)!
	}
}

fn gateway_listener_on_message(mut ws websocket.Client, msg &websocket.Message, ref voidptr) ! {
	mut listener := unsafe { &GatewayListener(ref) }
	if msg.opcode != .text_frame {
		return
	}
	raw := msg.payload.bytestr()
	payload := json2.decode[GatewayPayload](raw) or {
		msg_err := 'Invalid Gateway payload: ${err}'
		listener.emit_error(GatewayError{
			message: msg_err
		})
		return error(msg_err)
	}
	if sequence := payload.s {
		listener.gateway.last_sequence = sequence
	}
	match payload.op {
		10 {
			interval := gateway_heartbeat_interval(raw) or {
				listener.emit_error(GatewayError{
					message: err.msg()
				})
				return err
			}
			listener.gateway.heartbeat_interval = interval
			listener.gateway.heartbeat_tracker.start(interval)!
			listener.gateway.state = if listener.gateway.session_id == '' {
				.identifying
			} else {
				.resuming
			}
			identify_or_resume := if listener.gateway.session_id != '' {
				gateway_resume_payload(listener.gateway.client.token, listener.gateway.session_id,
					listener.gateway.last_sequence)
			} else {
				gateway_identify_payload(listener.gateway.client.token, listener.gateway.intents,
					listener.gateway.identify_properties)
			}
			ws.write_string(identify_or_resume)!
		}
		1 {
			if listener.gateway.heartbeat_tracker.awaiting_ack {
				listener.gateway.state = .reconnecting
				listener.emit_error(GatewayError{
					message: 'Gateway missed a heartbeat ACK'
				})
				return error('Gateway missed a heartbeat ACK')
			}
			ws.write_string(gateway_heartbeat_payload(listener.gateway.last_sequence))!
			listener.gateway.heartbeat_tracker.mark_sent(time.now().unix_milli())
		}
		11 {
			listener.gateway.heartbeat_tracker.acknowledge(time.now().unix_milli())
			if handler := listener.events.on_heartbeat_ack {
				handler(listener.gateway.heartbeat_tracker.latency_ms)
			}
		}
		7 {
			listener.gateway.state = .reconnecting
			listener.emit_error(GatewayError{
				message: 'Gateway requested reconnect'
			})
			return error('Gateway requested reconnect')
		}
		9 {
			listener.gateway.state = .reconnecting
			resumable := payload.d.bool()
			if !resumable {
				listener.gateway.session_id = ''
			}
			msg_err := if resumable {
				'Gateway invalidated session; reconnect may resume'
			} else {
				'Gateway invalidated session; identify required'
			}
			listener.emit_error(GatewayError{
				message: msg_err
			})
			return error(msg_err)
		}
		0 {
			dispatch := GatewayDispatch{
				op:       payload.op
				event:    payload.t or { '' }
				sequence: payload.s
				data:     payload.d
			}
			listener.emit_dispatch(dispatch) or {
				listener.emit_error(GatewayError{
					message: err.msg()
				})
				return err
			}
		}
		else {}
	}
}

pub fn (mut listener GatewayListener) heartbeat(mut ws websocket.Client, now_ms i64) ! {
	listener.gateway.heartbeat_tracker.heartbeat(mut ws, listener.gateway.last_sequence, now_ms)!
}

pub fn (mut listener GatewayListener) connect(gateway_url string) !&websocket.Client {
	if listener.gateway.client.token.len == 0 {
		return error('BOT_TOKEN_NOT_FOUND')
	}
	url := gateway_url.trim_right('/')
	mut ws := websocket.new_client('${url}/?v=10&encoding=json', websocket.ClientOpt{
		read_timeout: time.infinite
	})!
	ws.logger.set_level(.disabled)
	ws.on_message_ref(gateway_listener_on_message, voidptr(listener))
	ws.on_close_ref(gateway_listener_on_close, voidptr(listener))
	ws.on_error_ref(fn (mut ws websocket.Client, err string, ref voidptr) ! {
		mut listener := unsafe { &GatewayListener(ref) }
		listener.emit_error(GatewayError{
			message: err
		})
	}, voidptr(listener))
	ws.connect()!
	listener.gateway.state = .awaiting_hello
	return ws
}

pub fn (dispatch GatewayDispatch) decode[T]() !T {
	return json2.decode[T](dispatch.data.json_str()) or {
		return error('Failed to decode ${dispatch.event} dispatch: ${err}')
	}
}

pub struct HeartbeatTracker {
pub mut:
	interval_ms       int
	last_heartbeat_at i64
	awaiting_ack      bool
	latency_ms        i64 = -1 // -1 until first OP 11 ACK is received
}

pub fn (mut tracker HeartbeatTracker) start(interval_ms int) ! {
	if interval_ms <= 0 {
		return error('Gateway heartbeat interval must be positive')
	}
	tracker.interval_ms = interval_ms
	tracker.last_heartbeat_at = 0
	tracker.awaiting_ack = false
	tracker.latency_ms = -1
}

pub fn (tracker HeartbeatTracker) heartbeat_due(now_ms i64) bool {
	return tracker.interval_ms > 0 && (tracker.last_heartbeat_at == 0
		|| now_ms - tracker.last_heartbeat_at >= tracker.interval_ms)
}

pub fn (mut tracker HeartbeatTracker) mark_sent(now_ms i64) {
	tracker.last_heartbeat_at = now_ms
	tracker.awaiting_ack = true
}

pub fn (mut tracker HeartbeatTracker) acknowledge(now_ms i64) {
	if tracker.last_heartbeat_at > 0 {
		tracker.latency_ms = now_ms - tracker.last_heartbeat_at
	}
	tracker.awaiting_ack = false
}

pub fn (mut tracker HeartbeatTracker) heartbeat(mut ws websocket.Client, sequence ?int, now_ms i64) ! {
	if !tracker.heartbeat_due(now_ms) {
		return
	}
	if tracker.awaiting_ack {
		return error('Gateway heartbeat ACK was not received before the next heartbeat')
	}
	ws.write_string(gateway_heartbeat_payload(sequence))!
	tracker.mark_sent(now_ms)
}

fn gateway_listener_on_close(mut ws websocket.Client, code int, reason string, ref voidptr) ! {
	mut listener := unsafe { &GatewayListener(ref) }
	_ = ws.get_state()
	fatal := code in [4004, 4010, 4011, 4012, 4013, 4014]
	listener.gateway.state = if fatal { .closed } else { .reconnecting }
	if code == 4007 || code == 4009 {
		listener.gateway.session_id = ''
	}
	listener.emit_error(GatewayError{
		code:    code
		message: if reason != '' { reason } else { 'Connection closed' }
		fatal:   fatal
	})
}

pub fn (mut listener GatewayListener) listen(mut ws websocket.Client) ! {
	ws.listen()!
}

pub struct GatewayInvalidSession {
pub:
	resumable bool
}

pub struct GatewayHeartbeatAck {
pub:
	op int
}

pub struct GatewayReconnect {
pub:
	op int
}

pub struct GatewaySessionStartLimit {
pub:
	total           int
	remaining       int
	reset_after     int
	max_concurrency int
}

pub struct GatewayBotInfo {
pub:
	url                 string
	shards              int
	session_start_limit GatewaySessionStartLimit
}
