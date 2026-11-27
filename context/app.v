module context

import libs.discord
import configs
import log
import time

@[heap]
pub struct App {
pub:
	client    &discord.Class_BotClient = unsafe { nil }
	configs   configs.Config
	log       &log.ThreadSafeLog = log.new_thread_safe_log()
	stopwatch time.StopWatch
}

pub fn (mut app App) log_debug(msg string) {
	app.log.debug(msg)
	app.log.flush()
}

pub fn (mut app App) log_info(msg string) {
	app.log.info(msg)
	app.log.flush()
}

pub fn (mut app App) log_warn(msg string) {
	app.log.warn(msg)
	app.log.flush()
}

pub fn (mut app App) log_error(msg string) {
	app.log.error(msg)
	app.log.flush()
}

pub fn (mut app App) log_fatal(msg string) {
	app.log.fatal(msg)
}