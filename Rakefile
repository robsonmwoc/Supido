require "bundler/gem_tasks"

require 'rdoc/task'

Rake::RDocTask.new do |rdoc|
  require 'supido/version'

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "supido #{Supido::VERSION}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end