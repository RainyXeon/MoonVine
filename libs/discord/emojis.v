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

pub struct EmojiClient {
pub:
	endpoint string = '/guilds'
pub mut:
	bc &Client
}

pub fn new_emoji_client(bc &Client) &EmojiClient {
	return &EmojiClient{ bc: bc }
}

pub fn (this &EmojiClient) fetch_all(guild_id string) ![]Emoji {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/emojis', http.FetchConfig{})!
	return decode_response_list[Emoji](res)
}

pub fn (this &EmojiClient) fetch(guild_id string, emoji_id string) !Emoji {
	res := this.bc.raw_request(.get, '${this.endpoint}/${guild_id}/emojis/${emoji_id}', http.FetchConfig{})!
	return decode_response[Emoji](res)
}

pub fn (this &EmojiClient) create(guild_id string, data CreateGuildEmojiParams, reason ?string) !Emoji {
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

pub fn (this &EmojiClient) edit(guild_id string, emoji_id string, data ModifyGuildEmojiParams, reason ?string) !Emoji {
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

pub fn (this &EmojiClient) delete(guild_id string, emoji_id string) ! {
	res := this.bc.raw_request(.delete, '${this.endpoint}/${guild_id}/emojis/${emoji_id}', http.FetchConfig{})!
	check_response(res)!
}
