module Socketry
  class TCPSocket
    include RUBY_VERISON >= "2.1.0" ? IO::TcpFast : IO::TcpException
    extend Forwardable

    def_delegators :@socket, :close, :close_read, :close_write, :closed?
    def_delegators :@socket, :addr, :peeraddr, :setsockopt, :getsockname

    def initialize(options = {})
      @timeout = options[:timeout_instance] || Timeout::Base::CLASSES.fetch(options[:timeout]).new(
        options.slice(:global_timeout, :connect_timeout, :read_timeout, :write_timeout)
      )
    end

    def connect(host, port)
      addr = DNSResolver.resolv(timeout, port)
      sockaddr = ::Socket.pack_sockaddr_in(port, addr.to_s)

      domain = addr.is_a?(Resolv::IPv4) ? Socket::AF_INET : Socket::AF_INET6
      @socket = ::Socket.new(domain, Socket::SOCK_STREAM)
      @host = host

      connect_with_timeout
    end

    def start_tls(ssl_context)
      raise ArgumentError, "You must call .connect first" unless socket

      @socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
      @socket.hostname = @host if socket.respond_to?(:hostname=)
      @socket.sync_close = true if socket.respond_to?(:sync_close=)

      connect_with_timeout

      if ssl_context.verify_mode == OpenSSL::SSL::VERIFY_PEER
        @socket.post_connection_check(host)
      end
    end
  end
end
