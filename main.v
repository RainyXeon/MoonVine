module main

import model
import events
import libs.discord
import configs
import log
import time

pub fn main() {
	// INFO: Setting up stop watch for speed measurement
	stopwatch := time.new_stopwatch()

	// INFO: Setting up config data
	config_data := configs.reader() or {
		eprintln('app.yml is missing')
		return
	}

	// INFO: Setting up main model
	mut moonvine := &model.MoonVine{
		client:    discord.new_class_bot_client()
		configs:   config_data
		stopwatch: stopwatch
	}

	// INFO: Setting up log system
	moonvine.log.set_time_format(log.TimeFormat.tf_rfc3339)
	moonvine.log.set_full_logpath('./moonvine.log')
	moonvine.log.log_to_console_too()

	// INFO: Setting up client
	moonvine.log.info('Booting MoonVine...')
	moonvine.client.intents(discord.GatewayIntent.default_with(.guilds, .guild_messages, .message_content))

	// INFO: Setting up events
	events.register(mut moonvine)

	elapsed := moonvine.stopwatch.elapsed()
	moonvine.log.info('MoonVine finished initializing! Time taken: ${elapsed.microseconds()} µs (${elapsed.milliseconds()} ms)')

	// INFO: Login client
	moonvine.client.login(config_data.bot.token)!
}
