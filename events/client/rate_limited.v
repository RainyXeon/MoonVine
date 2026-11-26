module client

import libs.discord

pub fn (mut h Class_ClientEventHandler) on_rate_limited(ratelimit discord.RateLimitedEvent) {
	h.moonvine.log.warn('Client ratelimited!, OP ${ratelimit.opcode} guild ${ratelimit.meta.guild_id} retry after ${ratelimit.retry_after}')
}
