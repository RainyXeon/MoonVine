module discord

import net.urllib

pub struct Message {
pub mut:
	client ?&Class_BotClient @[skip]
pub:
	id                     string
	channel_id             string
	guild_id               ?string
	author                 User
	content                string
	timestamp              string
	edited_timestamp       ?string
	tts                    bool
	mention_everyone       bool
	mentions               []User
	mention_roles          []string
	mention_channels       ?[]ChannelMention
	attachments            []Attachment
	embeds                 []Embed
	reactions              ?[]Reaction
	nonce                  ?string
	pinned                 bool
	webhook_id             ?string
	message_type           int @[json: 'type']
	activity               ?MessageActivity
	application            ?Application
	application_id         ?string
	flags                  ?int
	message_reference      ?MessageReference
	message_snapshots      ?[]MessageSnapshot
	referenced_message     ?&Message
	interaction_metadata   ?MessageInteractionMetadata
	thread                 ?Channel
	components             ?[]MessageComponent
	sticker_items          ?[]StickerItem
	position               ?int
	role_subscription_data ?RoleSubscriptionData
	resolved               ?ResolvedData
	poll                   ?Poll
	call                   ?MessageCall
}

pub type MessagePayload = string | CreateMessageParams
pub type MessageEditPayload = string | EditMessageParams

fn (p MessagePayload) to_params() CreateMessageParams {
	return match p {
		string {
			CreateMessageParams{
				content: p
			}
		}
		CreateMessageParams {
			p
		}
	}
}

fn (p MessageEditPayload) to_params() EditMessageParams {
	return match p {
		string {
			EditMessageParams{
				content: p
			}
		}
		EditMessageParams {
			p
		}
	}
}

pub fn (m &Message) send(payload MessagePayload) !Message {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	return c.channels.send_message(m.channel_id, payload.to_params())
}

pub fn (m &Message) reply(payload MessagePayload) !Message {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	mut params := payload.to_params()
	if params.message_reference == none {
		params.message_reference = MessageReference{
			message_id: m.id
			channel_id: m.channel_id
			guild_id:   m.guild_id
		}
	}
	return c.channels.send_message(m.channel_id, params)
}

pub fn (m &Message) edit(payload MessageEditPayload) !Message {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	return c.channels.edit_message(m.channel_id, m.id, payload.to_params())
}

pub fn (m &Message) reply_with(params CreateMessageParams) !Message {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	mut p := params
	if p.message_reference == none {
		p.message_reference = MessageReference{
			message_id: m.id
			channel_id: m.channel_id
			guild_id:   m.guild_id
		}
	}
	return c.channels.send_message(m.channel_id, p)
}

pub fn (m &Message) edit_with(params EditMessageParams) !Message {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	return c.channels.edit_message(m.channel_id, m.id, params)
}

pub fn (m &Message) delete() ! {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	c.channels.delete_message(m.channel_id, m.id)!
}

pub fn (m &Message) react(emoji string) ! {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	c.channels.create_reaction(m.channel_id, m.id, emoji)!
}

pub fn (m &Message) remove_reaction(emoji string) ! {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	c.channels.delete_own_reaction(m.channel_id, m.id, emoji)!
}

pub fn (m &Message) pin() ! {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	c.channels.pin_message(m.channel_id, m.id)!
}

pub fn (m &Message) unpin() ! {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	c.channels.unpin_message(m.channel_id, m.id)!
}

pub fn (m &Message) crosspost() !Message {
	c := m.client or { return error('Message is not bound to a Class_BotClient') }
	return c.channels.crosspost_message(m.channel_id, m.id)
}

pub fn (m &Message) in_guild() bool {
	return m.guild_id != none
}

pub struct MessageActivity {
pub:
	activity_type int @[json: 'type']
	party_id      ?string
}

pub struct MessageReference {
pub:
	reference_type     ?int @[json: 'type']
	message_id         ?string
	channel_id         ?string
	guild_id           ?string
	fail_if_not_exists ?bool
}

pub struct MessageSnapshot {
pub:
	message MessageSnapshotData
}

pub struct MessageSnapshotData {
pub:
	message_type     int @[json: 'type']
	content          string
	embeds           []Embed
	attachments      []Attachment
	timestamp        string
	edited_timestamp ?string
	flags            ?int
	mentions         []User
	mention_roles    []string
	sticker_items    ?[]StickerItem
	components       ?[]MessageComponent
}

pub struct MessageInteractionMetadata {
pub:
	id                             string
	interaction_type               int @[json: 'type']
	user                           User
	authorizing_integration_owners map[string]string
	original_response_message_id   ?string
	target_user                    ?User
	target_message_id              ?string
}

pub struct MessageComponent {
pub:
	component_type int @[json: 'type']
	id             ?int
	custom_id      ?string
	disabled       ?bool
	style          ?int
	label          ?string
	emoji          ?Emoji
	url            ?string
	sku_id         ?string
	options        ?[]SelectOption
	channel_types  ?[]int
	placeholder    ?string
	default_values ?[]SelectDefaultValue
	min_values     ?int
	max_values     ?int
	min_length     ?int
	max_length     ?int
	required       ?bool
	value          ?string
	components     ?[]MessageComponent
	// Components V2 fields
	items        ?[]MediaGalleryItem
	media        ?UnfurledMediaItem
	description  ?string
	spoiler      ?bool
	accessory    ?&MessageComponent
	content      ?string
	divider      ?bool
	spacing      ?int
	accent_color ?int
	file         ?UnfurledMediaItem
	name         ?string
	size         ?int
}

pub struct MessageCall {
pub:
	participants    []string
	ended_timestamp ?string
}

pub struct MessageQueryParams {
pub mut:
	around ?string
	before ?string
	after  ?string
	limit  ?int
}

pub fn (params MessageQueryParams) query() string {
	mut pairs := []string{}
	if value := params.around { pairs << 'around=${urllib.query_escape(value)}' }
	if value := params.before { pairs << 'before=${urllib.query_escape(value)}' }
	if value := params.after { pairs << 'after=${urllib.query_escape(value)}' }
	if value := params.limit { pairs << 'limit=${value}' }
	return if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
}

pub struct CreateMessageParams {
pub mut:
	content           ?string
	nonce             ?string
	tts               ?bool
	embeds            ?[]Embed
	allowed_mentions  ?AllowedMentions
	message_reference ?MessageReference
	components        ?[]MessageComponent
	sticker_ids       ?[]string
	attachments       ?[]PartialAttachment
	flags             ?int
	enforce_nonce     ?bool
	poll              ?Poll
}

pub struct EditMessageParams {
pub mut:
	content          ?string
	embeds           ?[]Embed
	flags            ?int
	allowed_mentions ?AllowedMentions
	components       ?[]MessageComponent
	attachments      ?[]PartialAttachment
}

pub struct AllowedMentions {
pub mut:
	parse        ?[]string // Valid values: "roles", "users", "everyone"
	roles        ?[]string
	users        ?[]string
	replied_user ?bool
}

pub struct PartialAttachment {
pub mut:
	id          string
	filename    ?string
	description ?string
}

pub struct MessageReactionQueryParams {
pub mut:
	reaction_type ?int @[json: 'type'] // 0 = normal, 1 = burst
	after         ?string
	limit         ?int
}

pub struct MessageReactionUsers {
pub:
	users []User
}
