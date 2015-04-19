module Socketry
  module Timeout
    class PerOperation < Null
      def initialize(options = {})
        @timeouts = {
          connect: options.fetch(:connect_timeout),
          write: options.fetch(:write_timeout),
          read: options.fetch(:read_timeout)
        }
      end

      def reset(mode)
        fail TimeoutError, "Connection #{mode} timed out after #{timeout_seconds(mode)} seconds."
      end

      def timeout_seconds(mode)
        timeouts[mode]
      end

      private

      def timeouts
        @timeouts
      end
    end
  end
end
