module discord

import net.http
import json2
import net.urllib

pub struct SKU {
pub:
	id             string
	type           int
	application_id string
	name           string
	slug           string
	flags          int
	available      ?bool
	release_date   ?string
	premium        ?bool
}

pub struct Entitlement {
pub:
	id             string
	sku_id         string
	application_id string
	user_id        ?string
	type           int
	deleted        bool
	starts_at      ?string
	ends_at        ?string
	guild_id       ?string
	consumed       ?bool
}

pub struct EntitlementQueryParams {
pub mut:
	user_id            ?string
	guild_id           ?string
	sku_ids            ?[]string
	before             ?string
	after              ?string
	limit              ?int
	guild_subscription ?bool
}

pub struct EntitlementConsumeResponse {
pub:
	id string
}

pub struct CreateTestEntitlementParams {
pub:
	sku_id     string
	owner_id   string
	owner_type int
}

@[heap]
pub struct Class_Entitlements {
pub:
	endpoint string = '/applications'
pub mut:
	bc &Class_BotClient
}

pub fn new_class_entitlements(bc &Class_BotClient) &Class_Entitlements {
	return &Class_Entitlements{ bc: bc }
}

pub fn (this &Class_Entitlements) fetch(application_id string, params EntitlementQueryParams) ![]Entitlement {
	res := this.bc.raw_request(.get, '${this.endpoint}/${application_id}/entitlements${params.query()}', http.FetchConfig{})!
	return decode_response_list[Entitlement](res)
}

pub fn (params EntitlementQueryParams) query() string {
	mut pairs := []string{}
	if value := params.user_id { pairs << 'user_id=${urllib.query_escape(value)}' }
	if value := params.guild_id { pairs << 'guild_id=${urllib.query_escape(value)}' }
	if value := params.sku_ids {
		for id in value { pairs << 'sku_ids=${urllib.query_escape(id)}' }
	}
	if value := params.before { pairs << 'before=${urllib.query_escape(value)}' }
	if value := params.after { pairs << 'after=${urllib.query_escape(value)}' }
	if value := params.limit { pairs << 'limit=${value}' }
	if value := params.guild_subscription { pairs << 'guild_subscription=${value}' }
	return if pairs.len > 0 { '?${pairs.join('&')}' } else { '' }
}

// fetch_skus lists an application's purchasable SKUs.
pub fn (this &Class_Entitlements) fetch_skus(application_id string) ![]SKU {
	res := this.bc.raw_request(.get, '${this.endpoint}/${application_id}/skus', http.FetchConfig{})!
	return decode_response_list[SKU](res)
}

// fetch_subscriptions lists subscriptions for a SKU. Bot owner / entitlement
// routes are authenticated with the application's bot token.
pub fn (this &Class_Entitlements) fetch_subscriptions(application_id string, sku_id string, params SubscriptionQueryParams) ![]Subscription {
	res := this.bc.raw_request(.get, '${this.endpoint}/${application_id}/subscriptions/${sku_id}${params.query()}', http.FetchConfig{})!
	return decode_response_list[Subscription](res)
}

pub fn (this &Class_Entitlements) consume(application_id string, entitlement_id string) ! {
	res := this.bc.raw_request(.post, '${this.endpoint}/${application_id}/entitlements/${entitlement_id}/consume', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Entitlements) delete_test_entitlement(application_id string, entitlement_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${application_id}/entitlements/${entitlement_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (this &Class_Entitlements) create_test_entitlement(application_id string, params CreateTestEntitlementParams) !Entitlement {
	res := this.bc.raw_request(.post, '${this.endpoint}/${application_id}/entitlements', http.FetchConfig{
		data: json2.encode(params)
	})!
	return decode_response[Entitlement](res)
}
