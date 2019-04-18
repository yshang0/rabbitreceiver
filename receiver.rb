
# require 'sinatra'
# require 'bunny'

# connection = Bunny.new ENV['CLOUDAMQP_URL']

# # connection = Bunny.new(host:  'localhost',
# #                   port:  '5672',
# #                   vhost: '/',
# #                   user:  'guest',
# #                   pass:  'guest')


# get '/' do

# 	connection.start
# 	channel = connection.create_channel
# 	queue = channel.queue('hello')

# 	# begin
# 	puts ' [*] Waiting for messages. To exit press CTRL+C'
# 	queue.subscribe(block: true) do |_delivery_info, _properties, body|
# 		puts " [x] Received #{body}"
# 		@information=body
# 	end

# 	# end
# 	# rescue Interrupt => _
# 	# 	connection.close
# 	# 	exit(0)
# 	# end

# 	connection.close

# 	# redirect '/'

# end

require 'sinatra'
require 'sinatra/streaming'
require 'haml'
require 'amqp'

configure do
  disable :logging
  EM.next_tick do
    # Connect to CloudAMQP and set the default connection
    url = ENV['CLOUDAMQP_URL'] || "amqp://guest:guest@localhost"
    AMQP.connection = AMQP.connect url
    PUB_CHAN = AMQP::Channel.new
  end
end


get '/stream' do
    PUB_CHAN.queue('', exclusive: true) do |queue|
        # create a queue and bind it to the fanout exchange
        queue.bind(channel.fanout("f1")).subscribe do |payload|
          out << "data: #{payload}\n\n"
          @info = payload
        end
      end
    PUB_CHAN.close
    erb :show
end



