require 'active_support/configurable'

module Supido

  def self.configure(&block)
    yield @config ||= Supido::Configuration.new
  end

  def self.config
    @config
  end

  class Configuration
    include ActiveSupport::Configurable
    config_accessor :benchmark_tool
    config_accessor :log_path
  end

  configure do |config|
    config.benchmark_tool = Tools::ApacheBenchmark
    config.log_path = "/tmp"
  end

end