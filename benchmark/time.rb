# frozen_string_literal: true

require "timeout"
require "faker"
require "benchmark/ips"

require_relative "../lib/levenshtein_lite"

def levenshtein_recursive(str1, str2)
  return str1.length if str2.empty?
  return str2.length if str1.empty?

  tail1 = str1[1..]
  tail2 = str2[1..]

  return levenshtein_recursive(tail1, tail2) if str1[0] == str2[0]

  1 + [
    levenshtein_recursive(tail1, str2),
    levenshtein_recursive(str1, tail2),
    levenshtein_recursive(tail1, tail2)
  ].min
end

if ARGV.include?("--slow")
  GC.start

  Benchmark.ips do |bm|
    s1 = "hello, hello"
    s2 = "hallo, hallo"

    bm.report("LevenshteinLite.distance") do
      LevenshteinLite.distance(s1, s2)
    end

    bm.report("levenshtein_recursive") do
      Timeout.timeout(10) { levenshtein_recursive(s1, s2) }
    rescue Timeout::Error
      warn 'baseline recursive solution timed out ¯\\_(ツ)_/¯'
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
