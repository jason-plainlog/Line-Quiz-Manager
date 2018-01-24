require 'sinatra'
require 'line/bot'
require 'redis'

class MyApp < Sinatra::Application
	redis = Redis.new(db:1)

	get '/' do
		"Hello, This is 試務官"
	end

	post '/webhook' do
		client = Line::Bot::Client.new { |config|
			config.channel_secret = 'cb28a06983cf5e153656107c83f82ee7',
			config.channer_token = 'xnich5DiM9M93HylaU+N8zLX1A5KwVCdgawIb1Z0YYAxIYM7S/+Hnrv6ZG3woopl8PYZ3RrUUT50f6Kqh8IdJUow9QPHUEd2dVv6eJPM8n1XJ3Cp3XCbb06ws4zei7HBX9mY06KYOgrkHlK67QfNHQdB04t89/1O/w1cDnyilFU='
		}

		reply_token = params['events'][0]['replyToken']

		message = {
			type: 'text',
			text: '已讀'
		}

		response = client.reply_message(reply_token, message)

		status 200
	end
end
