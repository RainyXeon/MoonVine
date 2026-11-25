module discord

import net.http
import json2

pub struct AutoModerationRule {
pub:
	id               string
	guild_id         string
	name             string
	creator_id       string
	event_type       int
	trigger_type     int
	trigger_metadata AutoModerationTriggerMetadata
	actions          []AutoModerationAction
	enabled          bool
	exempt_roles     []string
	exempt_channels  []string
}

pub struct AutoModerationTriggerMetadata {
pub:
	keyword_filter                  ?[]string
	regex_patterns                  ?[]string
	presets                         ?[]int
	allow_list                      ?[]string
	mention_total_limit             ?int
	mention_raid_protection_enabled ?bool
}

pub struct AutoModerationAction {
pub:
	action_type int @[json: 'type']
	metadata    ?AutoModerationActionMetadata
}

pub struct AutoModerationActionMetadata {
pub:
	channel_id       ?string
	duration_seconds ?int
	custom_message   ?string
}

pub struct CreateAutoModerationRuleParams {
pub mut:
	name             string
	event_type       int
	trigger_type     int
	trigger_metadata ?AutoModerationTriggerMetadata
	actions          []AutoModerationAction
	enabled          ?bool
	exempt_roles     ?[]string
	exempt_channels  ?[]string
}

pub struct ModifyAutoModerationRuleParams {
pub mut:
	name             ?string
	event_type       ?int
	trigger_metadata ?AutoModerationTriggerMetadata
	actions          ?[]AutoModerationAction
	enabled          ?bool
	exempt_roles     ?[]string
	exempt_channels  ?[]string
}

pub struct Class_AutoModeration {
pub:
	endpoint string = '/guilds'
pub mut:
	bc &Class_BotClient
}

pub fn new_class_auto_moderation(bc &Class_BotClient) &Class_AutoModeration {
	return &Class_AutoModeration{ bc: bc }
}

pub fn (this &Class_AutoModeration) fetch_rules(guild_id string) ![]AutoModerationRule {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/auto-moderation/rules', http.FetchConfig{})!
	return decode_response_list[AutoModerationRule](res)
}

pub fn (this &Class_AutoModeration) fetch_rule(guild_id string, rule_id string) !AutoModerationRule {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/auto-moderation/rules/${rule_id}', http.FetchConfig{})!
	return decode_response[AutoModerationRule](res)
}

pub fn (this &Class_AutoModeration) create_rule(guild_id string, rule CreateAutoModerationRuleParams, reason ?string) !AutoModerationRule {
	mut header := http.new_header()
	if r := reason {
		header.add_custom('X-Audit-Log-Reason', r)!
	}

	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/auto-moderation/rules', http.FetchConfig{
		data:   json2.encode(rule)
		header: header
	})!
	return decode_response[AutoModerationRule](res)
}

pub fn (this &Class_AutoModeration) edit_rule(guild_id string, rule_id string, rule ModifyAutoModerationRuleParams, reason ?string) !AutoModerationRule {
	mut header := http.new_header()
	if r := reason {
		header.add_custom('X-Audit-Log-Reason', r)!
	}

	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/auto-moderation/rules/${rule_id}', http.FetchConfig{
		data:   json2.encode(rule)
		header: header
	})!
	return decode_response[AutoModerationRule](res)
}

pub fn (this &Class_AutoModeration) delete_rule(guild_id string, rule_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/auto-moderation/rules/${rule_id}', http.FetchConfig{})!
	check_response(res)!
}
