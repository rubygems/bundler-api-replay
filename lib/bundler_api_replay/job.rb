require 'net/http'
require 'net/https'
require 'zlib'
require 'sidekiq'
require_relative '../bundler_api_replay'
require_relative '../../config/sidekiq'

class BundlerApiReplay::Job
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(path, host, port = 80, timeout = 5)
    logger = Logger.new(STDOUT)
    http   = Net::HTTP.new(host, port)
    http.use_ssl = true if port == 443
    http.read_timeout = timeout
    http.request(Net::HTTP::Get.new(path))
  end
end
