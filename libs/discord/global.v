module discord

import os
import encoding.base64

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
