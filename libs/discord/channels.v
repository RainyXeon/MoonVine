module discord

import x.json2
import net.urllib
import net.http

pub struct Channel {
pub:
	id                                 string
	channel_type                       int @[json: 'type']
	guild_id                           ?string
	position                           ?int
	permission_overwrites              ?[]PermissionOverwrite
	name                               ?string
	topic                              ?string
	nsfw                               ?bool
	last_message_id                    ?string
	bitrate                            ?int
	user_limit                         ?int
	rate_limit_per_user                ?int
	recipients                         ?[]User
	icon                               ?string
	owner_id                           ?string
	application_id                     ?string
	managed                            ?bool
	parent_id                          ?string
	last_pin_timestamp                 ?string
	rtc_region                         ?string
	video_quality_mode                 ?int
	message_count                      ?int
	member_count                       ?int
	thread_metadata                    ?ThreadMetadata
	member                             ?ThreadMember
	default_auto_archive_duration      ?int
	permissions                        ?string
	flags                              ?int
	total_message_sent                 ?int
	available_tags                     ?[]ForumTag
	applied_tags                       ?[]string
	default_reaction_emoji             ?DefaultReaction
	default_thread_rate_limit_per_user ?int
	default_sort_order                 ?int
	default_forum_layout               ?int
}

pub struct ThreadMetadata {
pub:
	archived              bool
	auto_archive_duration int
	archive_timestamp     string
	locked                bool
	invitable             ?bool
	create_timestamp      ?string
}

pub struct ThreadMember {
pub:
	id             ?string
	user_id        ?string
	join_timestamp string
	flags          int
	member         ?GuildMember
}

pub struct ChannelEditParams {
pub mut:
	name                               ?string
	channel_type                       ?int @[json: 'type']
	position                           ?int
	topic                              ?string
	nsfw                               ?bool
	rate_limit_per_user                ?int
	bitrate                            ?int
	user_limit                         ?int
	permission_overwrites              ?[]PermissionOverwrite
	parent_id                          ?string
	rtc_region                         ?string
	video_quality_mode                 ?int
	default_auto_archive_duration      ?int
	flags                              ?int
	available_tags                     ?[]ForumTag
	default_reaction_emoji             ?DefaultReaction
	default_thread_rate_limit_per_user ?int
	default_sort_order                 ?int
	default_forum_layout               ?int
	// Thread-specific edit fields
	archived              ?bool
	auto_archive_duration ?int
	locked                ?bool
	invitable             ?bool
	applied_tags          ?[]string
}

pub struct PermissionOverwrite {
pub mut:
	id             string
	overwrite_type int @[json: 'type'] // 0 for a role, 1 for a member
	allow          ?string
	deny           ?string
}

pub struct EditChannelPermissionsParams {
pub mut:
	allow          ?string
	deny           ?string
	overwrite_type int @[json: 'type'] // 0 for a role, 1 for a member
}

pub struct DefaultReaction {
pub mut:
	emoji_id   ?string
	emoji_name ?string
}

pub struct ForumTag {
pub mut:
	id         ?string // Omit when creating a new tag; include when updating existing tags
	name       string
	moderated  ?bool
	emoji_id   ?string
	emoji_name ?string
}

pub struct ChannelCreateParams {
pub mut:
	name                               string
	channel_type                       ?int @[json: 'type']
	topic                              ?string
	bitrate                            ?int
	user_limit                         ?int
	rate_limit_per_user                ?int
	position                           ?int
	permission_overwrites              ?[]PermissionOverwrite
	parent_id                          ?string
	nsfw                               ?bool
	rtc_region                         ?string
	video_quality_mode                 ?int
	default_auto_archive_duration      ?int
	default_reaction_emoji             ?DefaultReaction
	available_tags                     ?[]ForumTag
	default_sort_order                 ?int
	default_forum_layout               ?int
	default_thread_rate_limit_per_user ?int
}

pub struct Poll {
pub:
	question          PollMedia
	answers           []PollAnswer
	expiry            ?string
	allow_multiselect bool
	layout_type       int
	results           ?PollResults
}

pub struct PollMedia {
pub:
	text  ?string
	emoji ?Emoji
}

pub struct PollAnswer {
pub:
	answer_id  int
	poll_media PollMedia
}

pub struct PollResults {
pub:
	is_finalized  bool
	answer_counts []PollAnswerCount
}

pub struct PollAnswerCount {
pub:
	id       int
	count    int
	me_voted bool
}

pub struct StickerPack {
pub:
	id               string
	stickers         []Sticker
	name             string
	sku_id           string
	cover_sticker_id ?string
	description      string
	banner_asset_id  ?string
}

pub struct SoundboardSound {
pub:
	name       string
	sound_id   string
	volume     f64
	emoji_id   ?string
	emoji_name ?string
	guild_id   ?string
	available  ?bool
	user       ?User
}

pub struct StageInstance {
pub:
	id                       string
	guild_id                 string
	channel_id               string
	topic                    string
	privacy_level            int
	discoverable_disabled    bool
	guild_scheduled_event_id ?string
}

pub struct Lobby {
pub:
	id             string
	application_id string
	metadata       ?map[string]string
	members        []LobbyMember
	linked_channel ?Channel
}

pub struct LobbyMember {
pub:
	id       string
	metadata ?map[string]string
	flags    ?int
}

pub struct PollAnswerVotersResult {
pub:
	users []User
}

pub enum IntegrationExpireBehavior {
	remove_role = 0
	kick        = 1
}

pub struct StickerCreateParams {
pub mut:
	name        string
	tags        string
	file        []u8
	description ?string
}

pub struct ChannelMention {
pub:
	id           string
	guild_id     string
	channel_type int @[json: 'type']
	name         string
}

pub struct Attachment {
pub:
	id            string
	filename      string
	title         ?string
	description   ?string
	content_type  ?string
	size          int
	url           string
	proxy_url     string
	height        ?int
	width         ?int
	ephemeral     ?bool
	duration_secs ?f64
	waveform      ?string
	flags         ?int
}

pub struct SelectOption {
pub:
	label       string
	value       string
	description ?string
	emoji       ?Emoji
	default     ?bool
}

pub struct SelectDefaultValue {
pub:
	id           string
	default_type string @[json: 'type']
}

pub struct MediaGalleryItem {
pub:
	media       UnfurledMediaItem
	description ?string
	spoiler     ?bool
}

pub struct UnfurledMediaItem {
pub:
	url          string
	proxy_url    ?string
	height       ?int
	width        ?int
	content_type ?string
}

pub struct StickerItem {
pub:
	id          string
	name        string
	format_type int
}

pub struct RoleSubscriptionData {
pub:
	role_subscription_listing_id string
	tier_name                    string
	total_months_subscribed      int
	is_renewal                   bool
}

pub struct ResolvedData {
pub:
	users       ?map[string]User
	members     ?map[string]GuildMember
	roles       ?map[string]Role
	channels    ?map[string]Channel
	messages    ?map[string]Message
	attachments ?map[string]Attachment
}

pub struct Reaction {
pub:
	count         int
	count_details ReactionCountDetails
	me            bool
	me_burst      bool
	emoji         Emoji
	burst_colors  []string
}

pub struct ReactionCountDetails {
pub:
	burst  int
	normal int
}

@[heap]
pub struct Class_Channels {
pub:
	endpoint string = '/channels'
pub mut:
	bc &Class_BotClient
}

pub fn new_class_channels(bc &Class_BotClient) &Class_Channels {
	return &Class_Channels{
		bc: bc
	}
}

pub fn (this &Class_Channels) fetch(channel_id string) !Channel {
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}', http.FetchConfig{})!
	return decode_response[Channel](res)
}

pub fn (this &Class_Channels) fetch_messages(channel_id string, params MessageQueryParams) ![]Message {
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}/messages${params.query()}', http.FetchConfig{})!
	return decode_response_list[Message](res)
}

pub fn (this &Class_Channels) send_message(channel_id string, params CreateMessageParams) !Message {
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/messages', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[Message](res)
}

pub fn (this &Class_Channels) edit_message(channel_id string, message_id string, params EditMessageParams) !Message {
	res := this.bc.raw_request(.patch, '${this.endpoint}/${channel_id}/messages/${message_id}', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[Message](res)
}

pub fn (this &Class_Channels) delete_message(channel_id string, message_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/messages/${message_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) create_reaction(channel_id string, message_id string, emoji string) ! {
	encoded_emoji := urllib.path_escape(emoji)
	res := this.bc.raw_request(.put, '${this.endpoint}/${channel_id}/messages/${message_id}/reactions/${encoded_emoji}/@me', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) delete_own_reaction(channel_id string, message_id string, emoji string) ! {
	encoded_emoji := urllib.path_escape(emoji)
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/messages/${message_id}/reactions/${encoded_emoji}/@me', http.FetchConfig{})!
	check_response(res)!
}

// fetch_sticker retrieves a sticker by ID.
pub fn (this &Class_Channels) fetch_sticker(sticker_id string) !Sticker {
	res := this.bc.raw_request(.get, '/stickers/${sticker_id}', http.FetchConfig{})!
	return decode_response[Sticker](res)
}

// fetch_sticker_packs lists standard sticker packs.
pub fn (this &Class_Channels) fetch_sticker_packs() ![]StickerPack {
	res := this.bc.raw_request(.get, '/sticker-packs', http.FetchConfig{})!
	return decode_response_list[StickerPack](res)
}

pub fn (this &Class_Channels) expire_poll(channel_id string, message_id string) !Message {
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/polls/${message_id}/expire', http.FetchConfig{})!
	return decode_response[Message](res)
}

pub fn (this &Class_Channels) fetch_poll_answer_voters(channel_id string, message_id string, answer_id int, after ?string, limit ?int) !PollAnswerVotersResult {
	mut pairs := []string{}
	if value := after {
		pairs << 'after=${urllib.query_escape(value)}'
	}
	if value := limit {
		pairs << 'limit=${value}'
	}
	query := if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}/polls/${message_id}/answers/${answer_id}${query}', http.FetchConfig{})!
	return decode_response[PollAnswerVotersResult](res)
}

pub fn (this &Class_Channels) crosspost_message(channel_id string, message_id string) !Message {
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/messages/${message_id}/crosspost', http.FetchConfig{})!
	return decode_response[Message](res)
}

pub fn (this &Class_Channels) fetch_message(channel_id string, message_id string) !Message {
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}/messages/${message_id}', http.FetchConfig{})!
	return decode_response[Message](res)
}

pub fn (this &Class_Channels) trigger_typing(channel_id string) ! {
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/typing', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) fetch_pins(channel_id string) ![]Message {
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}/pins', http.FetchConfig{})!
	return decode_response_list[Message](res)
}

pub fn (this &Class_Channels) pin_message(channel_id string, message_id string) ! {
	res := this.bc.raw_request(.put, '${this.endpoint}/${channel_id}/pins/${message_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) unpin_message(channel_id string, message_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/pins/${message_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) edit_overwrite(channel_id string, target_id string, overwrite EditChannelPermissionsParams, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.put, '${this.endpoint}/${channel_id}/permissions/${target_id}', http.FetchConfig{
		header: header
		data:   json2.encode(overwrite)
	})!
	check_response(res)!
}

pub fn (this &Class_Channels) delete_overwrite(channel_id string, target_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/permissions/${target_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &Class_Channels) edit(channel_id string, params ChannelEditParams, reason ?string) !Channel {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${channel_id}', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Channel](res)
}

pub fn (this &Class_Channels) delete(channel_id string, reason ?string) !Channel {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}', http.FetchConfig{
		header: header
	})!
	return decode_response[Channel](res)
}

pub fn (this &Class_Channels) create_invite(channel_id string, params CreateInviteParams, reason ?string) !Invite {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/invites', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Invite](res)
}

pub fn (this &Class_Channels) create_webhook(channel_id string, params CreateWebhookParams, reason ?string) !Webhook {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/webhooks', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Webhook](res)
}

pub fn (this &Class_Channels) fetch_pinned_messages(channel_id string, before ?string, limit ?int) ![]Message {
	mut pairs := []string{}
	if value := before {
		pairs << 'before=${urllib.query_escape(value)}'
	}
	if value := limit {
		pairs << 'limit=${value}'
	}
	query := if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}/pins${query}', http.FetchConfig{})!
	return decode_response_list[Message](res)
}

pub fn (this &Class_Channels) delete_all_reactions(channel_id string, message_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/messages/${message_id}/reactions', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) delete_emoji_reactions(channel_id string, message_id string, emoji string) ! {
	encoded_emoji := urllib.path_escape(emoji)
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/messages/${message_id}/reactions/${encoded_emoji}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) create_poll_vote(channel_id string, message_id string, answer_id int) ! {
	res := this.bc.raw_request(.put, '${this.endpoint}/${channel_id}/polls/${message_id}/answers/${answer_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) delete_poll_vote(channel_id string, message_id string, answer_id int) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${channel_id}/polls/${message_id}/answers/${answer_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Channels) delete_messages_bulk(channel_id string, message_ids []string) ! {
	if message_ids.len < 2 || message_ids.len > 100 {
		return error('bulk delete requires between 2 and 100 message IDs')
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${channel_id}/messages/bulk-delete', http.FetchConfig{
		data: json2.encode({
			'messages': message_ids
		})
	})!
	check_response(res)!
}

pub fn (this &Class_Channels) fetch_reaction_users(channel_id string, message_id string, emoji string, params MessageReactionQueryParams) ![]User {
	mut pairs := []string{}
	if value := params.reaction_type {
		pairs << 'type=${value}'
	}
	if value := params.after {
		pairs << 'after=${urllib.query_escape(value)}'
	}
	if value := params.limit {
		pairs << 'limit=${value}'
	}
	query := if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
	res := this.bc.raw_request(.get, '${this.endpoint}/${channel_id}/messages/${message_id}/reactions/${urllib.path_escape(emoji)}${query}', http.FetchConfig{})!
	return decode_response_list[User](res)
}
