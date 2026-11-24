module configs

import yaml

pub struct BotConfig {
pub:
	token string
}

pub struct Config {
pub:
	bot BotConfig
}

pub fn reader() !Config {
	return yaml.decode_file[Config]('app.yml')
}
