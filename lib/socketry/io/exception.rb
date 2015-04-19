module Socketry
  module IO
    module Exception
      def read_nonblock(size)
        timeout.start(:read)

        begin
          socket.read_nonblock(size)
        rescue IO::WaitReadable
          IO.select([socket], nil, nil, timeout.timeout_seconds(:read))
          timeout.reset(:read)
          retry
        rescue EOFError
          :eof
        end
      end

      # Write to the socket
      def write_nonblock(data)
        timeout.start(:write)

        begin
          socket.write_nonblock(data)
        rescue IO::WaitWritable
          IO.select(nil, [socket], nil, timeout.timeout_seconds(:write))
          timeout.reset(:write)
          retry

        rescue EOFError
          :eof
        end
      end
    end
  end
end
