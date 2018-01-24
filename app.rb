require 'sinatra'
require 'line/bot'
require 'redis'

class MyApp < Sinatra::Application
	$redis = Redis.new(db:1)

	def set_quiz(date, content)
		$redis.set(date, "[]") if !$redis.exists(date)

		data = JSON.parse($redis.get(date));
		data.push(content)

		$redis.set(date, JSON.generate(data))
	end

	def search_quiz(date)
		data = $redis.get(date)

		return [] if data == nil
		
		return JSON.parse(data)
	end

	get '/' do
		"Hello, This is 試務官"
	end

	post '/webhook' do
		client = Line::Bot::Client.new { |config|
			config.channel_secret = 'cb28a06983cf5e153656107c83f82ee7'
			config.channel_token = 'xnich5DiM9M93HylaU+N8zLX1A5KwVCdgawIb1Z0YYAxIYM7S/+Hnrv6ZG3woopl8PYZ3RrUUT50f6Kqh8IdJUow9QPHUEd2dVv6eJPM8n1XJ3Cp3XCbb06ws4zei7HBX9mY06KYOgrkHlK67QfNHQdB04t89/1O/w1cDnyilFU='
		}

		data = JSON.parse(request.body.read.to_s)

		reply_token = data['events'][0]['replyToken']
		text = data['events'][0]['message']['text'].split

		halt 200 if text[0] != "試務官" && text[0] != "考試長" || text.length != 2 && text.length != 3

		message = {
			type: 'text',
			text: ''
		}

		if text.length == 2
			quizs = search_quiz(text[1])

			message['text'] = text[1] + ":\n"

			if quizs.length != 0
				for quiz in quizs do
					message['text'] += quiz + "\n"
				end
			end

			message['text'] = '沒有考試是在查屁查啦❤️' if quizs.length == 0
		elsif text.length == 3
			set_quiz(text[1], text[2])
			message['text'] = '新增完畢❤️'
		end

		response = client.reply_message(reply_token, message)

		status 200
	end
end
