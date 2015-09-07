module Socketry
  class UDPSocket
    include IO::UdpException
    extend Forwardable

    def_delegators :@socket, :addr, :bind, :close, :send, :closed?

    def initialize(options = {})
      @timeout = options[:timeout_instance] || Timeout::Base::CLASSES.fetch(options[:timeout]).new(
        options.slice(:global_timeout, :connect_timeout, :read_timeout, :write_timeout)
      )

      @socket = UDPSocket.new(options.fetch(:family))
    end

    def self.open(options)
      socket = self.new(options)
      yield socket
    ensure
      socket.close if socket
    end

    alias_method :recvfrom_nonblock, :recvfrom

    private

    attr_reader :socket, :timeout
  end
end
