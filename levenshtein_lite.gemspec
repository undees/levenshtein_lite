# frozen_string_literal:true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "levenshtein_lite/version"

Gem::Specification.new do |spec|
  spec.name = "levenshtein_lite"
  spec.version = LevenshteinLite::VERSION
  spec.authors = ["Erin Paget"]
  spec.email = ["erin.dees@hey.com"]

  spec.summary = "Fast, allocation-lite, Unicode-aware Levenshtein distance in pure Ruby."
  spec.homepage = "https://github.com/undees/levenshtein_lite"
  spec.license = "MIT"

  spec.required_ruby_version = "~> 3.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
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

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata["rubygems_mfa_required"] = "true"
end
