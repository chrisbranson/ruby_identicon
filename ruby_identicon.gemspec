# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_identicon/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_identicon"
  spec.version       = RubyIdenticon::VERSION
  spec.authors       = ["Chris Branson"]
  spec.email         = ["branson.chris@gmail.com"]
  
  spec.description   = <<-EOT
    A Ruby implementation of go-identicon by Damian Gryski

    RubyIdenticon creates an identicon, similar to those created by Github.

    A title and key are used by siphash to calculate a hash value that is then used
    to create a visual identicon representation. The identicon is made by creating
    a left hand side pixel representation of each bit in the hash value, this is then
    mirrored onto the right hand side to create an image that we see as a shape.

    The grid and square sizes can be varied to create identicons of differing size.
  EOT

  spec.summary       = %q{A Ruby Gem for creating GitHub like identicons}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.4.1"
  spec.add_development_dependency "yard", "~> 0.8.7"

  spec.add_dependency "chunky_png", "~> 1.3.5"
end
