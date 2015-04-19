# Ruby 2.1+ (and JRuby 9k+) support NIO without exceptions.
# It's around 50% faster in MRI / ~80% in JRuby than exceptions.
module Socketry
  module IO
    module Fast
      # Read from the socket
      def read_nonblock(size)
        timeout.start(:read)

        loop do
          value = socket.read_nonblock(size, exception: false)
          break value unless value == :wait_readable

          IO.select([socket], nil, nil, timeout.timeout_seconds(:read))
          timeout.reset(:read)
        end
      end

      # Write to the socket
      def write_nonblock(data)
        timeout.start(:write)

        loop do
          value = socket.write_nonblock(data, exception: false)
          break unless value == :wait_writable

          IO.select(nil, [socket], nil, timeout.timeout_seconds(:write))
          timeout.reset(:write)
        end
      end
    end
  end
end
