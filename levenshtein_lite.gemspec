
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "levenshtein_lite/version"

Gem::Specification.new do |spec|
  spec.name          = "levenshtein_lite"
  spec.version       = LevenshteinLite::VERSION
  spec.authors       = ["Erin Paget"]
  spec.email         = ["erin.dees@hey.com"]

  spec.summary       = %q{Fast, allocation-lite, Unicode-aware Levenshtein distance in pure Ruby.}
  spec.homepage      = "https://github.com/undees/levenshtein_lite"
  spec.license       = "MIT"

  spec.required_ruby_version = "~> 3.0"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(spec|bin|benchmark)/}) ||
        %w[
          .rspec
          .gitignore
          .travis.yml
          .ruby-version
          Rakefile
          ].include?(f)
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.6"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "faker", "~> 3.5"
  spec.add_development_dependency "benchmark-ips", "~> 2.14"
  spec.add_development_dependency "allocation_tracer", "~> 0.6"
end
