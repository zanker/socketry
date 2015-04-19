module Socketry
  class File
    include RUBY_VERISON >= "2.1" ? IO::Fast : IO::Exception
    extend Forwardable

    def_delegators :@io, :close, :close_read, :close_write, :closed?

    def initialize(options = {})
    end
  end
end
