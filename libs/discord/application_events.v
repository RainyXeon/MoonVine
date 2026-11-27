module discord

pub struct InteractionCreateEvent {
pub mut:
	client  ?&Class_BotClient @[skip]
	message ?Message
pub:
	id                             string
	application_id                 string
	interaction_type               int @[json: 'type']
	data                           ?InteractionData
	guild_id                       ?string
	channel                        ?Channel
	channel_id                     ?string
	member                         ?GuildMember
	user                           ?User
	token                          string
	version                        int
	app_permissions                ?string
	locale                         ?string
	guild_locale                   ?string
	entitlements                   ?[]Entitlement
	authorizing_integration_owners ?map[string]string
	context                        ?int
}

pub struct ApplicationCommandPermissionsUpdateEvent {
pub:
	id             string
	application_id string
	guild_id       string
	permissions    []ApplicationCommandPermission
}

pub struct ApplicationCommandPermission {
pub:
	id         string
	perm_type  int @[json: 'type']
	permission bool
}

pub type InteractionReplyPayload = string | InteractionCallbackData

fn (p InteractionReplyPayload) to_callback_data() InteractionCallbackData {
	return match p {
		string {
			InteractionCallbackData{
				content: p
			}
		}
		InteractionCallbackData {
			p
		}
	}
}

// reply responds immediately (callback type 4: channel_message_with_source).
pub fn (i &InteractionCreateEvent) reply(payload InteractionReplyPayload) ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 4
		data:          payload.to_callback_data()
	})!
}

// reply_ephemeral responds immediately with an ephemeral message (flags: 64).
pub fn (i &InteractionCreateEvent) reply_ephemeral(payload InteractionReplyPayload) ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	mut data := payload.to_callback_data()
	data.flags = (data.flags or { 0 }) | 64
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 4
		data:          data
	})!
}

// defer_reply acknowledges the interaction (callback type 5) so you have 15 minutes to edit_reply().
pub fn (i &InteractionCreateEvent) defer_reply(ephemeral bool) ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 5
		data:          if ephemeral {
			InteractionCallbackData{
				flags: 64
			}
		} else {
			none
		}
	})!
}

pub fn (i &InteractionCreateEvent) edit_reply(payload MessageEditPayload) !Message {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	return c.interactions.edit_original_response(i.application_id, i.token, payload.to_params())
}

pub fn (i &InteractionCreateEvent) delete_reply() ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.delete_original_response(i.application_id, i.token)!
}

pub fn (i &InteractionCreateEvent) follow_up(payload MessagePayload) !Message {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	return c.interactions.create_followup(i.application_id, i.token, payload.to_params())
}

pub fn (i &InteractionCreateEvent) update_message(payload InteractionReplyPayload) ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 7
		data:          payload.to_callback_data()
	})!
}

pub fn (i &InteractionCreateEvent) defer_update() ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 6
	})!
}

pub fn (i &InteractionCreateEvent) show_modal(modal InteractionCallbackData) ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 9
		data:          modal
	})!
}

pub fn (i &InteractionCreateEvent) autocomplete(choices []ApplicationCommandOptionChoice) ! {
	c := i.client or { return error('InteractionCreateEvent is not bound to a Class_BotClient') }
	c.interactions.create_response(i.id, i.token, InteractionResponse{
		response_type: 8
		data:          InteractionCallbackData{
			choices: choices
		}
	})!
}

pub fn (i &InteractionCreateEvent) is_command() bool {
	return i.interaction_type == 2
}

pub fn (i &InteractionCreateEvent) is_component() bool {
	return i.interaction_type == 3
}

pub fn (i &InteractionCreateEvent) is_autocomplete() bool {
	return i.interaction_type == 4
}

pub fn (i &InteractionCreateEvent) is_modal() bool {
	return i.interaction_type == 5
}

pub fn (i &InteractionCreateEvent) author() ?User {
	if member := i.member {
		return member.user
	}
	return i.user
}

pub fn (i &InteractionCreateEvent) command_name() ?string {
  data := i.data or { return none }
  return data.name
}

pub fn (i &InteractionCreateEvent) subcommand_group_name() ?string {
  data := i.data or { return none }
  options := data.options or { return none }
  for opt in options {
    if opt.option_type == 2 {
      return opt.name
    }
  }
  return none
}

pub fn (i &InteractionCreateEvent) subcommand_name() ?string {
  data := i.data or { return none }
  options := data.options or { return none }
  for opt in options {
    if opt.option_type == 1 {
      return opt.name
    }
    if opt.option_type == 2 {
      sub_options := opt.options or { continue }
      for sub_opt in sub_options {
        if sub_opt.option_type == 1 {
          return sub_opt.name
        }
      }
    }
  }
  return none
}

// full_command_name returns the space-joined command path (e.g., "config", "config set", or "config roles add").
pub fn (i &InteractionCreateEvent) full_command_name(join_string string) ?string {
  cmd := i.command_name() or { return none }
  mut parts := [cmd]
  if group := i.subcommand_group_name() {
    parts << group
  }
  if sub := i.subcommand_name() {
    parts << sub
  }
  return parts.join(join_string)
}

// resolved_options unwraps any subcommand group / subcommand wrapper and returns the leaf arguments.
pub fn (i &InteractionCreateEvent) resolved_options() []InteractionDataOption {
  data := i.data or { return [] }
  mut opts := data.options or { return [] }
  if opts.len > 0 && opts[0].option_type == 2 {
    opts = opts[0].options or { return [] }
  }
  if opts.len > 0 && opts[0].option_type == 1 {
    opts = opts[0].options or { return [] }
  }
  return opts
}

pub struct IntegrationCreateUpdateEvent {
pub:
	id                  string
	name                string
	integration_type    string @[json: 'type']
	enabled             bool
	syncing             ?bool
	role_id             ?string
	enable_emoticons    ?bool
	expire_behavior     ?int
	expire_grace_period ?int
	user                ?User
	account             IntegrationAccount
	synced_at           ?string
	subscriber_count    ?int
	revoked             ?bool
	application         ?IntegrationApplication
	scopes              ?[]string
	guild_id            string
}
