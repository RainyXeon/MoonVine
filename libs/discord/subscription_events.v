module discord

pub struct EntitlementEvent {
pub:
	entitlement Entitlement
}

pub struct SubscriptionCreateEvent {
pub:
	subscription SubscriptionEvent
}

pub struct SubscriptionUpdateEvent {
pub:
	subscription SubscriptionEvent
}

pub struct SubscriptionDeleteEvent {
pub:
	subscription SubscriptionEvent
}

pub struct SubscriptionEvent {
pub:
	id                   string
	user_id              string
	sku_ids              []string
	entitlement_ids      []string
	current_period_start string
	current_period_end   string
	status               int
	canceled_at          ?string
	country              ?string
}
