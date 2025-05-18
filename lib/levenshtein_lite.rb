require "levenshtein_lite/version"

module LevenshteinLite
  # Computes the Levenshtein distance between two strings.
  #
  # @param s1 [String]
  # @param s2 [String]
  # @return [Integer] number of changes to transform s1 to s2

  def self.distance(s1, s2)
    return s1.length if s2.empty?
    return s2.length if s1.empty?
    return 0 if s1 == s2

    # Distance from a prefix of s1 to each prefix in s2.
    #
    # On the first iteration, the prefix of s1 is just "",
    # and so the distance measurement for any prefix of s2
    # is the prefix's length. For example, the distance from
    # "abc" to "" is 3.
    #
    # So, we initialize the array to [0, 1, 2,.. s2.length].
    #
    distances = Array.new(s2.length + 1) { _1 }

    # Workspace for calculating the next set of prefix distances.
    workspace = Array.new(s2.length + 1)

    i = 0 # avoid allocations from each_with_index
    s1.each_codepoint do |c1|
      workspace[0] = i + 1

      j = 0 # avoid allocation from each_with_index
      s2.each_codepoint do |c2|
        deletion_cost = distances[j + 1] + 1
        insertion_cost = workspace[j] + 1
        substitution_cost = distances[j] + (c1 == c2 ? 0 : 1)

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
      tmp = distances
      distances = workspace
      workspace = tmp

      i += 1
    end

    distances[-1]
  end
end
