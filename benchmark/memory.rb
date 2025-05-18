require "allocation_tracer"
require "faker"
require_relative "../lib/levenshtein_lite"

s1 = Faker::Hipster.paragraph_by_chars(characters: 1000).freeze
s2 = Faker::Hipster.paragraph_by_chars(characters: 1000).freeze

puts "Sample distance (1k chars): #{LevenshteinLite.distance(s1, s2)}"

ObjectSpace::AllocationTracer.setup(%i[path line type class])

results = ObjectSpace::AllocationTracer.trace do
  LevenshteinLite.distance(s1, s2)
end

sorted = results.sort_by { |(*_), (count, *)| count }

sorted.each do |(path, line, type, klass), (count, *_)|
  file = File.basename(path)
  noun = count == 1 ? "alloc" : "allocs"

  puts "#{file}:#{line} #{klass} (#{type}) => #{count} #{noun}"
end

total = results.sum { |(*_), (count, *)| count }
puts "\nTotal allocations: #{total}"
