module Socketry
  module Timeout
    class Global
      def initialize(options = {})
        if options[:global_timeout]
          @total_timeout = options[:global_timeout]
        else
          @total_timeout = options.fetch(:connect_timeout) + options.fetch(:write_timeout) + options.fetch(:read_timeout)
        end

        @time_left = @total_timeout
      end

      def start(mode)
        @started = Time.now
      end

      def reset(mode)
        @time_left -= (Time.now - @started)
        if @time_left <= 0
          fail TimeoutError, "Timed out on #{moed} after using the allocated #{@total_timeout} seconds"
        end

        reset(mode)
      end

      def timeout_seconds(mode)
        @time_left
      end
    end
  end
end
