# This file is copied to spec/ when you run 'rails generate rspec:install'
$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__))

require 'supido'
require 'rspec/autorun'

module Supido
  class SampleBenchmarkTool < AbstractBenchmarkBase; end
end

