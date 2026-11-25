module discord

import net.http
import json2

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

pub struct ApplicationCommand {
pub:
	id                         string
	command_type               ?int @[json: 'type']
	application_id             string
	guild_id                   ?string
	name                       string
	name_localizations         ?map[string]string
	description                string
	description_localizations  ?map[string]string
	options                    ?[]ApplicationCommandOption
	default_member_permissions ?string
	dm_permission              ?bool
	default_permission         ?bool
	nsfw                       ?bool
	integration_types          ?[]int
	contexts                   ?[]int
	version                    string
	handler                    ?int
}

pub struct ApplicationCommandOption {
pub:
	option_type               int @[json: 'type']
	name                      string
	name_localizations        ?map[string]string
	description               string
	description_localizations ?map[string]string
	required                  ?bool
	choices                   ?[]ApplicationCommandOptionChoice
	options                   ?[]ApplicationCommandOption
	channel_types             ?[]int
	min_value                 ?f64
	max_value                 ?f64
	min_length                ?int
	max_length                ?int
	autocomplete              ?bool
}

pub struct ApplicationCommandOptionChoice {
pub:
	name               string
	name_localizations ?map[string]string
	value              string // Can be string, int, or double in Discord JSON
}

pub struct ApplicationRoleConnection {
pub:
	platform_name     ?string
	platform_username ?string
	metadata          map[string]json2.Any
}

pub struct ApplicationRoleConnectionMetadata {
pub:
	id                        string
	type                      int @[json: 'type']
	key                       string
	name                      string
	description               string
	name_localizations        ?map[string]string
	description_localizations ?map[string]string
}

// ApplicationRoleConnectionMetadataType is the Discord metadata value type.
pub enum ApplicationRoleConnectionMetadataType {
	integer  = 1
	boolean  = 2
	datetime = 3
	number   = 4
}

pub struct EditApplicationRoleConnectionMetadata {
pub mut:
	type                      int @[json: 'type']
	key                       string
	name                      string
	description               string
	name_localizations        ?map[string]string
	description_localizations ?map[string]string
}

@[heap]
pub struct Class_Application {
mut:
	cached_res ?Application
pub:
	endpoint string = '/applications'
pub mut:
	bc &Class_BotClient
}

pub fn new_class_application(bc &Class_BotClient) &Class_Application {
	mut app := &Class_Application{ bc: bc }
	return app
}

pub fn (mut this Class_Application) fetch() !Application {
	res := this.bc.raw_request(.get, '${this.endpoint}/@me', http.FetchConfig{}) or {
		return err
	}

	json_data := decode_response[Application](res)!

	this.cached_res = json_data

	return json_data
}

pub fn (mut this Class_Application) edit(data EditCurrentApplicationParams) !Application {
	res := this.bc.raw_request(.patch, '${this.endpoint}/@me', http.FetchConfig{ data: json2.encode(data) }) or {
		return err
	}

	json_data := decode_response[Application](res)!

	this.cached_res = json_data

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

	json_data := decode_response[ActivityInstance](res)!

	return json_data
}

// fetch_role_connection_metadata retrieves an application's role connection
// metadata definitions.
pub fn (this &Class_Application) fetch_role_connection_metadata(application_id string) ![]ApplicationRoleConnectionMetadata {
	res := this.bc.raw_request(.get, '${this.endpoint}/${application_id}/role-connections/metadata', http.FetchConfig{})!
	return decode_response_list[ApplicationRoleConnectionMetadata](res)
}

// edit_role_connection_metadata updates an application's metadata definitions.
pub fn (this &Class_Application) edit_role_connection_metadata(application_id string, metadata []EditApplicationRoleConnectionMetadata) ![]ApplicationRoleConnectionMetadata {
	res := this.bc.raw_request(.put, '${this.endpoint}/${application_id}/role-connections/metadata', http.FetchConfig{
		data: json2.encode(metadata)
	})!
	return decode_response_list[ApplicationRoleConnectionMetadata](res)
}

// fetch_application_role_connection is the endpoint alias on the application
// resource for application-centric SDK usage.
pub fn (this &Class_Application) fetch_user_role_connection() !ApplicationRoleConnection {
	mut user_me := this.bc.users.me
	application := this.fetch()!
	return user_me.fetch_application_role_connection(application.id)
}

pub struct Class_ApplicationIdentityProfile {
pub mut:
	users &Class_Users
}

pub fn new_class_application_identity_profile(users &Class_Users) &Class_ApplicationIdentityProfile {
	return &Class_ApplicationIdentityProfile{ users: users }
}

pub fn (this &Class_ApplicationIdentityProfile) fetch() !User {
	return this.users.me.fetch_identity_profile()
}

pub fn (this &Class_ApplicationIdentityProfile) fetch_connections() ![]Connection {
	return this.users.me.fetch_connections()
}

pub fn (this &Class_ApplicationIdentityProfile) fetch_role_connection(application_id string) !ApplicationRoleConnection {
	return this.users.me.fetch_application_role_connection(application_id)
}

pub fn (this &Class_ApplicationIdentityProfile) set_role_connection(application_id string, connection ApplicationRoleConnection) !ApplicationRoleConnection {
	return this.users.me.set_application_role_connection(application_id, connection)
}
