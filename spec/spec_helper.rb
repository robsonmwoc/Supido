# This file is copied to spec/ when you run 'rails generate rspec:install'
$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'supido'
require 'rspec/autorun'
require 'fileutils'

RSpec.configure do |config|
  config.after(:suite) {
    Dir.glob("/tmp/benchmark_*").each { |dir| FileUtils.rm_rf(dir) }
  }
end

module Supido
  class SampleBenchmarkTool < AbstractBenchmarkBase; end
end

def set_default_configuration
  Supido.configure do |config|
    config.benchmark_tool = Supido::Tools::ApacheBenchmark
    config.log_path = "/tmp"
  end
end

