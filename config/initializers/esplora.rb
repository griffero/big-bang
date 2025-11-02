Rails.application.configure do
  base = ENV['ESPLORA_BASE_URL'].presence || 'https://mempool.space/api'
  rps = (ENV['MAX_RPS'] || 5).to_i
  Rails.logger.info("Esplora base: #{base} / MAX_RPS=#{rps}")
end


