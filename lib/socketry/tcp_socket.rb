module Socketry
  class TCPSocket
    include RUBY_VERISON >= "2.1" ? IO::Fast : IO::Exception
    extend Forwardable

    def_delegators :@socket, :close, :close_read, :close_write, :closed?
    def_delegators :@socket, :addr, :peeraddr, :setsockopt, :getsockname

    def initialize
    end
  end
end
