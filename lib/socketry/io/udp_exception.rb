module Socketry
  module IO
    module UdpException
      def recvfrom(*args)
        timeout.start(:read)

        begin
          socket.recvfrom_nonblock(*args)
        rescue IO::WaitReadable
          retry if IO.select([socket], nil, nil, timeout.timeout_seconds(:read))
          timeout.reset(:read)
        end
      end
    end
  end
end
