module discord

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

pub struct TypingStartEvent {
pub:
	channel_id string
	guild_id   ?string
	user_id    string
	timestamp  int
	member     ?GuildMember
}

pub struct StageInstanceEvent {
pub:
	guild_id       string
	stage_instance StageInstance
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
