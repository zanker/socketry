module Socketry
  module Timeout
    module Celluloid
      class PerOperation < Timeout::PerOperation
        def initialize(*args)
          super
          @socket = args.fetch(:socket)
        end

        def start(mode)
          if ::Celluloid::IO.evented?
            @timer = ::Celluloid.after(timeout_seconds(mode)) do
              @socket.close
              reset(mode)
            end
          else
            super mode
          end
        end

        def clear
          if @timer
            @timer.reset
            @itmer = nil
          end
        end
      end
    end
  end
end
