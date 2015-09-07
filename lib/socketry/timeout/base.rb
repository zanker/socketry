module Socketry
  module Timeout
    class Base
      CLASSES = {
        null: Null,
        global: Global,
        per_operation: PerOperation
      }.freeze

      def initialize(_ = {}); end

      def start(_); end
      def reset(_); end
      def timeout_seconds(_); 3_600 end
    end
  end
end
