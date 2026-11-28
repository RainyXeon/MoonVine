module discord

import x.json2
import net.http

pub struct InteractionData {
pub:
	id             ?string
	name           ?string
	command_type   ?int @[json: 'type']
	resolved       ?ResolvedData
	options        ?[]InteractionDataOption
	guild_id       ?string
	target_id      ?string
	custom_id      ?string
	component_type ?int
	values         ?[]string
	components     ?[]MessageComponent
}

pub struct InteractionDataOption {
pub:
	name        string
	option_type int @[json: 'type']
	value       ?json2.Any
	options     ?[]InteractionDataOption
	focused     ?bool
}

pub struct InteractionResponse {
pub mut:
	response_type int @[json: 'type']
	data          ?InteractionCallbackData
}

pub struct InteractionCallbackData {
pub mut:
	tts              ?bool
	content          ?string
	embeds           ?[]Embed
	allowed_mentions ?AllowedMentions
	flags            ?int
	components       ?[]MessageComponent
	attachments      ?[]PartialAttachment
	choices          ?[]ApplicationCommandOptionChoice
	custom_id        ?string
	title            ?string
	poll             ?Poll
}

pub struct ApplicationCommandCreateParams {
pub mut:
	name                       string
	name_localizations         ?map[string]string
	description                ?string
	description_localizations  ?map[string]string
	options                    ?[]ApplicationCommandOption
	default_member_permissions ?string
	dm_permission              ?bool
	default_permission         ?bool
	command_type               ?int @[json: 'type']
	nsfw                       ?bool
	integration_types          ?[]int
	contexts                   ?[]int
}

pub struct ApplicationCommandEditParams {
pub mut:
	name                       ?string
	name_localizations         ?map[string]string
	description                ?string
	description_localizations  ?map[string]string
	options                    ?[]ApplicationCommandOption
	default_member_permissions ?string
	dm_permission              ?bool
	default_permission         ?bool
	nsfw                       ?bool
	integration_types          ?[]int
	contexts                   ?[]int
}

@[heap]
pub struct InteractionClient {
pub:
	endpoint string = '/interactions'
pub mut:
	bc &Client
}

pub fn new_interaction_client(bc &Client) &InteractionClient {
	return &InteractionClient{
		bc: bc
	}
}

pub fn (this &InteractionClient) create_response(interaction_id string, interaction_token string, response InteractionResponse) ! {
	res := this.bc.raw_request(.post, '${this.endpoint}/${interaction_id}/${interaction_token}/callback', http.FetchConfig{
		data: json2.encode(response)
	})!
	check_response(res)!
}

pub fn (this &InteractionClient) fetch_original_response(application_id string, interaction_token string) !Message {
	res := this.bc.raw_request(.get, '/webhooks/${application_id}/${interaction_token}/messages/@original', http.FetchConfig{})!
	mut msg := decode_response[Message](res)!
	msg.client = this.bc
	return msg
}

pub fn (this &InteractionClient) edit_original_response(application_id string, interaction_token string, params EditMessageParams) !Message {
	res := this.bc.raw_request(.patch, '/webhooks/${application_id}/${interaction_token}/messages/@original', http.FetchConfig{
		data: json2.encode(params)
	})!
	mut msg := decode_response[Message](res)!
	msg.client = this.bc
	return msg
}

pub fn (this &InteractionClient) delete_original_response(application_id string, interaction_token string) ! {
	res := this.bc.raw_request(.delete, '/webhooks/${application_id}/${interaction_token}/messages/@original', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &InteractionClient) create_followup(application_id string, interaction_token string, params CreateMessageParams) !Message {
	res := this.bc.raw_request(.post, '/webhooks/${application_id}/${interaction_token}', http.FetchConfig{
		data: json2.encode(params)
	})!
	mut msg := decode_response[Message](res)!
	msg.client = this.bc
	return msg
}

pub fn (this &InteractionClient) fetch_followup(application_id string, interaction_token string, message_id string) !Message {
	res := this.bc.raw_request(.get, '/webhooks/${application_id}/${interaction_token}/messages/${message_id}', http.FetchConfig{})!
	mut msg := decode_response[Message](res)!
	msg.client = this.bc
	return msg
}

pub fn (this &InteractionClient) edit_followup(application_id string, interaction_token string, message_id string, params EditMessageParams) !Message {
	res := this.bc.raw_request(.patch, '/webhooks/${application_id}/${interaction_token}/messages/${message_id}', http.FetchConfig{
		data: json2.encode(params)
	})!
	mut msg := decode_response[Message](res)!
	msg.client = this.bc
	return msg
}

pub fn (this &InteractionClient) delete_followup(application_id string, interaction_token string, message_id string) ! {
	res := this.bc.raw_request(.delete, '/webhooks/${application_id}/${interaction_token}/messages/${message_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &InteractionClient) fetch_global_commands(application_id string) ![]ApplicationCommand {
	res := this.bc.raw_request(.get, '/applications/${application_id}/commands', http.FetchConfig{})!
	return decode_response_list[ApplicationCommand](res)
}

pub fn (this &InteractionClient) create_global_command(application_id string, params ApplicationCommandCreateParams) !ApplicationCommand {
	res := this.bc.raw_request(.post, '/applications/${application_id}/commands', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[ApplicationCommand](res)
}

pub fn (this &InteractionClient) bulk_overwrite_global_commands(application_id string, commands []ApplicationCommandCreateParams) ![]ApplicationCommand {
	res := this.bc.raw_request(.put, '/applications/${application_id}/commands', http.FetchConfig{
		data: json2.encode(commands)
	})!
	return decode_response_list[ApplicationCommand](res)
}

pub fn (this &InteractionClient) delete_global_command(application_id string, command_id string) ! {
	res := this.bc.raw_request(.delete, '/applications/${application_id}/commands/${command_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &InteractionClient) fetch_guild_commands(application_id string, guild_id string) ![]ApplicationCommand {
	res := this.bc.raw_request(.get, '/applications/${application_id}/guilds/${guild_id}/commands', http.FetchConfig{})!
	return decode_response_list[ApplicationCommand](res)
}

pub fn (this &InteractionClient) create_guild_command(application_id string, guild_id string, params ApplicationCommandCreateParams) !ApplicationCommand {
	res := this.bc.raw_request(.post, '/applications/${application_id}/guilds/${guild_id}/commands', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[ApplicationCommand](res)
}

pub fn (this &InteractionClient) bulk_overwrite_guild_commands(application_id string, guild_id string, commands []ApplicationCommandCreateParams) ![]ApplicationCommand {
	res := this.bc.raw_request(.put, '/applications/${application_id}/guilds/${guild_id}/commands', http.FetchConfig{
		data: json2.encode(commands)
	})!
	return decode_response_list[ApplicationCommand](res)
}

pub fn (this &InteractionClient) delete_guild_command(application_id string, guild_id string, command_id string) ! {
	res := this.bc.raw_request(.delete, '/applications/${application_id}/guilds/${guild_id}/commands/${command_id}', http.FetchConfig{})!
	check_response(res)!
}
