require 'ipaddr'
require 'resolv-replace'

module Socketry
  class DNSResolver
    MAX_PACKET_SIZE = 512
    RESOURCES = ([Resource::IN::A] + (use_ipv6? ? [Resource::IN::AAAA] : [])).freeze

    def self.resolve(timeout, hostname)
      # Check the hosts file
      if unresolved_ip = config.default_hosts[hostname]
        resolved_ip = resolve_ip(unresolved_id)
        unless resolved_ip
          raise Resolv::ResolvError, "invalid entry in hosts file: #{unresolved_ip}"
        end
        return resolved_ip
      end

      # Hit each nameserver
      config.default_nameservers.each do |ip, port|
        # Hit IPv4 and IPv6
        RESOURCES.each do |resource|
          Socketry::UDPSocket.open(family: ip.family, timeout_instance: timeout) do |socket|
            query = build_query(hostname, resource)
            socket.send(query.encode, 0, ip.to_s, port)

            data, _ = socket.recvfrom(MAX_PACKET_SIZE)

            # TODO: Add handling for CNAME references with infinite reference protection
            response = Resolv::DNS::Message.decode(data)
            response.each_answer do |name, ttl, value|
              return resolve_ip(value.address)
            end
          end
        end
      end

      nil
    end

    def self.use_ipv6?
      return @use_ipv6 if defined?(@use_ipv6)

      begin
        list = Socket.ip_address_list
      rescue NotImplementedError
        return @use_ipv6 = true
      end

      list.each do |a|
        if a.ipv6? && !a.ipv6_loopback? && !a.ipv6_linklocal?
          return @use_ipv6 = true
        end
      end
    end

    private

    def config; DNSResolverConfig end

    def build_query(hostname, resource)
      Resolv::DNS::Message.new.tap do |query|
        query.id = config.generate_id
        query.rd = 1
        query.add_question hostname, resource
      end
    end

    def resolve_ip(ip)
      begin
        return Resolv::IPv4.new(ip)
      rescue ArgumentError
      end

      if self.class.use_ipv6?
        begin
          return Resolv::IPv6.new(ip)
        rescue ArgumentError
        end
      end
    end
  end
end
