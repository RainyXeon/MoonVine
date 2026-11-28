module discord

import net.http
import json2
import net.urllib

pub struct Guild {
pub:
	id                            string
	name                          string
	icon                          ?string
	icon_hash                     ?string
	splash                        ?string
	discovery_splash              ?string
	owner                         ?bool
	owner_id                      string
	permissions                   ?string
	region                        ?string
	afk_channel_id                ?string
	afk_timeout                   int
	widget_enabled                ?bool
	widget_channel_id             ?string
	verification_level            int
	default_message_notifications int
	explicit_content_filter       int
	roles                         []Role
	emojis                        []Emoji
	features                      []string
	mfa_level                     int
	application_id                ?string
	system_channel_id             ?string
	system_channel_flags          int
	rules_channel_id              ?string
	max_presences                 ?int
	max_members                   ?int
	vanity_url_code               ?string
	description                   ?string
	banner                        ?string
	premium_tier                  int
	premium_subscription_count    ?int
	preferred_locale              string
	public_updates_channel_id     ?string
	max_video_channel_users       ?int
	max_stage_video_channel_users ?int
	approximate_member_count      ?int
	approximate_presence_count    ?int
	welcome_screen                ?WelcomeScreen
	nsfw_level                    int
	stickers                      ?[]Sticker
	premium_progress_bar_enabled  bool
	safety_alerts_channel_id      ?string
	incidents_data                ?IncidentsData
}

pub struct WelcomeScreen {
pub:
	description      ?string
	welcome_channels []WelcomeScreenChannel
}

pub struct WelcomeScreenChannel {
pub:
	channel_id  string
	description string
	emoji_id    ?string
	emoji_name  ?string
}

pub struct Sticker {
pub:
	id           string
	pack_id      ?string
	name         string
	description  ?string
	tags         string
	sticker_type int @[json: 'type']
	format_type  int
	available    ?bool
	guild_id     ?string
	user         ?User
	sort_value   ?int
}

pub struct IncidentsData {
pub:
	invites_disabled_until ?string
	dms_disabled_until     ?string
	dm_spam_detected_at    ?string
	raid_detected_at       ?string
}

pub struct Integration {
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
}

pub struct IntegrationAccount {
pub:
	id   string
	name string
}

pub struct IntegrationApplication {
pub:
	id          string
	name        string
	icon        ?string
	description string
	bot         ?User
}

pub struct GuildWidgetSettings {
pub:
	enabled    bool
	channel_id ?string
}

pub struct GuildVanityURL {
pub:
	code ?string
	uses int
}

pub struct GuildWelcomeScreen {
pub:
	enabled          bool
	description      ?string
	welcome_channels []WelcomeScreenChannel
}

pub struct GuildOnboarding {
pub:
	guild_id            string
	prompts             []OnboardingPrompt
	default_channel_ids []string
	enabled             bool
	mode                int
}

pub struct OnboardingPrompt {
pub:
	id            string
	prompt_type   int @[json: 'type']
	options       []OnboardingPromptOption
	title         string
	single_select bool
	required      bool
	in_onboarding bool
}

pub struct OnboardingPromptOption {
pub:
	id             string
	channel_ids    []string
	role_ids       []string
	emoji          ?Emoji
	emoji_id       ?string
	emoji_name     ?string
	emoji_animated ?bool
	title          string
	description    ?string
}

pub struct GuildScheduledEvent {
pub:
	id                   string
	guild_id             string
	channel_id           ?string
	creator_id           ?string
	name                 string
	description          ?string
	scheduled_start_time string
	scheduled_end_time   ?string
	privacy_level        int
	status               int
	entity_type          int
	entity_id            ?string
	entity_metadata      ?GuildScheduledEventEntityMetadata
	creator              ?User
	user_count           ?int
	image                ?string
	recurrence_rule      ?GuildScheduledEventRecurrenceRule
}

pub struct GuildTemplate {
pub:
	code                    string
	name                    string
	description             ?string
	usage_count             int
	creator_id              string
	creator                 User
	created_at              string
	updated_at              string
	source_guild_id         string
	serialized_source_guild GuildTemplateSnapshot
	is_dirty                ?bool
}

pub struct GuildTemplateSnapshot {
pub:
	name                          string
	description                   ?string
	region                        ?string
	verification_level            int
	default_message_notifications int
	explicit_content_filter       int
	preferred_locale              string
	afk_timeout                   int
	roles                         []Role
	channels                      []Channel
	afk_channel_id                ?string
	system_channel_id             ?string
	system_channel_flags          int
}

pub struct GuildMember {
pub:
	user                         ?User
	nick                         ?string
	avatar                       ?string
	banner                       ?string
	roles                        []string
	joined_at                    string
	premium_since                ?string
	deaf                         bool
	mute                         bool
	flags                        int
	pending                      ?bool
	permissions                  ?string
	communication_disabled_until ?string
	avatar_decoration_data       ?AvatarDecorationData
}

pub struct GuildBan {
pub:
	reason ?string
	user   User
}

pub struct GuildMemberEditParams {
pub mut:
	nick                         ?string
	roles                        ?[]string
	mute                         ?bool
	deaf                         ?bool
	channel_id                   ?string
	communication_disabled_until ?string
	flags                        ?int
}

pub struct GuildEditParams {
pub mut:
	name                          ?string
	verification_level            ?int
	default_message_notifications ?int
	explicit_content_filter       ?int
	afk_channel_id                ?string
	afk_timeout                   ?int
	icon                          ?string
	owner_id                      ?string
	splash                        ?string
	discovery_splash              ?string
	banner                        ?string
	system_channel_id             ?string
	system_channel_flags          ?int
	rules_channel_id              ?string
	public_updates_channel_id     ?string
	preferred_locale              ?string
	features                      ?[]string
	description                   ?string
	premium_progress_bar_enabled  ?bool
	safety_alerts_channel_id      ?string
}

pub struct ModifyScheduledEventParams {
pub mut:
	channel_id           ?string
	entity_metadata      ?GuildScheduledEventEntityMetadata
	name                 ?string
	privacy_level        ?int
	scheduled_start_time ?string
	scheduled_end_time   ?string
	description          ?string
	entity_type          ?int
	status               ?int
	image                ?string
	recurrence_rule      ?GuildScheduledEventRecurrenceRule
}

pub struct CreateStageInstanceParams {
pub mut:
	channel_id               string
	topic                    string
	privacy_level            ?int
	send_start_notification  ?bool
	guild_scheduled_event_id ?string
}

pub struct ModifyStageInstanceParams {
pub mut:
	topic         ?string
	privacy_level ?int
}

pub struct ModifyChannelPositionParams {
pub mut:
	id               string
	position         ?int
	lock_permissions ?bool
	parent_id        ?string
}

pub struct GuildPreview {
pub:
	id                         string
	name                       string
	icon                       ?string
	splash                     ?string
	discovery_splash           ?string
	emojis                     []Emoji
	features                   []string
	approximate_member_count   int
	approximate_presence_count int
	description                ?string
	stickers                   []Sticker
}

pub struct GuildScheduledEventEntityMetadata {
pub:
	location ?string
}

pub struct GuildScheduledEventRecurrenceRule {
pub:
	start        string
	end          ?string
	frequency    int
	interval     int
	by_weekday   ?[]int
	by_n_weekday ?[]GuildScheduledEventRecurrenceRuleNWeekday
	by_month     ?[]int
	by_month_day ?[]int
	by_year_day  ?[]int
	count        ?int
}

pub struct GuildScheduledEventRecurrenceRuleNWeekday {
pub:
	n   int
	day int
}

pub struct VoiceRegion {
pub:
	id         string
	name       string
	optimal    bool
	deprecated bool
	custom     bool
}

pub struct CreateScheduledEventParams {
pub mut:
	channel_id           ?string
	entity_metadata      ?GuildScheduledEventEntityMetadata
	name                 string
	privacy_level        int
	scheduled_start_time string
	scheduled_end_time   ?string
	description          ?string
	entity_type          int
	image                ?string
	recurrence_rule      ?GuildScheduledEventRecurrenceRule
}

pub struct ScheduledEventUser {
pub:
	guild_scheduled_event_id string
	user_id                  ?string
	user                     User
	member                   ?GuildMember
}

pub struct GuildMemberModifyParams {
pub mut:
	nick                         ?string
	roles                        ?[]string
	mute                         ?bool
	deaf                         ?bool
	channel_id                   ?string
	communication_disabled_until ?string
	flags                        ?int
}

@[heap]
pub struct GuildClient {
pub:
	endpoint string = '/guilds'
pub mut:
	bc &Client
}

pub fn new_guild_client(bc &Client) &GuildClient {
	return &GuildClient{
		bc: bc
	}
}

pub fn (this &GuildClient) fetch(guild_id string) !Guild {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}', http.FetchConfig{})!
	return decode_response[Guild](res)
}

pub fn (this &GuildClient) fetch_preview(guild_id string) !GuildPreview {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/preview', http.FetchConfig{})!
	return decode_response[GuildPreview](res)
}

pub fn (this &GuildClient) fetch_channels(guild_id string) ![]Channel {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/channels', http.FetchConfig{})!
	return decode_response_list[Channel](res)
}

pub fn (this &GuildClient) fetch_roles(guild_id string) ![]Role {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/roles', http.FetchConfig{})!
	return decode_response_list[Role](res)
}

pub fn (this &GuildClient) fetch_audit_log(guild_id string, params AuditLogQueryParams) !AuditLog {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/audit-logs${params.query()}', http.FetchConfig{})!
	return decode_response[AuditLog](res)
}

// fetch_scheduled_events lists a guild's scheduled events.
pub fn (this &GuildClient) fetch_scheduled_events(guild_id string, with_user_count bool) ![]GuildScheduledEvent {
	query := if with_user_count { '?with_user_count=true' } else { '' }
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/scheduled-events${query}', http.FetchConfig{})!
	return decode_response_list[GuildScheduledEvent](res)
}

// create_scheduled_event creates a scheduled event in a guild.
pub fn (this &GuildClient) create_scheduled_event(guild_id string, params CreateScheduledEventParams) !GuildScheduledEvent {
	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/scheduled-events', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[GuildScheduledEvent](res)
}

// fetch_scheduled_event retrieves one scheduled event.
pub fn (this &GuildClient) fetch_scheduled_event(guild_id string, event_id string) !GuildScheduledEvent {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/scheduled-events/${event_id}', http.FetchConfig{})!
	return decode_response[GuildScheduledEvent](res)
}

pub fn (this &GuildClient) fetch_soundboard_sounds(guild_id string) ![]SoundboardSound {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/soundboard-sounds', http.FetchConfig{})!
	return decode_response_list[SoundboardSound](res)
}

pub fn (this &GuildClient) fetch_soundboard_sound(guild_id string, sound_id string) !SoundboardSound {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/soundboard-sounds/${sound_id}', http.FetchConfig{})!
	return decode_response[SoundboardSound](res)
}

pub fn (this &GuildClient) fetch_stage_instance(channel_id string) !StageInstance {
	res := this.bc.raw_request(.get, '/stage-instances/${channel_id}', http.FetchConfig{})!
	return decode_response[StageInstance](res)
}

pub fn (this &GuildClient) create_stage_instance(data CreateStageInstanceParams) !StageInstance {
	res := this.bc.raw_request(.post, '/stage-instances', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[StageInstance](res)
}

pub fn (this &GuildClient) edit_stage_instance(channel_id string, data ModifyStageInstanceParams) !StageInstance {
	res := this.bc.raw_request(.patch, '/stage-instances/${channel_id}', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[StageInstance](res)
}

pub fn (this &GuildClient) delete_stage_instance(channel_id string) ! {
	res := this.bc.raw_request(.delete, '/stage-instances/${channel_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &GuildClient) fetch_member(guild_id string, user_id string) !GuildMember {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/members/${user_id}', http.FetchConfig{})!
	return decode_response[GuildMember](res)
}

pub fn (this &GuildClient) fetch_bans(guild_id string, before ?string, after ?string, limit ?int) ![]GuildBan {
	mut pairs := []string{}
	if value := before {
		pairs << 'before=${urllib.query_escape(value)}'
	}
	if value := after {
		pairs << 'after=${urllib.query_escape(value)}'
	}
	if value := limit {
		pairs << 'limit=${value}'
	}
	query := if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/bans${query}', http.FetchConfig{})!
	return decode_response_list[GuildBan](res)
}

pub fn (this &GuildClient) fetch_webhooks(guild_id string) ![]Webhook {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/webhooks', http.FetchConfig{})!
	return decode_response_list[Webhook](res)
}

pub fn (this &GuildClient) fetch_invites(guild_id string) ![]Invite {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/invites', http.FetchConfig{})!
	return decode_response_list[Invite](res)
}

pub fn (this &GuildClient) create_role(guild_id string, params RoleCreateParams, reason ?string) !Role {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/roles', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Role](res)
}

pub fn (this &GuildClient) delete_role(guild_id string, role_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/roles/${role_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) fetch_templates(guild_id string) ![]GuildTemplate {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/templates', http.FetchConfig{})!
	return decode_response_list[GuildTemplate](res)
}

pub fn (this &GuildClient) create_template(guild_id string, name string, description ?string) !GuildTemplate {
	mut data := map[string]string{
		'name': name
	}
	if value := description {
		data['description'] = value
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/templates', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[GuildTemplate](res)
}

pub fn (this &GuildClient) edit_member(guild_id string, user_id string, params GuildMemberEditParams) !GuildMember {
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/members/${user_id}', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[GuildMember](res)
}

pub fn (this &GuildClient) edit_current_member(guild_id string, params GuildMemberEditParams) !GuildMember {
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/members/@me', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[GuildMember](res)
}

pub fn (this &GuildClient) modify_member(guild_id string, user_id string, params GuildMemberModifyParams, reason ?string) !GuildMember {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/members/${user_id}', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[GuildMember](res)
}

pub fn (this &GuildClient) remove_member(guild_id string, user_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/members/${user_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) fetch_ban(guild_id string, user_id string) !GuildBan {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/bans/${user_id}', http.FetchConfig{})!
	return decode_response[GuildBan](res)
}

pub fn (this &GuildClient) create_ban(guild_id string, user_id string, delete_message_seconds ?int, reason ?string) ! {
	mut pairs := []string{}
	if seconds := delete_message_seconds {
		pairs << 'delete_message_seconds=${seconds}'
	}
	query := if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.put, '${this.endpoint}/${guild_id}/bans/${user_id}${query}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) delete_ban(guild_id string, user_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/bans/${user_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) delete_scheduled_event(guild_id string, event_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/scheduled-events/${event_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &GuildClient) edit_scheduled_event(guild_id string, event_id string, params ModifyScheduledEventParams) !GuildScheduledEvent {
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/scheduled-events/${event_id}', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[GuildScheduledEvent](res)
}

pub fn (this &GuildClient) fetch_scheduled_event_users(guild_id string, event_id string, before ?string, after ?string, limit ?int, with_member bool) ![]ScheduledEventUser {
	mut pairs := []string{}
	if value := before {
		pairs << 'before=${urllib.query_escape(value)}'
	}
	if value := after {
		pairs << 'after=${urllib.query_escape(value)}'
	}
	if value := limit {
		pairs << 'limit=${value}'
	}
	if with_member {
		pairs << 'with_member=true'
	}
	query := if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/scheduled-events/${event_id}/users${query}', http.FetchConfig{})!
	return decode_response_list[ScheduledEventUser](res)
}

pub fn (this &GuildClient) fetch_stickers(guild_id string) ![]Sticker {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/stickers', http.FetchConfig{})!
	return decode_response_list[Sticker](res)
}

pub fn (this &GuildClient) fetch_sticker(guild_id string, sticker_id string) !Sticker {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/stickers/${sticker_id}', http.FetchConfig{})!
	return decode_response[Sticker](res)
}

pub fn (this &GuildClient) fetch_template_by_code(code string) !GuildTemplate {
	res := this.bc.raw_request(.get, '/guilds/templates/${code}', http.FetchConfig{})!
	return decode_response[GuildTemplate](res)
}

pub fn (this &GuildClient) create_template_from_guild(guild_id string, name string, description ?string) !GuildTemplate {
	mut data := map[string]string{
		'name': name
	}
	if value := description {
		data['description'] = value
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/templates', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[GuildTemplate](res)
}

pub fn (this &GuildClient) edit(guild_id string, params GuildEditParams, reason ?string) !Guild {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Guild](res)
}

pub fn (this &GuildClient) delete(guild_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &GuildClient) edit_role(guild_id string, role_id string, params RoleEditParams, reason ?string) !Role {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/roles/${role_id}', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Role](res)
}

pub fn (this &GuildClient) create_channel(guild_id string, params ChannelCreateParams, reason ?string) !Channel {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/channels', http.FetchConfig{
		header: header
		data:   json2.encode(params)
	})!
	return decode_response[Channel](res)
}

pub fn (this &GuildClient) reorder_channels(guild_id string, positions []ModifyChannelPositionParams) ! {
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/channels', http.FetchConfig{
		data: json2.encode(positions)
	})!
	check_response(res)!
}

pub fn (this &GuildClient) edit_template(guild_id string, template_code string, name ?string, description ?string) !GuildTemplate {
	mut data := map[string]string{}
	if value := name {
		data['name'] = value
	}
	if value := description {
		data['description'] = value
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/templates/${template_code}', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[GuildTemplate](res)
}

pub fn (this &GuildClient) delete_template(guild_id string, template_code string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/templates/${template_code}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &GuildClient) sync_template(guild_id string, template_code string) !GuildTemplate {
	res := this.bc.raw_request(.put, '${this.endpoint}/${guild_id}/templates/${template_code}', http.FetchConfig{})!
	return decode_response[GuildTemplate](res)
}

pub fn (this &GuildClient) fetch_current_member(guild_id string) !GuildMember {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/members/@me', http.FetchConfig{})!
	return decode_response[GuildMember](res)
}

pub fn (this &GuildClient) add_member_role(guild_id string, user_id string, role_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.put, '${this.endpoint}/${guild_id}/members/${user_id}/roles/${role_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) remove_member_role(guild_id string, user_id string, role_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/members/${user_id}/roles/${role_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) fetch_widget(guild_id string) !GuildWidgetSettings {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/widget', http.FetchConfig{})!
	return decode_response[GuildWidgetSettings](res)
}

pub fn (this &GuildClient) edit_widget(guild_id string, settings GuildWidgetSettings) !GuildWidgetSettings {
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/widget', http.FetchConfig{
		data: json2.encode(settings)
	})!
	return decode_response[GuildWidgetSettings](res)
}

pub fn (this &GuildClient) fetch_vanity_url(guild_id string) !GuildVanityURL {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/vanity-url', http.FetchConfig{})!
	return decode_response[GuildVanityURL](res)
}

pub fn (this &GuildClient) fetch_onboarding(guild_id string) !GuildOnboarding {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/onboarding', http.FetchConfig{})!
	return decode_response[GuildOnboarding](res)
}

pub fn (this &GuildClient) fetch_voice_regions(guild_id string) ![]VoiceRegion {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/regions', http.FetchConfig{})!
	return decode_response_list[VoiceRegion](res)
}

pub fn (this &GuildClient) fetch_current_guilds() ![]Guild {
	if !this.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	res := this.bc.raw_request(.get, '/users/@me/guilds', http.FetchConfig{})!
	return decode_response_list[Guild](res)
}

pub fn (this &GuildClient) leave(guild_id string) ! {
	if !this.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	res := this.bc.raw_request(.delete, '/users/@me/guilds/${guild_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &GuildClient) join(guild_id string) ! {
	if !this.bc.user_token {
		return error('USER_OAUTH_TOKEN_REQUIRED')
	}
	res := this.bc.raw_request(.put, '/users/@me/guilds/${guild_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &GuildClient) edit_current_nick(guild_id string, nick string, reason ?string) !GuildMember {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/members/@me/nick', http.FetchConfig{
		header: header
		data:   json2.encode(map[string]string{
			'nick': nick
		})
	})!
	return decode_response[GuildMember](res)
}

pub fn (this &GuildClient) remove_ban(guild_id string, user_id string, reason ?string) ! {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/bans/${user_id}', http.FetchConfig{
		header: header
	})!
	check_response(res)!
}

pub fn (this &GuildClient) fetch_invite(code string) !Invite {
	res := this.bc.raw_request(.get, '/invites/${urllib.path_escape(code)}', http.FetchConfig{})!
	return decode_response[Invite](res)
}

pub fn (this &GuildClient) fetch_audit_log_entries(guild_id string, params AuditLogQueryParams) !AuditLog {
	return this.fetch_audit_log(guild_id, params)
}
