module discord

import json2
import net.http
import net.urllib

pub struct Emoji {
pub:
	id             ?string
	name           ?string
	roles          ?[]string
	user           ?User
	require_colons ?bool
	managed        ?bool
	animated       ?bool
	available      ?bool
}

pub struct CreateGuildEmojiParams {
pub mut:
	name  string
	image ImageData // Data URI scheme (e.g. data:image/png;base64,...)
	roles ?[]string
}

pub struct ModifyGuildEmojiParams {
pub mut:
	name  ?string
	roles ?[]string
}

pub struct Class_Emojis {
pub:
	endpoint string = '/guilds'
pub mut:
	bc &Class_BotClient
}

pub fn new_class_emojis(bc &Class_BotClient) &Class_Emojis {
	return &Class_Emojis{ bc: bc }
}

pub fn (this &Class_Emojis) fetch_all(guild_id string) ![]Emoji {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/emojis', http.FetchConfig{})!
	return decode_response_list[Emoji](res)
}

pub fn (this &Class_Emojis) fetch(guild_id string, emoji_id string) !Emoji {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/emojis/${emoji_id}', http.FetchConfig{})!
	return decode_response[Emoji](res)
}

pub fn (this &Class_Emojis) create(guild_id string, data CreateGuildEmojiParams, reason ?string) !Emoji {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}

	res := this.bc.raw_request(.post, '${this.endpoint}/${guild_id}/emojis', http.FetchConfig{
		header: header
		data:   json2.encode(data)
	})!
	return decode_response[Emoji](res)
}

pub fn (this &Class_Emojis) edit(guild_id string, emoji_id string, data ModifyGuildEmojiParams, reason ?string) !Emoji {
	mut header := http.new_header()
	if value := reason {
		header.add_custom('X-Audit-Log-Reason', urllib.query_escape(value))!
	}

	res := this.bc.raw_request(.patch, '${this.endpoint}/${guild_id}/emojis/${emoji_id}', http.FetchConfig{
		header: header
		data:   json2.encode(data)
	})!
	return decode_response[Emoji](res)
}

pub fn (this &Class_Emojis) delete(guild_id string, emoji_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/emojis/${emoji_id}', http.FetchConfig{})!
	check_response(res)!
}
