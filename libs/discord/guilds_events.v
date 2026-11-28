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
pub mut:
	client ?&Client @[skip]
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

pub fn (mut m GuildMemberAddEvent) bind(client &Client) {
	m.client = client
}

pub fn (m &GuildMemberAddEvent) add_role(role_id string, reason ?string) ! {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	c.guilds.add_member_role(m.guild_id, m.user.id, role_id, reason)!
}

pub fn (m &GuildMemberAddEvent) remove_role(role_id string, reason ?string) ! {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	c.guilds.remove_member_role(m.guild_id, m.user.id, role_id, reason)!
}

pub fn (m &GuildMemberAddEvent) kick(reason ?string) ! {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	c.guilds.remove_member(m.guild_id, m.user.id, reason)!
}

pub fn (m &GuildMemberAddEvent) ban(delete_message_seconds ?int, reason ?string) ! {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	c.guilds.create_ban(m.guild_id, m.user.id, delete_message_seconds, reason)!
}

pub fn (m &GuildMemberAddEvent) timeout(until ?string, reason ?string) !GuildMember {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	return c.guilds.modify_member(m.guild_id, m.user.id, GuildMemberModifyParams{
		communication_disabled_until: until
	}, reason)
}

pub fn (m &GuildMemberAddEvent) set_nickname(nick ?string, reason ?string) !GuildMember {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	return c.guilds.modify_member(m.guild_id, m.user.id, GuildMemberModifyParams{
		nick: nick
	}, reason)
}

pub fn (m &GuildMemberAddEvent) send_dm(payload MessagePayload) !Message {
	c := m.client or { return error('GuildMemberAddEvent is not bound to a Client') }
	dm := c.users.create_dm(m.user.id)!
	return c.channels.send_message(dm.id, payload.to_params())
}

pub fn (m &GuildMemberAddEvent) display_name() string {
	return m.nick or { m.user.global_name or { m.user.username } }
}

pub struct GuildMemberUpdateEvent {
pub mut:
	client ?&Client @[skip]
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

pub fn (mut m GuildMemberUpdateEvent) bind(client &Client) {
	m.client = client
}

pub fn (m &GuildMemberUpdateEvent) add_role(role_id string, reason ?string) ! {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	c.guilds.add_member_role(m.guild_id, m.user.id, role_id, reason)!
}

pub fn (m &GuildMemberUpdateEvent) remove_role(role_id string, reason ?string) ! {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	c.guilds.remove_member_role(m.guild_id, m.user.id, role_id, reason)!
}

pub fn (m &GuildMemberUpdateEvent) kick(reason ?string) ! {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	c.guilds.remove_member(m.guild_id, m.user.id, reason)!
}

pub fn (m &GuildMemberUpdateEvent) ban(delete_message_seconds ?int, reason ?string) ! {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	c.guilds.create_ban(m.guild_id, m.user.id, delete_message_seconds, reason)!
}

pub fn (m &GuildMemberUpdateEvent) timeout(until ?string, reason ?string) !GuildMember {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	return c.guilds.modify_member(m.guild_id, m.user.id, GuildMemberModifyParams{
		communication_disabled_until: until
	}, reason)
}

pub fn (m &GuildMemberUpdateEvent) set_nickname(nick ?string, reason ?string) !GuildMember {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	return c.guilds.modify_member(m.guild_id, m.user.id, GuildMemberModifyParams{
		nick: nick
	}, reason)
}

pub fn (m &GuildMemberUpdateEvent) send_dm(payload MessagePayload) !Message {
	c := m.client or { return error('GuildMemberUpdateEvent is not bound to a Client') }
	dm := c.users.create_dm(m.user.id)!
	return c.channels.send_message(dm.id, payload.to_params())
}

pub fn (m &GuildMemberUpdateEvent) display_name() string {
	return m.nick or { m.user.global_name or { m.user.username } }
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
pub mut:
	client   ?&Client @[skip]
	channels ?[]Channel
	threads  ?[]Channel
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

pub fn (mut g GuildCreateEvent) bind(client &Client) {
	g.client = client
	if mut chs := g.channels {
		for mut ch in chs {
			ch.client = client
		}
		g.channels = chs
	}
	if mut ths := g.threads {
		for mut th in ths {
			th.client = client
		}
		g.threads = ths
	}
}

pub fn (g &GuildCreateEvent) leave() ! {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	c.users.leave_guild(g.id)!
}

pub fn (g &GuildCreateEvent) fetch_channels() ![]Channel {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	return c.guilds.fetch_channels(g.id)
}

pub fn (g &GuildCreateEvent) create_channel(params ChannelCreateParams, reason ?string) !Channel {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	return c.guilds.create_channel(g.id, params, reason)
}

pub fn (g &GuildCreateEvent) fetch_roles() ![]Role {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	return c.guilds.fetch_roles(g.id)
}

pub fn (g &GuildCreateEvent) fetch_member(user_id string) !GuildMember {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	return c.guilds.fetch_member(g.id, user_id)
}

pub fn (g &GuildCreateEvent) kick(user_id string, reason ?string) ! {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	c.guilds.remove_member(g.id, user_id, reason)!
}

pub fn (g &GuildCreateEvent) ban(user_id string, delete_message_seconds ?int, reason ?string) ! {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	c.guilds.create_ban(g.id, user_id, delete_message_seconds, reason)!
}

pub fn (g &GuildCreateEvent) unban(user_id string, reason ?string) ! {
	c := g.client or { return error('GuildCreateEvent is not bound to a Client') }
	c.guilds.remove_ban(g.id, user_id, reason)!
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
