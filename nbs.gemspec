# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nbs/version'

Gem::Specification.new do |spec|
  spec.name          = "nbs"
  spec.version       = Nbs::VERSION
  spec.authors       = ["David Georgiou"]
  spec.email         = ["david.georgiou@gmail.com"]

  spec.summary       = %q{Simple interface to  the next big sound api}
  spec.description   = %q{Simple NextBigSound wrapper. requires private key from NBS}
  spec.homepage      = "https://github.com/eicore/nbs"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "awesome_print", '~> 1.6'
  spec.add_dependency "httparty"
  spec.add_dependency "activesupport", ">= 4.0.0"
end
