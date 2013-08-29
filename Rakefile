require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/*_spec.rb'
  spec.rspec_opts = ['--backtrace', '--format documentation']
end
task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:doc)
rescue LoadError
end
