$:.unshift(File.dirname(__FILE__) + '/lib')

require 'vcloud/version'

Gem::Specification.new do |s|
  s.name = 'vcloud'
  s.version = VCloud::VERSION
  s.summary = 'vCloud Director API Ruby Bindings'
  s.description = s.summary
  s.license = 'MIT'
  s.authors = ['Nick Osborn', 'Brian McClain', 'Zach Robinson']
  s.homepage = 'https://github.com/nosborn/vcloud-ruby'

  s.required_ruby_version = '>= 1.9.1'

  s.add_dependency 'nokogiri-happymapper', '< 0.5.7'
  s.add_dependency 'rest-client'

  s.files = [
    '.yardopts',
    'LICENSE',
    'README.md',
  ]
  s.files += Dir['lib/**/*.rb']

  s.bindir = 'bin'
  s.executables << 'vcloud-rb'
end
