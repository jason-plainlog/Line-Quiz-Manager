require 'sinatra'
require 'redis'

class MyApp < Sinatra::Application
	redis = Redis.new(db:1)

	get '/' do
		"Hello, This is 試務官"
	end

	post '/webhook' do
		status 200
	end
end
