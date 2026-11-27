module discord

pub struct AutoModerationActionExecutionEvent {
pub:
	guild_id                string
	action                  AutoModerationAction
	rule_id                 string
	rule_trigger_type       int
	user_id                 string
	channel_id              ?string
	message_id              ?string
	alert_system_message_id ?string
	content                 string
	matched_keyword         ?string
	matched_content         ?string
}

pub struct AutoModerationRuleCreateEvent {
pub:
	auto_moderation_rule AutoModerationRule
}

pub struct AutoModerationRuleUpdateEvent {
pub:
	auto_moderation_rule AutoModerationRule
}

pub struct AutoModerationRuleDeleteEvent {
pub:
	auto_moderation_rule AutoModerationRule
}
