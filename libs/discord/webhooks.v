module discord

import net.http
import json2
import net.urllib

pub struct Webhook {
pub:
	id             string
	webhook_type   int @[json: 'type']
	guild_id       ?string
	channel_id     ?string
	user           ?User
	name           ?string
	avatar         ?string
	token          ?string
	application_id ?string
	source_guild   ?PartialWebhookGuild
	source_channel ?PartialWebhookChannel
	url            ?string
}

pub struct PartialWebhookGuild {
pub:
	id   string
	name string
	icon ?string
}

pub struct PartialWebhookChannel {
pub:
	id   string
	name string
}

pub struct CreateWebhookParams {
pub mut:
	name   string
	avatar ?string
}

pub struct EditWebhookParams {
pub mut:
	name       ?string
	avatar     ?string
	channel_id ?string
}

pub struct ExecuteWebhookParams {
pub mut:
	content          ?string
	username         ?string
	avatar_url       ?string
	tts              ?bool
	embeds           ?[]Embed
	allowed_mentions ?AllowedMentions
	components       ?[]MessageComponent
}

@[heap]
pub struct WebhookClient {
pub:
	endpoint string = '/webhooks'
pub mut:
	bc &Client
}

pub fn new_webhook_client(bc &Client) &WebhookClient {
	return &WebhookClient{ bc: bc }
}

pub fn (this &WebhookClient) fetch(webhook_id string) !Webhook {
	res := this.bc.raw_request(.get, '${this.endpoint}/${webhook_id}', http.FetchConfig{})!
	return decode_response[Webhook](res)
}

pub fn (this &WebhookClient) execute(webhook_id string, token string, params ExecuteWebhookParams) !Message {
	res := this.bc.raw_request(.post, '${this.endpoint}/${webhook_id}/${token}?wait=true', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[Message](res)
}

pub fn (this &WebhookClient) delete(webhook_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${webhook_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &WebhookClient) edit(webhook_id string, params EditWebhookParams, reason ?string) !Webhook {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${webhook_id}', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Webhook](res)
}
