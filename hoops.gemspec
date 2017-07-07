# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hoops/version"

Gem::Specification.new do |spec|
  spec.name          = "hoops"
  spec.version       = Hoops::VERSION
  spec.authors       = ["Justin Scott"]
  spec.email         = ["jscott7561@gmail.com"]

  spec.summary       = "Handy Operation Oriented Programming Stuff"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/dr0verride/hoops"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "wisper", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'wisper-rspec', '~> 0.0'
  spec.add_development_dependency "guard-rspec", "~> 4.7"
end
