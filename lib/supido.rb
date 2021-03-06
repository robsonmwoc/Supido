require "supido/version"
require 'active_support/core_ext/string'
require 'fileutils'
require 'base64'
require 'uri'

module Supido; end

# load Supido components
require 'supido/abstract_interface'
require 'supido/abstract_benchmark_base'
require 'supido/tools/apache_benchmark'
require 'supido/config'
require 'supido/profile_action'
require 'supido/profile'