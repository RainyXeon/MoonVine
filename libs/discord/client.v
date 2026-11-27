module discord

module discord

import net.http
import net.websocket
import rand
import time
import x.json2

pub struct LobbyMemberInput {
pub mut:
	id       string
	metadata ?map[string]string
	flags    ?int // e.g., 1 << 0 (CAN_LINK_LOBBY)
}

pub struct CreateLobbyParams {
pub mut:
	metadata             ?map[string]string
	members              ?[]LobbyMemberInput
	idle_timeout_seconds ?int // 5 to 604800 seconds (7 days)
}

pub struct ModifyLobbyParams {
pub mut:
	metadata             ?map[string]string
	members              ?[]LobbyMemberInput
	idle_timeout_seconds ?int
}

@[heap]
pub struct Class_BotClient {
	api_base_url string = 'https://discord.com/api'
	api_version  string = '10'
mut:
	token           string
	gateway_intents u32 = GatewayIntent.default_non_privileged()
	user_token      bool
	base_url        string
pub mut:
	events          GatewayEvents
	application     &Class_Application    = unsafe { nil }
	users           &Class_Users          = unsafe { nil }
	channels        &Class_Channels       = unsafe { nil }
	guilds          &Class_Guilds         = unsafe { nil }
	invites         &Class_Invites        = unsafe { nil }
	webhooks        &Class_Webhooks       = unsafe { nil }
	entitlements    &Class_Entitlements   = unsafe { nil }
	auto_moderation &Class_AutoModeration = unsafe { nil }
	emojis          &Class_Emojis         = unsafe { nil }
	gateway         &Class_Gateway        = unsafe { nil }
	ws              &websocket.Client     = unsafe { nil }
}

pub fn new_class_bot_client() &Class_BotClient {
	mut bc := &Class_BotClient{}
	bc.application = new_class_application(bc)
	bc.users = new_class_users(bc)
	bc.channels = new_class_channels(bc)
	bc.guilds = new_class_guilds(bc)
	bc.invites = new_class_invites(bc)
	bc.webhooks = new_class_webhooks(bc)
	bc.entitlements = new_class_entitlements(bc)
	bc.auto_moderation = new_class_auto_moderation(bc)
	bc.emojis = new_class_emojis(bc)
	return bc
}

pub fn (this Class_BotClient) api_url() string {
	return '${this.api_base_url}/v${this.api_version}'
}

pub fn (mut this Class_BotClient) login_user(token string) &Class_BotClient {
	this.token = token
	this.user_token = true
	return this
}

pub fn (mut this Class_BotClient) api_base(url string) &Class_BotClient {
	this.base_url = url.trim_right('/')
	return this
}

pub fn (mut this Class_BotClient) intents(intents u32) &Class_BotClient {
	this.gateway_intents = intents
	return this
}

pub fn (mut this Class_BotClient) login(token string) !&Class_BotClient {
  this.user_token = false
  this.token = token
  this.gateway = new_gateway(this, this.gateway_intents)
  this.gateway.listener.events = this.events

  for {
    this.gateway.listener.last_error = none
    target_url := if this.gateway.session_id != '' && this.gateway.resume_gateway_url != '' {
      this.gateway.resume_gateway_url
    } else {
      info := this.fetch_gateway() or {
        this.gateway.state = .reconnecting
        this.gateway.listener.emit_error(GatewayError{
          message: 'Failed to fetch gateway: ${err}'
        })
        backoff_sec := if this.gateway.reconnect_attempt > 5 {
          30
        } else {
          1 << this.gateway.reconnect_attempt
        }
        this.gateway.reconnect_attempt++
        time.sleep(backoff_sec * time.second)
        continue
      }
      info.url
    }

    this.ws = this.gateway.listener.connect(target_url) or {
      this.gateway.state = .reconnecting
      this.gateway.listener.emit_error(GatewayError{
        message: 'Connect failed: ${err}'
      })
      backoff_sec := if this.gateway.reconnect_attempt > 5 {
        30
      } else {
        1 << this.gateway.reconnect_attempt
      }
      this.gateway.reconnect_attempt++
      time.sleep(backoff_sec * time.second)
      continue
    }

    spawn this.start_heartbeat_loop()
    this.gateway.listener.listen(mut this.ws) or {}

    if this.gateway.state == .closed {
      if err := this.gateway.listener.last_error {
        if err.code != 1000 {
          return error(err.str())
        }
      }
      break
    }

    backoff_sec := if this.gateway.reconnect_attempt > 5 {
      30
    } else {
      1 << this.gateway.reconnect_attempt
    }
    this.gateway.listener.emit_debug('Reconnecting in ${backoff_sec}s...')
    time.sleep(backoff_sec * time.second)
  }

  return this
}

fn (mut this Class_BotClient) start_heartbeat_loop() {
  for this.gateway.heartbeat_interval <= 0
    && this.gateway.state !in [.closed, .reconnecting] {
    time.sleep(50 * time.millisecond)
  }
  if this.gateway.state in [.closed, .reconnecting] {
    return
  }

  jitter_ms := int(f64(this.gateway.heartbeat_interval) * rand.f64())
  time.sleep(jitter_ms * time.millisecond)

  for this.gateway.state !in [.closed, .reconnecting] {
    this.gateway.listener.heartbeat(mut this.ws, time.now().unix_milli()) or {
      this.gateway.listener.emit_error(GatewayError{
        message: 'Heartbeat error: ${err}'
      })
      break
    }
    time.sleep(250 * time.millisecond)
  }
}

pub fn (this &Class_BotClient) fetch_lobby(lobby_id string) !Lobby {
	res := this.raw_request(.get, '/lobbies/${lobby_id}', http.FetchConfig{})!
	return decode_response[Lobby](res)
}

pub fn (this &Class_BotClient) create_lobby(data CreateLobbyParams) !Lobby {
	res := this.raw_request(.post, '/lobbies', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[Lobby](res)
}

pub fn (this &Class_BotClient) edit_lobby(lobby_id string, data ModifyLobbyParams) !Lobby {
	res := this.raw_request(.patch, '/lobbies/${lobby_id}', http.FetchConfig{
		data: json2.encode(data)
	})!
	return decode_response[Lobby](res)
}

pub fn (this &Class_BotClient) delete_lobby(lobby_id string) ! {
	res := this.raw_request(.delete, '/lobbies/${lobby_id}', http.FetchConfig{})!
	check_response(res)!
}

pub fn (mut this Class_BotClient) raw_request(method http.Method, route string, override_config http.FetchConfig) !http.Response {
	if this.token.len == 0 {
		return error('BOT_TOKEN_NOT_FOUND')
	}

	mut header := http.new_header()
	header.add(.content_type, 'application/json')
	header.add(.authorization, if auth := override_config.header.get(.authorization) {
		auth
	} else if this.user_token {
		this.token
	} else {
		'Bot ' + this.token
	})

	base_fetch_config := http.FetchConfig{
		url:    if this.base_url != '' { this.base_url + route } else { this.api_url() + route }
		method: method
		header: header
	}

	final_cfg := merge_fetch_config(base_fetch_config, override_config) or {
		return err
	}

	res := http.fetch(final_cfg) or {
		return err
	}

	return res
}

pub fn merge_fetch_config(base http.FetchConfig, override http.FetchConfig) !http.FetchConfig {
	mut merged_cookies := base.cookies.clone()
	for k, v in override.cookies {
		merged_cookies[k] = v
	}

	mut merged_header := base.header
	for key in override.header.keys() {
		vals := override.header.custom_values(key)
		for i, val in vals {
			if i == 0 {
				merged_header.set_custom(key, val)!
			} else {
				merged_header.add_custom(key, val)!
			}
		}
	}

	return http.FetchConfig{
		...base
		url:            if override.url != '' { override.url } else { base.url }
		method:         if override.method != .get { override.method } else { base.method }
		data:           if override.data != '' { override.data } else { base.data }
		user_agent:     if override.user_agent != '' {
			override.user_agent
		} else {
			base.user_agent
		}
		verbose:        override.verbose || base.verbose
		allow_redirect: override.allow_redirect
		max_retries:    if override.max_retries != 0 {
			override.max_retries
		} else {
			base.max_retries
		}
		read_timeout:   if override.read_timeout != 0 {
			override.read_timeout
		} else {
			base.read_timeout
		}
		write_timeout:  if override.write_timeout != 0 {
			override.write_timeout
		} else {
			base.write_timeout
		}
		enable_http2:   override.enable_http2 || base.enable_http2
		header:         merged_header
		cookies:        merged_cookies
	}
}
