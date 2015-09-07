module Socketry
  module IO
    module TcpException
      def read(size)
        timeout.start(:read)

        begin
          socket.read_nonblock(size)
        rescue IO::WaitReadable
          retry if IO.select([socket], nil, nil, timeout.timeout_seconds(:read))
          timeout.reset(:read)
        rescue EOFError
          :eof
        end
      end

      # Write to the socket
      def write(data)
        timeout.start(:write)

        begin
          socket.write_nonblock(data)
        rescue IO::WaitWritable
          retry if IO.select(nil, [socket], nil, timeout.timeout_seconds(:write))
          timeout.reset(:write)
        rescue EOFError
          :eof
        end
      end
    end
  end
end
