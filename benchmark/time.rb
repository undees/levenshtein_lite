require "timeout"
require "faker"
require "benchmark/ips"

require_relative "../lib/levenshtein_lite"

def levenshtein_recursive(a, b)
  return a.length if b.empty?
  return b.length if a.empty?

  tail_a = a[1..]
  tail_b = b[1..]

  if a[0] == b[0]
    return levenshtein_recursive(tail_a, tail_b)
  end

  1 + [
    levenshtein_recursive(tail_a, b),
    levenshtein_recursive(a, tail_b),
    levenshtein_recursive(tail_a, tail_b)
  ].min
end

if ARGV.include?("--slow")
  GC.start

  Benchmark.ips do |bm|
    s1 = "hello, hello".freeze
    s2 = "hallo, hallo".freeze

    bm.report("LevenshteinLite.distance") do
      LevenshteinLite.distance(s1, s2)
    end

    bm.report("levenshtein_recursive") do
      Timeout.timeout(10) { levenshtein_recursive(s1, s2) }
    rescue Timeout::Error
      warn "baseline recursive solution timed out ¯\\\_(ツ)\_/¯"
    end

    bm.compare!
  end
end

GC.start

Benchmark.ips do |bm|
  s1 = Faker::Hipster.paragraph_by_chars(characters: 5000).freeze
  s2 = Faker::Hipster.paragraph_by_chars(characters: 5000).freeze

  puts "Sample distance (5k chars): #{LevenshteinLite.distance(s1, s2)}"

  bm.report("LevenshteinLite.distance (5k characters)") do
    LevenshteinLite.distance(s1, s2)
  end

  bm.compare!
end
