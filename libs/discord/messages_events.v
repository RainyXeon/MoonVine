module discord

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

pub struct MessageReactionRemoveEvent {
pub:
	user_id    ?string
	channel_id string
	message_id string
	guild_id   ?string
	emoji      Emoji
	member     ?GuildMember
}

pub struct MessagePollVoteRemoveEvent {
pub:
	user_id    string
	channel_id string
	message_id string
	guild_id   ?string
	answer_id  int
}
