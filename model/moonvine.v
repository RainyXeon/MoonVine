module model

import libs.discord
import configs
import log
import time

@[heap]
pub struct MoonVine {
pub:
	client    &discord.Class_BotClient = unsafe { nil }
	configs   configs.Config
	log       &log.ThreadSafeLog = log.new_thread_safe_log()
	stopwatch time.StopWatch
}
