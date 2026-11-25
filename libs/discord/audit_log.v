module discord

import net.urllib

pub struct AuditLog {
pub:
	application_commands   []ApplicationCommand
	audit_log_entries      []AuditLogEntry
	auto_moderation_rules  []AutoModerationRule
	guild_scheduled_events []GuildScheduledEvent
	integrations           []Integration
	threads                []Channel
	users                  []User
	webhooks               []Webhook
}

pub struct AuditLogEntry {
pub:
	target_id  ?string
	changes    ?[]AuditLogChange
	user_id    ?string
	id         string
	entry_type int @[json: 'action_type']
	options    ?OptionalAuditEntryInfo
	reason     ?string
}

pub struct AuditLogChange {
pub:
	new_value ?string // Note: Discord sends mixed JSON types (string, int, bool, array, object) depending on key; use json2.Any if decoding raw dynamic values
	old_value ?string
	key       string
}

pub struct OptionalAuditEntryInfo {
pub:
	application_id                    ?string
	auto_moderation_rule_name         ?string
	auto_moderation_rule_trigger_type ?string
	channel_id                        ?string
	count                             ?string
	delete_member_days                ?string
	id                                ?string
	members_removed                   ?string
	message_id                        ?string
	role_name                         ?string
	override_type                     ?string @[json: 'type']
	integration_type                  ?string
}

pub struct AuditLogQueryParams {
pub mut:
	user_id     ?string
	action_type ?int
	before      ?string
	limit       ?int
}

pub fn (params AuditLogQueryParams) query() string {
	mut pairs := []string{}
	if value := params.user_id { pairs << 'user_id=${urllib.query_escape(value)}' }
	if value := params.action_type { pairs << 'action_type=${value}' }
	if value := params.before { pairs << 'before=${urllib.query_escape(value)}' }
	if value := params.limit { pairs << 'limit=${value}' }
	return if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
}
