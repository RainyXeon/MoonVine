module guild

import libs.discord
import context

pub fn (mut h GuildEventHandler) on_interaction_create(interaction discord.InteractionCreateEvent) {
	if !interaction.is_command() { return }

	command_name := (interaction.full_command_name('-') or { 'unknown' })

	if command_name !in h.app.commands {
		return
	}

	mut command := h.app.commands[command_name]

	mut invocation := context.CommandInvocation.from_interaction(
		h.app.client, interaction, "en", command_prefix, [],
	) or {
		h.app.log_error(err.str())
		return
	}

	command.execute(mut h.app, mut invocation) or {
		h.app.log_error("Failed to execute command: ${command.name.join("-")}")
		h.app.log_error(err.str())
		return
	} 
}
