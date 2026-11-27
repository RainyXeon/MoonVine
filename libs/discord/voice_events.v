module discord

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

pub struct VoiceChannelEffectSendEvent {
pub:
	guild_id     ?string
	channel_id   string
	user_id      string
	emoji        ?Emoji
	sound_id     ?string
	sound_volume ?f64
}

pub struct SoundboardSoundsUpdateEvent {
pub:
	guild_id          string
	soundboard_sounds []SoundboardSound
}
