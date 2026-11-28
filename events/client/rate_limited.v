module client

import libs.discord

pub fn (mut h ClientEventHandler) on_rate_limited(ratelimit discord.RateLimitedEvent) {
	h.app.log_warn('Client ratelimited!, OP ${ratelimit.opcode} guild ${ratelimit.meta.guild_id} retry after ${ratelimit.retry_after}')
}
