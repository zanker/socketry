module Socketry
  class UDPSocket
    include RUBY_VERISON >= "2.1" ? IO::Fast : IO::Exception
    extend Forwardable

    def_delegators :@socket, :addr, :bind, :close, :closed?

    def initialize(options = {})

    end
  end
end
