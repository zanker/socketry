require 'set'

module Socketry
  class DNSResolverConfig
    DNS_PORT = 53

    @mutex = Mutex.new
    @identifier = 1

    def self.generate_id
      @mutex.synchronize do
        (@identifier += 1) & 0xFFFF
      end
    end

    def self.default_nameservers
      @nameservers ||= begin
        Resolv::DNS::Config.default_config_hash[:nameserver].map do |line|
          host, port = line.split(':', 2)
          [host, port || DNS_PORT]
        end.freeze
      end
    end

    def self.default_hosts
      @host_to_addr ||= begin
        map = {}

        File.open(Resolv::Hosts::DefaultFileName, "r") do |io|
          io.each_line do |line|
            ip, hosts = line.sub(/#.*/, '').split(/\s+/)
            next unless ip && hosts

            aliases.each do |host|
              (map[host] ||= []) << ip
            end
          end
        end

        map.freeze
      end
    end

    # Preload
    self.default_hosts
    self.default_nameservers
  end
end
