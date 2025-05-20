# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development do
  gem "allocation_tracer",
    git: "https://github.com/undees/allocation_tracer.git",
    ref: "57652f67085bb208abe4c34d21229f06efd05856"
  gem "benchmark-ips", "~> 2.14"
  gem "bundler", "~> 2.6"
  gem "faker", "~> 3.5"
  gem "rake", "~> 13.2"
  gem "rspec", "~> 3.13"
  gem "rubocop-rake", "~> 0.7"
  gem "rubocop-rspec", "~> 3.6"
  gem "standard", "~> 1.50"
  gem "steep", "~> 1.10"
  gem "yard", "~> 0.9"
end
