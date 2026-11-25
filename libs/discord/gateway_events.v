module discord

// Typed event handlers (add more event fields here anytime as needed)
pub struct GatewayEvents {
pub mut:
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

pub struct ChannelPinsUpdateEvent {
pub:
	guild_id           ?string
	channel_id         string
	last_pin_timestamp ?string
}

pub struct ThreadListSyncEvent {
pub:
	guild_id    string
	channel_ids ?[]string
	threads     []Channel
	members     []ThreadMember
}

pub struct ThreadMemberUpdateEvent {
pub:
	id             string
	user_id        ?string
	join_timestamp string
	flags          int
	guild_id       string
}

pub struct ThreadMembersUpdateEvent {
pub:
	id                 string
	guild_id           string
	member_count       int
	added_members      ?[]ThreadMember
	removed_member_ids ?[]string
}

pub struct MessageDeleteEvent {
pub:
	id         string
	channel_id string
	guild_id   ?string
}

pub struct MessageDeleteBulkEvent {
pub:
	ids        []string
	channel_id string
	guild_id   ?string
}

pub struct MessageReactionEvent {
pub:
	user_id           ?string
	channel_id        string
	message_id        string
	guild_id          ?string
	member            ?GuildMember
	emoji             Emoji
	message_author_id ?string
	burst             ?bool
	burst_colors      ?[]string
	reaction_type     ?int @[json: 'type']
}

pub struct MessageReactionRemoveAllEvent {
pub:
	channel_id string
	message_id string
	guild_id   ?string
}

pub struct MessageReactionRemoveEmojiEvent {
pub:
	channel_id string
	message_id string
	guild_id   ?string
	emoji      Emoji
}

pub struct MessagePollVoteEvent {
pub:
	user_id    string
	channel_id string
	message_id string
	guild_id   ?string
	answer_id  int
}

pub struct TypingStartEvent {
pub:
	channel_id string
	guild_id   ?string
	user_id    string
	timestamp  int
	member     ?GuildMember
}

pub struct VoiceStateEvent {
pub:
	guild_id                   ?string
	channel_id                 ?string
	user_id                    string
	member                     ?GuildMember
	session_id                 string
	deaf                       bool
	mute                       bool
	self_deaf                  bool
	self_mute                  bool
	self_stream                ?bool
	self_video                 bool
	suppress                   bool
	request_to_speak_timestamp ?string
}

pub struct VoiceServerEvent {
pub:
	token    string
	guild_id ?string
	endpoint ?string
}

pub struct PresenceUpdateEvent {
pub:
	user          PartialPresenceUser
	guild_id      ?string
	status        string
	activities    []Activity
	client_status ClientStatus
}

pub struct PartialPresenceUser {
pub:
	id string
}

pub struct ClientStatus {
pub:
	desktop ?string
	mobile  ?string
	web     ?string
}

pub struct Activity {
pub:
	name           string
	activity_type  int @[json: 'type']
	url            ?string
	created_at     int
	timestamps     ?ActivityTimestamps
	application_id ?string
	details        ?string
	state          ?string
	emoji          ?ActivityEmoji
	party          ?ActivityParty
	assets         ?ActivityAssets
	secrets        ?ActivitySecrets
	instance       ?bool
	flags          ?int
	buttons        ?[]ActivityButton
}

pub struct ActivityTimestamps {
pub:
	start ?int
	end   ?int
}

pub struct ActivityEmoji {
pub:
	name     string
	id       ?string
	animated ?bool
}

pub struct ActivityParty {
pub:
	id   ?string
	size ?[]int
}

pub struct ActivityAssets {
pub:
	large_image ?string
	large_text  ?string
	small_image ?string
	small_text  ?string
}

pub struct ActivitySecrets {
pub:
	join     ?string
	spectate ?string
	match_   ?string @[json: 'match']
}

pub struct ActivityButton {
pub:
	label string
	url   string
}

pub struct InteractionCreateEvent {
pub:
	id                             string
	application_id                 string
	interaction_type               int @[json: 'type']
	data                           ?InteractionData
	guild_id                       ?string
	channel                        ?Channel
	channel_id                     ?string
	member                         ?GuildMember
	user                           ?User
	token                          string
	version                        int
	message                        ?Message
	app_permissions                ?string
	locale                         ?string
	guild_locale                   ?string
	entitlements                   ?[]Entitlement
	authorizing_integration_owners ?map[string]string
	context                        ?int
}

pub struct InteractionData {
pub:
	// Application Command Data
	id        ?string
	name      ?string
	data_type ?int @[json: 'type']
	resolved  ?ResolvedData
	options   ?[]ApplicationCommandInteractionDataOption
	guild_id  ?string
	target_id ?string
	// Message Component & Modal Submit Data
	custom_id      ?string
	component_type ?int
	values         ?[]string
	components     ?[]MessageComponent
}

pub struct ApplicationCommandInteractionDataOption {
pub:
	name        string
	option_type int @[json: 'type']
	value       ?string // Note: Discord sends string, int, f64, or bool depending on option_type
	options     ?[]ApplicationCommandInteractionDataOption
	focused     ?bool
}

pub struct InviteCreateEvent {
pub:
	channel_id  string
	code        string
	created_at  string
	guild_id    ?string
	inviter     ?User
	max_age     int
	max_uses    int
	target_type ?int
	target_user ?User
	temporary   bool
	uses        int
}

pub struct InviteDeleteEvent {
pub:
	channel_id string
	guild_id   ?string
	code       string
}

pub struct ApplicationCommandPermissionsUpdateEvent {
pub:
	id             string
	application_id string
	guild_id       string
	permissions    []ApplicationCommandPermission
}

pub struct ApplicationCommandPermission {
pub:
	id         string
	perm_type  int @[json: 'type']
	permission bool
}

pub struct SubscriptionEvent {
pub:
	id                   string
	user_id              string
	sku_ids              []string
	entitlement_ids      []string
	current_period_start string
	current_period_end   string
	status               int
	canceled_at          ?string
	country              ?string
}

pub struct GuildBanEvent {
pub:
	guild_id string
	user     User
}

pub struct GuildMemberRemoveEvent {
pub:
	guild_id string
	user     User
}

pub struct GuildMembersChunkEvent {
pub:
	guild_id    string
	members     []GuildMember
	chunk_index int
	chunk_count int
	not_found   ?[]string
	presences   ?[]PresenceUpdateEvent
	nonce       ?string
}

pub struct GuildRoleEvent {
pub:
	guild_id string
	role     Role
}

pub struct ScheduledEventUserEvent {
pub:
	guild_scheduled_event_id string
	user_id                  string
	guild_id                 string
	member                   ?GuildMember
}

pub struct IntegrationEvent {
pub:
	guild_id       string
	id             string
	application_id ?string
}

pub struct WebhooksUpdateEvent {
pub:
	guild_id   string
	channel_id string
}

pub struct StageInstanceEvent {
pub:
	guild_id       string
	stage_instance StageInstance
}

pub struct AutoModerationActionExecutionEvent {
pub:
	guild_id                string
	action                  AutoModerationAction
	rule_id                 string
	rule_trigger_type       int
	user_id                 string
	channel_id              ?string
	message_id              ?string
	alert_system_message_id ?string
	content                 string
	matched_keyword         ?string
	matched_content         ?string
}

pub struct SoundboardSoundsUpdateEvent {
pub:
	guild_id          string
	soundboard_sounds []SoundboardSound
}

pub struct VoiceChannelEffectSendEvent {
pub:
	guild_id     ?string
	channel_id   string
	user_id      string
	emoji        ?Emoji
	sound_id     ?string
	sound_volume ?f64
}

pub struct ThreadCreateEvent {
pub:
	id              string
	guild_id        ?string
	parent_id       ?string
	owner_id        ?string
	channel_type    int @[json: 'type']
	name            ?string
	thread_metadata ?ThreadMetadata
	member          ?ThreadMember
	newly_created   ?bool
}

pub struct ThreadUpdateEvent {
pub:
	id              string
	guild_id        ?string
	parent_id       ?string
	owner_id        ?string
	channel_type    int @[json: 'type']
	name            ?string
	thread_metadata ?ThreadMetadata
	member_count    ?int
	message_count   ?int
}

pub struct ThreadDeleteEvent {
pub:
	id           string
	guild_id     ?string
	parent_id    ?string
	channel_type int @[json: 'type']
}

pub struct GuildDeleteEvent {
pub:
	id          string
	unavailable ?bool
}

pub struct GuildAuditLogEntryCreateEvent {
pub:
	guild_id    string
	user_id     ?string
	id          string
	action_type int
	target_id   ?string
	changes     ?[]AuditLogChange
	options     ?OptionalAuditEntryInfo
	reason      ?string
}

pub struct GuildEmojisUpdateEvent {
pub:
	guild_id string
	emojis   []Emoji
}

pub struct GuildStickersUpdateEvent {
pub:
	guild_id string
	stickers []Sticker
}

pub struct GuildIntegrationsUpdateEvent {
pub:
	guild_id string
}

pub struct UserUpdateEvent {
pub:
	user User
}

pub struct MessageReactionRemoveEvent {
pub:
	user_id    ?string
	channel_id string
	message_id string
	guild_id   ?string
	emoji      Emoji
	member     ?GuildMember
}

pub struct GuildScheduledEventCreateEvent {
pub:
	id                   string
	guild_id             string
	channel_id           ?string
	creator_id           ?string
	name                 string
	description          ?string
	scheduled_start_time string
	scheduled_end_time   ?string
	privacy_level        int
	status               int
	entity_type          int
	entity_id            ?string
	entity_metadata      ?GuildScheduledEventEntityMetadata
	creator              ?User
	user_count           ?int
	image                ?string
}

pub struct GuildScheduledEventUpdateEvent {
pub:
	guild_scheduled_event GuildScheduledEvent
}

pub struct GuildScheduledEventDeleteEvent {
pub:
	guild_scheduled_event GuildScheduledEvent
}

pub struct GuildRoleDeleteEvent {
pub:
	guild_id string
	role_id  string
}

pub struct GuildMemberAddEvent {
pub:
	guild_id                     string
	user                         User
	nick                         ?string
	avatar                       ?string
	roles                        []string
	joined_at                    string
	premium_since                ?string
	deaf                         bool
	mute                         bool
	flags                        int
	pending                      ?bool
	permissions                  ?string
	communication_disabled_until ?string
}

pub struct GuildMemberUpdateEvent {
pub:
	guild_id                     string
	roles                        []string
	user                         User
	nick                         ?string
	avatar                       ?string
	joined_at                    ?string
	premium_since                ?string
	deaf                         ?bool
	mute                         ?bool
	pending                      ?bool
	communication_disabled_until ?string
}

pub struct GuildRoleCreateEvent {
pub:
	guild_id string
	role     Role
}

pub struct GuildRoleUpdateEvent {
pub:
	guild_id string
	role     Role
}

pub struct MessagePollVoteRemoveEvent {
pub:
	user_id    string
	channel_id string
	message_id string
	guild_id   ?string
	answer_id  int
}

pub struct GuildScheduledEventUserAddEvent {
pub:
	guild_scheduled_event_id string
	user_id                  string
	guild_id                 string
}

pub struct GuildScheduledEventUserRemoveEvent {
pub:
	guild_scheduled_event_id string
	user_id                  string
	guild_id                 string
}

pub struct GuildSoundboardSoundCreateEvent {
pub:
	guild_id         string
	soundboard_sound SoundboardSound
}

pub struct GuildSoundboardSoundUpdateEvent {
pub:
	guild_id         string
	soundboard_sound SoundboardSound
}

pub struct GuildSoundboardSoundDeleteEvent {
pub:
	guild_id string
	sound_id string
}

pub struct AutoModerationRuleCreateEvent {
pub:
	auto_moderation_rule AutoModerationRule
}

pub struct AutoModerationRuleUpdateEvent {
pub:
	auto_moderation_rule AutoModerationRule
}

pub struct AutoModerationRuleDeleteEvent {
pub:
	auto_moderation_rule AutoModerationRule
}

pub struct EntitlementEvent {
pub:
	entitlement Entitlement
}

pub struct SubscriptionCreateEvent {
pub:
	subscription SubscriptionEvent
}

pub struct SubscriptionUpdateEvent {
pub:
	subscription SubscriptionEvent
}

pub struct SubscriptionDeleteEvent {
pub:
	subscription SubscriptionEvent
}

pub struct GuildCreateEvent {
pub:
	id                            string
	name                          string
	icon                          ?string
	owner                         ?bool
	owner_id                      string
	permissions                   ?string
	region                        ?string
	afk_channel_id                ?string
	afk_timeout                   int
	roles                         []Role
	emojis                        []Emoji
	features                      []string
	unavailable                   ?bool
	member_count                  int
	large                         ?bool
	members                       ?[]GuildMember
	channels                      ?[]Channel
	threads                       ?[]Channel
	presences                     ?[]PresenceUpdateEvent
	voice_states                  ?[]VoiceStateEvent
	application_id                ?string
	verification_level            int
	default_message_notifications int
	explicit_content_filter       int
	mfa_level                     int
	system_channel_id             ?string
	system_channel_flags          int
	rules_channel_id              ?string
	joined_at                     ?string
	premium_tier                  int
	premium_subscription_count    ?int
	preferred_locale              string
	description                   ?string
	max_members                   ?int
	max_presences                 ?int
	nsfw_level                    int
	stickers                      ?[]Sticker
	premium_progress_bar_enabled  bool
	incidents_data                ?IncidentsData
}

pub struct GuildUpdateEvent {
	guild GuildCreateEvent
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

pub struct ChannelInfoEvent {
pub:
	guild_id string
	channels []ChannelInfoItem
}

pub struct ChannelInfoItem {
pub:
	id            string
	status        ?string
	speaker_ids   ?[]string
	audience_size ?int
}

pub struct IntegrationCreateUpdateEvent {
pub:
	id                  string
	name                string
	integration_type    string @[json: 'type']
	enabled             bool
	syncing             ?bool
	role_id             ?string
	enable_emoticons    ?bool
	expire_behavior     ?int
	expire_grace_period ?int
	user                ?User
	account             IntegrationAccount
	synced_at           ?string
	subscriber_count    ?int
	revoked             ?bool
	application         ?IntegrationApplication
	scopes              ?[]string
	guild_id            string
}
