module guild

import libs.discord
import context

struct ParsedCommand {
  cmd  string
  args []string
}

fn parse_prefix_command(content string, bot_id string, pfx string) ?ParsedCommand {
  mention_plain := '<@${bot_id}>'
  mention_nick := '<@!${bot_id}>'

  mut rest := ''
  if content.starts_with(mention_plain) {
    rest = content[mention_plain.len..]
  } else if content.starts_with(mention_nick) {
    rest = content[mention_nick.len..]
  } else if content.len >= pfx.len && content[..pfx.len].to_lower() == pfx.to_lower() {
    rest = content[pfx.len..]
  } else {
    return none
  }

  mut parts := rest.trim_space().fields()
  if parts.len == 0 {
    return none
  }

  cmd := parts[0].to_lower()
  args := if parts.len > 1 { parts[1..] } else { []string{} }
  return ParsedCommand{
    cmd:  cmd
    args: args
  }
}

pub fn (mut h GuildEventHandler) on_message_create(msg discord.Message) {
	if msg.author.bot or { false } { return }

	channel := h.app.client.channels.fetch(msg.channel_id) or {
		h.app.log_error(err.str())
		return
	}

	if channel.channel_type == 1 { return }

	bot := h.app.client.users.me.fetch() or {
		h.app.log_error(err.str())
		return
	}

	parsed := parse_prefix_command(msg.content, bot.id, command_prefix) or { return }

	if parsed.cmd !in h.app.commands {
		return
	}

	mut command := h.app.commands[parsed.cmd]

	mut invocation := context.CommandInvocation.from_message(
		h.app.client, msg, "en", command_prefix, parsed.args
	)

	command.execute(mut h.app, mut invocation) or {
		h.app.log_error("Failed to execute command: ${command.name.join("-")}")
		h.app.log_error(err.str())
		return
	} 
}
