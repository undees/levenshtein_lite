# frozen_string_literal:true

require_relative "../lib/levenshtein_lite"

RSpec::Matchers.define :measure_the_distance_between do |s1, s2|
  chain(:as) { |amount| @amount = amount }
  match { |klass| klass.distance(s1, s2) == @amount }

  failure_message do
    super() + ", but it was #{klass.distance(s1, s2)}"
  end
end

# rubocop:disable Metrics/BlockLength
RSpec.describe LevenshteinLite do
  subject(:ld) { described_class }

  describe ".distance" do
    # rubocop:disable RSpec/ImplicitExpect
    # rubocop:disable RSpec/ImplicitSubject
    it { should measure_the_distance_between("", "").as(0) }
    it { should measure_the_distance_between("", "a").as(1) }
    it { should measure_the_distance_between("a", "").as(1) }
    it { should measure_the_distance_between("a", "b").as(1) }

    it { should measure_the_distance_between("abc", "azc").as(1) }
    it { should measure_the_distance_between("abc", "acb").as(2) }
    it { should measure_the_distance_between("abc", "ac").as(1) }
    it { should measure_the_distance_between("ac", "abc").as(1) }

    it { should measure_the_distance_between("la", "là").as(1) }

    it {
      should measure_the_distance_between(
        "correct horsE battery staple",
        "correct battEry horse staple"
      )
        .as(12)
    }
    # rubocop:enable RSpec/ImplicitExpect
    # rubocop:enable RSpec/ImplicitSubject

    it "is symmetrical" do
      expect(ld.distance("kitten", "sitting"))
        .to eq(ld.distance("sitting", "kitten"))
    end

    it "returns zero for strings that are the same object" do
      s = "it's cold in here!" # frozen due to file-wide directive
      expect(ld.distance(s, s)).to eq(0)
    end

    it "measures the distance between long mismatched strings" do
      expect(ld.distance("a" * 1000, "b" * 1000)).to eq(1000)
    end

    it "considers composed / decomposed Unicode codepoints as different" do
      e_followed_by_combining_accent = "\u0065\u0301"
      single_char_accented_e = "\u00e9"

      expect(ld.distance(
        e_followed_by_combining_accent,
        single_char_accented_e
      )).to eq(2)
    end
  end
end
# rubocop:enable Metrics/BlockLength
