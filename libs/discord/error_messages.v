module discord

import json2

pub struct DiscordErrorDetail {
pub:
	code    string
	message string
}

pub struct DiscordApiError {
pub:
	code    int
	message string
	details map[string][]DiscordErrorDetail
}

pub fn (e DiscordApiError) msg() string {
	return e.pretty()
}

pub fn (e DiscordApiError) code() int {
	return e.code
}

pub fn (e DiscordApiError) pretty() string {
	mut lines := ['Discord API Error [${e.code}]: ${e.message}']
	for path, errs in e.details {
		label := if path == '' { 'root' } else { path }
		for err in errs {
			lines << '  • ${label} -> [${err.code}] ${err.message}'
		}
	}
	return lines.join('\n')
}

pub fn parse_discord_error(raw string) ?DiscordApiError {
	doc := json2.decode[json2.Any](raw) or { return none }
	root := doc.as_map()

	if 'code' !in root || 'message' !in root {
		return none
	}

	code_val := root['code'] or { return none }
	msg_val := root['message'] or { return none }

	err_code := code_val.int()
	err_msg := msg_val.str()
	if err_code == 0 || err_msg.len == 0 {
		return none
	}

	mut details := map[string][]DiscordErrorDetail{}
	if errors_val := root['errors'] {
		collect_errors(errors_val, '', mut details)
	}

	return DiscordApiError{
		code:    err_code
		message: err_msg
		details: details
	}
}

fn collect_errors(node json2.Any, path string, mut out map[string][]DiscordErrorDetail) {
	match node {
		map[string]json2.Any {
			for k, v in node {
				if k == '_errors' {
					arr := v.as_array()
					for item in arr {
						item_map := item.as_map()
						c := (item_map['code'] or { json2.Any('') }).str()
						m := (item_map['message'] or { json2.Any('') }).str()
						out[path] << DiscordErrorDetail{
							code:    c
							message: m
						}
					}
				} else {
					next_path := if path == '' { k } else { '${path}.${k}' }
					collect_errors(v, next_path, mut out)
				}
			}
		}
		[]json2.Any {
			for i, v in node {
				next_path := if path == '' { '${i}' } else { '${path}[${i}]' }
				collect_errors(v, next_path, mut out)
			}
		}
		else {}
	}
}
