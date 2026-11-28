module discord

import net.http
import json2

pub struct Invite {
pub:
	code                       string
	guild                      ?Guild
	channel                    ?Channel
	inviter                    ?User
	target_type                ?int
	target_user                ?User
	target_application         ?PartialInviteGuild
	approximate_presence_count ?int
	approximate_member_count   ?int
	expires_at                 ?string
	guild_scheduled_event      ?GuildScheduledEvent
	uses                       ?int
	max_uses                   ?int
	max_age                    ?int
	temporary                  ?bool
	created_at                 ?string
	max_uses_count             ?int
	is_friend                  ?bool
}

pub struct PartialInviteGuild {
pub:
	id                         string
	name                       string
	splash                     ?string
	banner                     ?string
	description                ?string
	icon                       ?string
	features                   []string
	verification_level         int
	vanity_url_code            ?string
	nsfw_level                 int
	premium_subscription_count ?int
}

pub struct CreateInviteParams {
pub mut:
	max_age                  ?int
	max_uses                 ?int
	temporary                ?bool
	unique                   ?bool
	target_type              ?int
	target_user_id           ?string
	target_application_id    ?string
	target_embedded_activity ?string
}

@[heap]
pub struct InviteClient {
pub:
	endpoint string = '/invites'
pub mut:
	bc &Client
}

pub fn new_invite_client(bc &Client) &InviteClient {
	return &InviteClient{ bc: bc }
}

pub fn (this &InviteClient) fetch(code string) !Invite {
	res := this.bc.raw_request(.get, '${this.endpoint}/${code}', http.FetchConfig{})!
	return decode_response[Invite](res)
}

pub fn (this &InviteClient) delete(code string) !Invite {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${code}', http.FetchConfig{})!
	return decode_response[Invite](res)
}

// fetch_template retrieves a guild template by code.
pub fn (this &InviteClient) fetch_template(code string) !GuildTemplate {
	res := this.bc.raw_request(.get, '/guilds/templates/${code}', http.FetchConfig{})!
	return decode_response[GuildTemplate](res)
}

pub fn (this &InviteClient) create_from_template(template_code string, name string, icon ?string) !Guild {
	mut data := map[string]string{
		'name': name
	}
	if value := icon { data['icon'] = value }
	res := this.bc.raw_request(.post, '/guilds/templates/${template_code}', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[Guild](res)
}
