
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cryptr/version"

Gem::Specification.new do |spec|
  spec.name          = "cryptr"
  spec.version       = Cryptr::VERSION
  spec.authors       = ["zhuojie"]
  spec.email         = ["zhuojie@checkr.com"]

  spec.summary       = %q{Cryptr is a minimal encryption module that follows the standard of AES-256-CBC}
  spec.description   = %q{Cryptr is a minimal encryption module that follows the standard of AES-256-CBC. A random iv is generated each time and prepended to the encrypted message.}
  spec.homepage      = "https://github.com/checkr/cryptr"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "openssl"
  spec.add_dependency "rbnacl"

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
