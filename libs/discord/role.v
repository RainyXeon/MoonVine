module discord

pub struct Role {
pub:
	id            string
	name          string
	color         int
	colors        ?RoleColors
	hoist         bool
	icon          ?string
	unicode_emoji ?string
	position      int
	permissions   string
	managed       bool
	mentionable   bool
	tags          ?RoleTags
	flags         int
}

pub struct RoleColors {
pub:
	primary_color   int
	secondary_color ?int
	tertiary_color  ?int
}

pub struct RoleTags {
pub:
	bot_id                  ?string
	integration_id          ?string
	premium_subscriber      ?bool // Note: Discord sends `null` as a boolean flag when present
	subscription_listing_id ?string
	available_for_purchase  ?bool
	guild_connections       ?bool
}

pub struct RoleEditParams {
pub mut:
	name          ?string
	permissions   ?string
	color         ?int
	hoist         ?bool
	icon          ?string
	unicode_emoji ?string
	mentionable   ?bool
}

pub struct RoleCreateParams {
pub mut:
	name          ?string
	permissions   ?string
	color         ?int
	hoist         ?bool
	icon          ?string
	unicode_emoji ?string
	mentionable   ?bool
}
