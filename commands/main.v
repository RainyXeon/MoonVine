module commands

import context
import commands.info

pub fn register_commands(mut app context.App) {
	app.log_info("[Command Register] Starting to register commands...")
	info.register_commands(mut app)
	app.log_info("[Command Register] Finished register commands! Total: ${app.commands.len}")
}