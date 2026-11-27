module discord

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

pub struct UserUpdateEvent {
pub:
	user User
}

pub struct IntegrationEvent {
pub:
	guild_id       string
	id             string
	application_id ?string
}

pub struct ScheduledEventUserEvent {
pub:
	guild_scheduled_event_id string
	user_id                  string
	guild_id                 string
	member                   ?GuildMember
}
