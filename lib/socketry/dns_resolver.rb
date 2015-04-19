require 'ipaddr'
require 'resolv'

module Socketry
  class DNSResolver
    MAX_PACKET_SIZE = 512

    def self.resolve(timeout, hostname)
      return config.default_hosts[hostname] if config.default_hosts[hostname]

      # TODO: Support IPv6 DNS addresses
      socket = UDPSocket.new(timeout: timeout, family: Socket::AF_INET)
      config.default_nameservers.each do |host, port|

      end

      nil

    ensure
      socket.close if socket
    end

      if host = resolve_hostname(hostname)
        unless ip_address = resolve_host(host)
          raise Resolv::ResolvError, "invalid entry in hosts file: #{host}"
        end
        return ip_address
      end

      query = build_query(hostname)
      @socket.send query.encode, 0, @server.to_s, DNS_PORT
      data, _ = @socket.recvfrom(MAX_PACKET_SIZE)
      response = Resolv::DNS::Message.decode(data)

      addrs = []
      # The answer might include IN::CNAME entries so filters them out
      # to include IN::A & IN::AAAA entries only.
      response.each_answer { |name, ttl, value| addrs << value.address if value.respond_to?(:address) }

      return if addrs.empty?
      return addrs.first if addrs.size == 1
      addrs
    end

    private

    def config; DNSResolverConfig end

    def resolve_hostname(hostname)
      # Resolv::Hosts#getaddresses pushes onto a stack
      # so since we want the first occurance, simply
      # pop off the stack.
      resolv.getaddresses(hostname).pop rescue nil
    end

    def resolv
      @resolv ||= Resolv::Hosts.new
    end

    def build_query(hostname)
      Resolv::DNS::Message.new.tap do |query|
        query.id = self.class.generate_id
        query.rd = 1
        query.add_question hostname, Resolv::DNS::Resource::IN::A
      end
    end

    def resolve_host(host)
      resolve_ip(Resolv::IPv4, host) || resolve_ip(Resolv::IPv6, host)
    end

    def resolve_ip(klass, host)
      begin
        klass.create(host)
      rescue ArgumentError
      end
    end
  end
end
