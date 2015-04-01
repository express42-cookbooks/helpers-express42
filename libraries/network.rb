#
# Cookbook Name:: helpers_express42
# Library:: network
#
# Copyright 2014, LLC Express 42
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

require 'ipaddr'

module Express42
  # Network module has methods to detect private and public networks
  module Network
    # rubocop:disable CyclomaticComplexity, MethodLength, Metrics/AbcSize
    def net_get_networks(the_node = node)
      networks = { private: [], public: [] }

      private_conditions = []
      public_exclusions = []

      the_node['express42']['private_networks'].split(',').each do |ntwrk|
        private_conditions << IPAddr.new(ntwrk)
      end

      public_exclusions << IPAddr.new('127.0.0.1/8')
      public_exclusions << IPAddr.new('169.254.0.0/16')

      the_node['network']['interfaces'].each do |interface|
        next if !interface[1]['addresses'] || interface[1]['state'] == 'down'

        ip_addr = interface[1]['addresses'].select { |_, data| data['family'] == 'inet' }.to_a[0]
        next if ip_addr.nil?
        ip_addr = ip_addr[0]

        if private_conditions.find { |pc| pc.include?(ip_addr) }
          networks[:private] << [interface[0], ip_addr]
          next
        end
        if !private_conditions.find { |pc| pc.include?(ip_addr) } && !public_exclusions.each.find { |pe| pe.include?(ip_addr) }
          networks[:public] << [interface[0], ip_addr]
          next
        end
      end
      networks
    end
    # rubocop:enable CyclomaticComplexity, MethodLength

    def net_get_all_ip(the_node = node)
      ips = []
      networks = net_get_networks(the_node)
      networks.each_pair do |_, eth_ip_array|
        eth_ip_array.each do |eth_ip|
          ips << eth_ip[1]
        end
      end
      ips
    end

    def net_get_public(the_node = node)
      net_get_networks(the_node)[:public]
    end

    def net_get_private(the_node = node)
      net_get_networks(the_node)[:private]
    end
  end
end
