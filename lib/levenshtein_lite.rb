# frozen_string_literal: true

require "levenshtein_lite/version"

# Pure-Ruby implementation of the Levenshtein algorithm,
# tuned for speed and minimal allocations.
module LevenshteinLite
  # Computes the Levenshtein distance between two strings.
  #
  # @param str1 [String]
  # @param str2 [String]
  # @return [Integer] number of changes to transform str1 to str2

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def self.distance(str1, str2)
    return str1.length if str2.empty?
    return str2.length if str1.empty?
    return 0 if str1 == str2

    # Distance from a prefix of str1 to each prefix in str2.
    #
    # On the first iteration, the prefix of str1 is just '',
    # and so the distance measurement for any prefix of str2
    # is the prefix's length. For example, the distance from
    # 'abc' to '' is 3.
    #
    # So, we initialize the array to [0, 1, 2,.. str2.length].
    #
    distances = Array.new(str2.length + 1) { _1 }

    # Workspace for calculating the next set of prefix distances.
    workspace = Array.new(str2.length + 1)

    i = 0 # avoid allocations from each_with_index
    str1.each_codepoint do |c1|
      workspace[0] = i + 1

      j = 0 # avoid allocation from each_with_index
      str2.each_codepoint do |c2|
        deletion_cost = distances[j + 1] + 1
        insertion_cost = workspace[j] + 1
        substitution_cost = distances[j] + ((c1 == c2) ? 0 : 1)

        min = deletion_cost
        min = insertion_cost if insertion_cost < min
        min = substitution_cost if substitution_cost < min

        workspace[j + 1] = min

        j += 1
      end

      # The newly completed workspace becomes the set of distances
      # for the next iteration, and the old distances become our
      # next workspace.
      #
      # Swap them the old-fashioned way to avoid an Array allocation.
      #
      # rubocop:disable Style/SwapValues
      tmp = distances
      distances = workspace
      workspace = tmp
      # rubocop:enable Style/SwapValues

      i += 1
    end

    distances[-1]
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
