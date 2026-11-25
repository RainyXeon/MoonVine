module discord

import net.urllib

pub struct Subscription {
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

pub struct SubscriptionQueryParams {
pub mut:
	before ?string
	after  ?string
	limit  ?int
}

pub fn (params SubscriptionQueryParams) query() string {
	mut pairs := []string{}
	if value := params.before { pairs << 'before=${urllib.query_escape(value)}' }
	if value := params.after { pairs << 'after=${urllib.query_escape(value)}' }
	if value := params.limit { pairs << 'limit=${value}' }
	return if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
}
