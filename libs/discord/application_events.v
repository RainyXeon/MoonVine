module discord

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
