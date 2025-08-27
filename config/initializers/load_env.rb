# Load environment variables for development without relying on dotfiles
if defined?(Dotenv)
  if Rails.env.development?
    env_file = Rails.root.join('config', 'env.development')
    Dotenv.load(env_file.to_s) if File.exist?(env_file)
  elsif Rails.env.test?
    env_file = Rails.root.join('config', 'env.test')
    Dotenv.load(env_file.to_s) if File.exist?(env_file)
  end
end

