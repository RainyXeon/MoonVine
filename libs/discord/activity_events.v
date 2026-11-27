module discord

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

pub enum PresenceStatus {
	online
	dnd
	idle
	invisible
}

pub enum ActivityType {
	game      = 0
	streaming = 1
	listening = 2
	watching  = 3
	custom    = 4
	competing = 5
}

pub struct PresenceActivity {
pub mut:
	name          string
	activity_type int @[json: 'type']
	url           ?string
}

pub fn new_presence_activity(name string, activity_type ActivityType) PresenceActivity {
	return PresenceActivity{
		name:          name
		activity_type: int(activity_type)
	}
}

pub struct PresenceUpdateParams {
pub mut:
	activities []PresenceActivity
	status     PresenceStatus = .online
	since      ?i64
	afk        bool
}

pub fn (status PresenceStatus) str() string {
	return match status {
		.online { 'online' }
		.dnd { 'dnd' }
		.idle { 'idle' }
		.invisible { 'invisible' }
	}
}
