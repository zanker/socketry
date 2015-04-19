module Socketry
  module Timeout
    class Null
      def initialize(_ = {}); end

      def start(_); end
      def reset(_); end
      def timeout_seconds(_); 10 end
    end
  end
end
