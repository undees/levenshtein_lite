require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Run the default benchmarks"
task :benchmark => [:"benchmark:time", :"benchmark:memory"]

namespace :benchmark do
  desc "Run the default timing benchmarks"
  task :time => :"time:fast"

  namespace :time do
    desc "Run only the basic benchmark"
    task :fast do
      exec "ruby benchmark/time.rb"
    end

    desc "Compare against a slow recursive version"
    task :slow do
      exec "ruby benchmark/time.rb --slow"
    end

    desc "Run all time benchmarks with YJIT enabled"
    task :yjit do
      exec "ruby --yjit benchmark/time.rb --slow"
    end
  end

  desc "Benchmark memory allocations"
  task :memory do
    exec "ruby benchmark/memory.rb"
  end
end
