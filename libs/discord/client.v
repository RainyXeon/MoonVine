module discord

import net.http

@[heap]
pub struct Class_BotClient {
	api_base_url string = 'https://discord.com/api'
	api_version  string = '10'
mut:
	token string
pub mut:
	application &Class_Application = unsafe { nil }
	users       &Class_Users       = unsafe { nil }
}

pub fn new_bot_client() &Class_BotClient {
	mut bc := &Class_BotClient{}
	bc.application = new_application(bc)
	bc.users = new_users(bc)
	return bc
}

pub fn (this Class_BotClient) api_url() string {
	return '${this.api_base_url}/v${this.api_version}'
}

pub fn (mut this Class_BotClient) login(token string) &Class_BotClient {
	this.token = token
	return this
}

pub fn (mut this Class_BotClient) raw_request(method http.Method, route string, override_config http.FetchConfig) !http.Response {
	if this.token.len == 0 {
		return error('BOT_TOKEN_NOT_FOUND')
	}

	mut header := http.new_header()
	header.add(.content_type, 'application/json')
	header.add(.authorization, 'Bot ' + this.token)

	base_fetch_config := http.FetchConfig{
		url:    this.api_url() + route
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
