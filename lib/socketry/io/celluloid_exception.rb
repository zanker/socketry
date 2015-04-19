module Socketry
  module IO
    module CelluloidException
      def read_nonblock(size)
        timeout.start(:read)

        begin
          socket.read_nonblock(size)
        rescue IO::WaitReadable
          if Celluloid::IO.evented?
            socket.wait_readable
          else
            IO.select([socket], nil, nil, timeout.timeout_seconds(:read))
            timeout.reset(:read)
          end
          retry
        end

      rescue EOFError
        :eof
      ensure
        timeout.clear
      end

      def write_nonblock(data)
        timeout.start(:write)

        begin
          socket.write_nonblock(data)
        rescue IO::WaitWritable
          if Celluloid::IO.evented?
            socket.wait_writeable
          else
            IO.select(nil, [socket], nil, timeout.timeout_seconds(:write))
            timeout.reset(:write)
          end
          retry
        end

      rescue EOFError
        :eof
      ensure
        timeout.clear
      end
    end
  end
end
