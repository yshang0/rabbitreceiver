require 'bunny'

connection = Bunny.new ENV['CLOUDAMQP_URL']

connection.start
channel = connection.create_channel
queue = channel.queue('hello')

begin
	puts ' [*] Waiting for messages. To exit press CTRL+C'
	queue.subscribe(block: true) do |_delivery_info, _properties, body|
		puts " [x] Received #{body}"
	end

rescue Interrupt => _
	connection.close

	exit(0)
end


# (host:  'localhost',
#                   port:  '5672',
#                   vhost: '/',
#                   user:  'guest',
#                   pass:  'guest')