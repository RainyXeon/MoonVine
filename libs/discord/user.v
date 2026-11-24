module discord

import net.http
import json2

// INFO: Global struct
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

pub struct EditUserMeParams {
	username ?string
	avatar   ?ImageData
	banner   ?ImageData
}

// INFO: Route /application
@[heap]
pub struct Class_Users {
mut:
	cached_res ?User
pub:
	endpoint string = '/users'
pub mut:
	me Class_Users_Me
	bc &Class_BotClient
}

pub fn new_users(bc &Class_BotClient) &Class_Users {
	mut users := &Class_Users{
		bc: bc
		me: Class_Users_Me{}
	}
	users.me.users = users
	return users
}

pub fn (mut this Class_Users) fetch(user_id string) !User {
	res := this.bc.raw_request(.get, '${this.endpoint}/${user_id}', http.FetchConfig{}) or {
		return err
	}

	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}

	json_data := json2.decode[User](res.body) or {
		return err
	}

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

	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}

	json_data := json2.decode[User](res.body) or {
		return err
	}

	return json_data
}

pub fn (mut this Class_Users_Me) edit(data EditUserMeParams) !User {
	res := this.users.bc.raw_request(.patch, '${this.users.endpoint}/@me', http.FetchConfig{ data: json2.encode(data) }) or {
		return err
	}

	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}

	json_data := json2.decode[User](res.body) or {
		return err
	}

	return json_data
}
