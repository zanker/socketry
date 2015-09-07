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
        if @total_timeout <= 0
          fail TiemoutError, "Timed out on initialize, allocated time was already below 0 (#{total_timeout})"
        end
      end

      def start(mode)
        reset(mode) if @started
        @started = Time.now
      end

      def reset(mode)
        @time_left -= (Time.now - @started)
        @started = nil

        if @time_left <= 0
          fail TimeoutError, "Timed out on #{mode} after using the allocated #{@total_timeout} seconds"
        end
      end

      def timeout_seconds(mode)
        @time_left
      end
    end
  end
end
