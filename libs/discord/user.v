module discord

import net.http
import json2

pub struct User {
pub:
	id                     string
	username               string
	discriminator          string
	global_name            ?string
	avatar                 ?string
	bot                    ?bool
	system                 ?bool
	mfa_enabled            ?bool
	banner                 ?string
	accent_color           ?int
	locale                 ?string
	verified               ?bool
	email                  ?string
	flags                  ?int
	premium_type           ?int
	public_flags           ?int
	avatar_decoration_data ?AvatarDecorationData
	collectibles           ?Collectibles
	primary_guild          ?UserPrimaryGuild
}

pub struct AvatarDecorationData {
pub:
	asset  string
	sku_id string
}

pub struct Collectibles {
pub:
	nameplate ?Nameplate
}

pub struct Nameplate {
pub:
	sku_id  string
	asset   string
	label   string
	palette string
}

pub struct UserPrimaryGuild {
pub:
	identity_guild_id ?string
	identity_enabled  ?bool
	tag               ?string
	badge             ?string
}

pub struct Connection {
pub:
	id            string
	name          string
	service_type  string @[json: 'type']
	revoked       ?bool
	integrations  ?[]Integration
	verified      bool
	friend_sync   bool
	show_activity bool
	two_way_link  bool
	visibility    int
}

pub struct EditUserMeParams {
pub mut:
	username ?string
	avatar   ?ImageData
	banner   ?ImageData
}

@[heap]
pub struct Class_Users {
mut:
	cached_res ?User
pub:
	endpoint string = '/users'
pub mut:
	me               Class_Users_Me
	identity_profile &Class_ApplicationIdentityProfile = unsafe { nil }
	bc               &Class_BotClient
}

pub fn new_class_users(bc &Class_BotClient) &Class_Users {
	mut users := &Class_Users{
		bc: bc
		me: Class_Users_Me{}
	}
	users.me.users = users
	users.identity_profile = new_class_application_identity_profile(users)
	return users
}

pub fn (mut this Class_Users) fetch(user_id string) !User {
	res := this.bc.raw_request(.get, '${this.endpoint}/${user_id}', http.FetchConfig{}) or {
		return err
	}

	json_data := decode_response[User](res)!

	return json_data
}

pub struct Class_Users_Me {
pub mut:
	users &Class_Users = unsafe { nil }
}

pub fn (mut this Class_Users_Me) fetch() !User {
	res := this.users.bc.raw_request(.get, '${this.users.endpoint}/@me', http.FetchConfig{}) or {
		return err
	}

	json_data := decode_response[User](res)!

	return json_data
}

pub fn (mut this Class_Users_Me) fetch_connections() ![]Connection {
	if !this.users.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	mut header := http.new_header()
	header.add(.authorization, this.users.bc.token)
	res := this.users.bc.raw_request(.get, '${this.users.endpoint}/@me/connections', http.FetchConfig{ header: header }) or {
		return err
	}

	json_data := decode_response_list[Connection](res)!

	return json_data
}

pub fn (mut this Class_Users_Me) edit(data EditUserMeParams) !User {
	if !this.users.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	mut header := http.new_header()
	header.add(.authorization, this.users.bc.token)
	res := this.users.bc.raw_request(.patch, '${this.users.endpoint}/@me', http.FetchConfig{ header: header, data: json2.encode(data) }) or {
		return err
	}

	json_data := decode_response[User](res)!

	return json_data
}

// fetch_application_role_connection retrieves the current user's role connection
// for an application. This endpoint requires a user OAuth2 token, not a bot token.
pub fn (this &Class_Users_Me) fetch_application_role_connection(application_id string) !ApplicationRoleConnection {
	if !this.users.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	mut header := http.new_header()
	header.add(.authorization, this.users.bc.token)
	res := this.users.bc.raw_request(.get, '${this.users.endpoint}/@me/applications/${application_id}/role-connection', http.FetchConfig{ header: header })!
	return decode_response[ApplicationRoleConnection](res)
}

// set_application_role_connection sets the current user's role connection for
// an application. This endpoint requires a user OAuth2 token, not a bot token.
pub fn (this &Class_Users_Me) set_application_role_connection(application_id string, connection ApplicationRoleConnection) !ApplicationRoleConnection {
	if !this.users.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	mut header := http.new_header()
	header.add(.authorization, this.users.bc.token)
	res := this.users.bc.raw_request(.put, '${this.users.endpoint}/@me/applications/${application_id}/role-connection', http.FetchConfig{
		header: header
		data:   json2.encode(connection)
	})!
	return decode_response[ApplicationRoleConnection](res)
}

// fetch_identity_profile retrieves the authenticated user identity profile.
// The configured token must be a user OAuth2 access token.
pub fn (this &Class_Users_Me) fetch_identity_profile() !User {
	return this.fetch()
}
