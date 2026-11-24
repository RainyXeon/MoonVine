module main

import libs.discord
import configs

pub fn main() {
	config_data := configs.reader() or {
		eprintln('app.yml is missing')
		return
	}

	mut client := discord.new_bot_client().login(config_data.bot.token)

	res1 := client.application.fetch() or {
		eprintln(err)
		return
	}

	println(res1)

	res2 := client.users.fetch('898728768791789628') or {
		eprintln(err)
		return
	}

	println(res2)

	res3 := client.users.me.fetch() or {
		eprintln(err)
		return
	}

	println(res3)
}
