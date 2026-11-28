module info

import context

pub fn register_commands(mut app context.App) {
	app.log_info("[Command Register] Register [Info] category commands.")
	app.add_command(new_info_ping_command())
}