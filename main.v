module main

import context
import events
import libs.discord
import configs
import log
import time
import commands

pub fn main() {
	// INFO: Setting up stop watch for speed measurement
	stopwatch := time.new_stopwatch()

	// INFO: Setting up config data
	config_data := configs.reader() or {
		eprintln('app.yml is missing')
		return
	}

	// INFO: Setting up main context
	mut app := &context.App{
		client:    discord.new_class_bot_client()
		configs:   config_data
		stopwatch: stopwatch
	}

	// INFO: Setting up log system
	app.log.set_time_format(log.TimeFormat.tf_rfc3339)
	app.log.set_full_logpath('./app.log')
	app.log.log_to_console_too()

	// INFO: Setting up client
	app.log_info('Booting application...')
	app.client.intents(discord.GatewayIntent.default_with(.guilds, .guild_messages, .message_content))

	// INFO: Register commands
	commands.register_commands(mut app)

	// INFO: Setting up events
	events.register(mut app)

	elapsed := app.stopwatch.elapsed()
	app.log_info('Finished initializing! Time taken: ${elapsed.microseconds()} µs (${elapsed.milliseconds()} ms)')

	// INFO: Login client
	app.client.login(config_data.bot.token) or {
		app.log_fatal('Bot stopped: ${err}')
		return
	}
}
