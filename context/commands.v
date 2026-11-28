module context

import libs.discord
import regex

pub enum AccessableBy {
	member
	owner
	premium
	manager
	admin
	voter
	guild_premium
}

pub fn get_string_accessableby(accessableby AccessableBy) string {
	match accessableby {
		.member { return 'Member' }
		.owner { return 'Owner' }
		.premium { return 'Premium' }
		.manager { return 'Manager' }
		.admin { return 'Admin' }
		.voter { return 'Voter' }
		.guild_premium { return 'GuildPremium' }
		else {
			return 'unknown'
		}
	}
}

pub struct CommandOptionChoiceInterface {
	name  string
	value string
}

pub struct CommandOptionInterface {
	name         string
	description  string
	required     ?bool
	type         discord.ApplicationCommandOptionType
	autocomplete ?bool
	choices      ?[]CommandOptionChoiceInterface
}

pub struct Command {
pub:
	name              []string
	description       string
	category          string
	accessableby      AccessableBy
	usage             string
	aliases           []string
	audio             bool
	player_check      bool
	using_interaction bool
	same_voice_check  bool
	options           []CommandOptionInterface
pub mut:
	execute           fn (mut app App, mut invocation CommandInvocation) !bool = default_execute
}

fn default_execute(mut app App, mut _ CommandInvocation) !bool {
	app.log_error('Command does not implement execute function yet!')
	return true
}

pub type CommandSource = discord.InteractionCreateEvent | discord.Message

pub enum EveryoneTarget {
  everyone
  here
}

pub type MentionResult = discord.User | discord.Channel | discord.Role | EveryoneTarget

enum ReplyState {
  none
  deferred
  sent
}

pub struct ModeLang {
pub:
  enable  string
  disable string
}

pub struct CommandInvocation {
pub:
  source     CommandSource
  client     &discord.Client
  language   string
  prefix     string
  args       []string
  user       discord.User
  guild_id   ?string
  member     ?discord.GuildMember
  channel_id string
  created_at i64
  mode_lang  ModeLang
pub mut:
  attachments []discord.Attachment
  reply_msg   ?discord.Message
  reply_state ReplyState = .none
}

// 3. Explicit constructors instead of constructor getters
pub fn CommandInvocation.from_interaction(
  client &discord.Client,
  ix discord.InteractionCreateEvent,
  lang string,
  prefix string,
  args []string,
) !CommandInvocation {
  user := ix.user or {
    member := ix.member or { return error('Interaction missing user') }
    member.user or { return error('Member missing user') }
  }
  return CommandInvocation{
    source:     ix
    client:     client
    language:   lang
    prefix:     prefix
    args:       args
    user:       user
    guild_id:   ix.guild_id
    member:     ix.member
    channel_id: ix.channel_id or { '' }
    created_at: snowflake_timestamp_ms(ix.id)
  }
}

pub fn CommandInvocation.from_message(
  client &discord.Client,
  msg discord.Message,
  lang string,
  prefix string,
  args []string,
) CommandInvocation {
mut member := ?discord.GuildMember(none)
if gid := msg.guild_id {
	if m := client.guilds.fetch_member(gid, msg.author.id) {
		member = m
	}
}

return CommandInvocation{
	source:      msg
	client:      client
	language:    lang
	prefix:      prefix
	args:        args
	user:        msg.author
	guild_id:    msg.guild_id
	member:      member
	channel_id:  msg.channel_id
	created_at:  snowflake_timestamp_ms(msg.id)
	attachments: msg.attachments.clone()
}
}

// fn resolve_mode_lang(client &discord.BotClient, lang string) ModeLang {
//   return ModeLang{
//     enable:  client.i18n.get(lang, 'global', 'enable')
//     disable: client.i18n.get(lang, 'global', 'disable')
//   }
// }

// 4. Unified response methods using `match` on the sum type
pub fn (mut c CommandInvocation) send(params discord.CreateMessageParams) ! {
  match c.source {
    discord.InteractionCreateEvent {
      c.source.reply(params)!
    }
    discord.Message {
      c.reply_msg = c.source.reply(params)!
    }
  }
  c.reply_state = .sent
}

pub fn (mut c CommandInvocation) follow_up(params discord.CreateMessageParams) !discord.Message {
  match c.source {
    discord.InteractionCreateEvent {
      return c.source.follow_up(params)!
    }
    discord.Message {
      return c.source.reply(params)!
    }
  }
}

pub fn (mut c CommandInvocation) defer_reply() ! {
  if c.reply_state != .none {
    return
  }
  match c.source {
    discord.InteractionCreateEvent {
      c.source.defer_reply(true)!
    }
    discord.Message {
			user := c.client.users.me.fetch() or {
				return err
			}

      thinking := '**${user.username}** is thinking...'
      c.reply_msg = c.source.reply(discord.CreateMessageParams{ content: thinking })!
    }
  }
  c.reply_state = .deferred
}

pub fn (mut c CommandInvocation) edit_reply(params discord.EditMessageParams) ! {
  if c.reply_state == .none {
    return error('Cannot edit reply before send() or defer_reply()')
  }
  match c.source {
    discord.InteractionCreateEvent {
      c.source.edit_reply(params)!
    }
    discord.Message {
      mut msg := c.reply_msg or { return error('Missing tracked reply message') }
      // Explicitly clear "thinking..." text if replacing with embeds only
      mut clean_params := params
      if embeds := clean_params.embeds {
        if embeds.len > 0 && (clean_params.content or { '' }).len == 0 {
          clean_params.content = ''
        }
      }
      c.reply_msg = msg.edit(clean_params)!
    }
  }
}

// 5. Mention parser returning `!MentionResult` instead of `{ type: ERROR, data: 'error' }`
pub fn (c &CommandInvocation) parse_mention(raw string) !MentionResult {
  if id := extract_snowflake(raw, r'^<@!?(\d{17,19})>$') {
    return c.client.users.fetch(id)!
  }
  if id := extract_snowflake(raw, r'^<#(\d{17,19})>$') {
    return c.client.channels.fetch(id)!
  }
  if id := extract_snowflake(raw, r'^<@&(\d{17,19})>$') {
    gid := c.guild_id or { return error('Role mentions require a guild context') }
    return c.client.guilds.fetch_role(gid, id)!
  }
  if raw == '@everyone' {
    return EveryoneTarget.everyone
  }
  if raw == '@here' {
    return EveryoneTarget.here
  }
  return error('Invalid mention format: ${raw}')
}

fn extract_snowflake(input string, pattern string) ?string {
  mut re := regex.regex_opt(pattern) or { return none }
  start, _ := re.match_string(input)
  if start < 0 {
    return none
  }
  return re.get_group_by_id(input, 0)
}

pub fn (mut c CommandInvocation) add_attachments(items []discord.Attachment) {
  c.attachments << items
}

fn snowflake_timestamp_ms(id string) i64 {
  return i64((id.u64() >> 22) + 1420070400000)
}