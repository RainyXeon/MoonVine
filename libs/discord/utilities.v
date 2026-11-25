module discord

import os
import encoding.base64
import json2
import net.http

pub type ImageData = string

pub enum ImageFormat {
	png
	jpeg
	gif
}

pub fn ImageData.from_file(path string) !ImageData {
	bytes := os.read_bytes(path)!
	ext := os.file_ext(path).to_lower()
	mime := match ext {
		'.png' { 'image/png' }
		'.jpg', '.jpeg' { 'image/jpeg' }
		'.gif' { 'image/gif' }
		else { return error('Unsupported image extension: ${ext}') }
	}
	encoded := base64.encode(bytes)
	return ImageData('data:${mime};base64,${encoded}')
}

pub fn ImageData.from_bytes(bytes []u8, format ImageFormat) ImageData {
	mime := match format {
		.png { 'image/png' }
		.jpeg { 'image/jpeg' }
		.gif { 'image/gif' }
	}
	encoded := base64.encode(bytes)
	return ImageData('data:${mime};base64,${encoded}')
}

// check_response turns Discord's HTTP error response into its structured API
// error before a caller attempts to decode the body as a success payload.
pub fn check_response(res http.Response) ! {
	if res.status_code >= 200 && res.status_code < 300 {
		return
	}
	if api_err := parse_discord_error(res.body) {
		return error(api_err.pretty())
	}
	return error('Discord HTTP Error [${res.status_code}]: ${res.body}')
}

// decode_response validates the HTTP status and decodes a JSON response.
pub fn decode_response[T](res http.Response) !T {
	check_response(res)!
	return json2.decode[T](res.body) or {
		return error('Failed to decode Discord response: ${err}')
	}
}

// decode_response_list validates and decodes a JSON array response.
pub fn decode_response_list[T](res http.Response) ![]T {
	check_response(res)!
	return json2.decode[[]T](res.body) or {
		return error('Failed to decode Discord response: ${err}')
	}
}
