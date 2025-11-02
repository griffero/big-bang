require 'net/http'
require 'json'
require 'uri'

module Balances
  class EsploraClient
    DEFAULT_BASE_URL = 'https://mempool.space/api'.freeze
    DEFAULT_MAX_RPS = 5

    @mutex = Mutex.new
    @timestamps = []

    class << self
      def fetch_address(address)
        enforce_rate_limit

        url = URI.parse(base_url + "/address/#{address}")
        res = http_get(url)

        return nil unless res.is_a?(Net::HTTPSuccess)

        json = JSON.parse(res.body)
        chain = json['chain_stats'] || {}
        mem = json['mempool_stats'] || {}

        confirmed_sats = (chain['funded_txo_sum'] || 0).to_i - (chain['spent_txo_sum'] || 0).to_i
        unconfirmed_sats = (mem['funded_txo_sum'] || 0).to_i - (mem['spent_txo_sum'] || 0).to_i
        tx_count = (chain['tx_count'] || 0).to_i + (mem['tx_count'] || 0).to_i

        {
          confirmed_sats: confirmed_sats,
          unconfirmed_sats: unconfirmed_sats,
          tx_count: tx_count,
          raw_json: json
        }
      rescue JSON::ParserError
        nil
      end

      private

      def base_url
        ENV['ESPLORA_BASE_URL'].presence || DEFAULT_BASE_URL
      end

      def max_rps
        (ENV['MAX_RPS'] || DEFAULT_MAX_RPS).to_i
      end

      def http_get(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        http.read_timeout = 10
        http.open_timeout = 5
        req = Net::HTTP::Get.new(uri.request_uri)
        http.request(req)
      end

      # Very simple token-bucket-like limiter in-memory
      def enforce_rate_limit
        return if max_rps <= 0

        @mutex.synchronize do
          now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          window_start = now - 1.0
          @timestamps.reject! { |t| t < window_start }
          if @timestamps.size >= max_rps
            sleep_time = (@timestamps.first + 1.0) - now
            sleep(sleep_time) if sleep_time > 0
            now = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            window_start = now - 1.0
            @timestamps.reject! { |t| t < window_start }
          end
          @timestamps << now
        end
      end
    end
  end
end


