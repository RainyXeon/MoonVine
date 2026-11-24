module discord

import net.http
import json2

// INFO: Global Struct
pub struct Application {
pub:
	bot_public                        bool
	bot_require_code_grant            bool
	cover_image                       ?string
	description                       string
	flags                             int
	flags_new                         string
	guild_id                          ?string
	icon                              ?string
	id                                string
	integration_types_config          map[string]IntegrationTypeConfig
	name                              string
	interactions_endpoint_url         ?string
	role_connections_verification_url ?string
	event_webhooks_url                ?string
	event_webhooks_status             int
	owner                             ?ApplicationUser
	primary_sku_id                    ?string
	slug                              ?string
	team                              ?Team
	verify_key                        string
}

pub struct IntegrationTypeConfig {
pub:
	oauth2_install_params ?OAuth2InstallParams
}

pub struct OAuth2InstallParams {
pub:
	scopes      []string
	permissions string
}

pub struct ApplicationUser {
pub:
	avatar        ?string
	discriminator string
	flags         ?int // Optional because it's present in `owner`, but omitted in `team.members[].user`
	id            string
	username      string
}

pub struct Team {
pub:
	name          string
	icon          ?string
	id            string
	owner_user_id string
	members       []TeamMember
}

pub struct TeamMember {
pub:
	membership_state int
	permissions      []string
	team_id          string
	user             User
}

pub struct ActivityInstance {
pub:
	application_id string
	instance_id    string
	launch_id      string
	location       ActivityLocation
	users          []string
}

pub struct ActivityLocation {
pub:
	id         string
	kind       string
	channel_id string
	guild_id   ?string // Optional because guild_id is omitted when kind is "pc" (private/DM channel)
}

pub struct EditCurrentApplicationParams {
pub mut:
	custom_install_url                ?string
	description                       ?string
	role_connections_verification_url ?string
	install_params                    ?InstallParams
	integration_types_config          ?map[string]IntegrationTypeConfig
	flags                             ?int
	icon                              ?string // Data URI scheme (e.g. data:image/png;base64,...)
	cover_image                       ?string // Data URI scheme
	interactions_endpoint_url         ?string
	tags                              ?[]string // Max 5 tags, max 20 characters each
	event_webhooks_url                ?string
	event_webhooks_status             ?int
	event_webhooks_types              ?[]string
}

pub struct InstallParams {
pub mut:
	scopes      []string
	permissions string
}

// INFO: Route /application
@[heap]
pub struct Class_Application {
mut:
	cached_res ?Application
pub:
	endpoint string = '/applications'
pub mut:
	bc &Class_BotClient
}

pub fn new_application(bc &Class_BotClient) &Class_Application {
	mut app := &Class_Application{ bc: bc }
	return app
}

pub fn (mut this Class_Application) fetch() !Application {
	res := this.bc.raw_request(.get, '${this.endpoint}/@me', http.FetchConfig{}) or {
		return err
	}

	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}

	json_data := json2.decode[Application](res.body) or {
		return err
	}

	if this.cached_res == none {
		this.cached_res = json_data
	}

	return json_data
}

pub fn (mut this Class_Application) edit(data EditCurrentApplicationParams) !Application {
	res := this.bc.raw_request(.patch, '${this.endpoint}/@me', http.FetchConfig{ data: json2.encode(data) }) or {
		return err
	}

	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}

	json_data := json2.decode[Application](res.body) or {
		return err
	}

	if this.cached_res == none {
		this.cached_res = json_data
	}

	return json_data
}

pub fn (mut this Class_Application) fetch_activity_instance(instance_id string) !ActivityInstance {
	mut application_data := this.cached_res

	if application_data == none {
		application_data = this.fetch() or {
			return err
		}
	}

	res := this.bc.raw_request(.get, '${this.endpoint}/${application_data?.id}/activity-instances/${instance_id}', http.FetchConfig{}) or {
		return err
	}

	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}

	json_data := json2.decode[ActivityInstance](res.body) or {
		return err
	}

	return json_data
}
