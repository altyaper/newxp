defmodule Newxp.SimilarityUtilsTest do
  use ExUnit.Case, async: true
  alias Newxp.SimilarityUtils

  describe "ngrams/2" do
    test "extracts bigrams" do
      assert SimilarityUtils.ngrams(["a", "b", "c"], 2) == [["a", "b"], ["b", "c"]]
    end

    test "extracts unigrams" do
      assert SimilarityUtils.ngrams(["a", "b", "c"], 1) == [["a"], ["b"], ["c"]]
    end

    test "extracts trigrams" do
      assert SimilarityUtils.ngrams(["a", "b", "c", "d"], 3) == [
               ["a", "b", "c"],
               ["b", "c", "d"]
             ]
    end

    test "returns empty list when tokens shorter than n" do
      assert SimilarityUtils.ngrams(["a"], 2) == []
    end

    test "returns empty list for empty tokens" do
      assert SimilarityUtils.ngrams([], 2) == []
    end

    test "returns single ngram when tokens length equals n" do
      assert SimilarityUtils.ngrams(["a", "b"], 2) == [["a", "b"]]
    end
  end

  describe "normalize_text/1" do
    test "lowercases and splits into word tokens" do
      assert SimilarityUtils.normalize_text("Hello World") == ["hello", "world"]
    end

    test "strips punctuation" do
      assert SimilarityUtils.normalize_text("it's a test!") == ["it", "s", "a", "test"]
    end

    test "handles empty string" do
      assert SimilarityUtils.normalize_text("") == []
    end

    test "handles multiple spaces and newlines" do
      assert SimilarityUtils.normalize_text("one   two\nthree") == ["one", "two", "three"]
    end
  end

  describe "jaccard_similarity/3" do
    test "returns 1.0 for identical token lists" do
      tokens = ["the", "cat", "sat"]
      assert SimilarityUtils.jaccard_similarity(tokens, tokens, 1) == 1.0
    end

    test "returns 0.0 for completely different token lists" do
      assert SimilarityUtils.jaccard_similarity(["a", "b"], ["c", "d"], 1) == 0.0
    end

    test "returns 0.0 when either list is empty" do
      assert SimilarityUtils.jaccard_similarity([], ["a", "b"], 1) == 0.0
      assert SimilarityUtils.jaccard_similarity(["a", "b"], [], 1) == 0.0
    end

    test "returns partial similarity for overlapping token lists" do
      score = SimilarityUtils.jaccard_similarity(["a", "b", "c"], ["a", "b", "d"], 1)
      assert score > 0.0 and score < 1.0
    end

    test "averages scores across n-gram sizes up to n_range" do
      tokens = ["the", "cat"]
      score = SimilarityUtils.jaccard_similarity(tokens, tokens, 2)
      assert score == 1.0
    end

    test "score is between 0.0 and 1.0" do
      score = SimilarityUtils.jaccard_similarity(["hello", "world"], ["hello", "elixir"], 2)
      assert score >= 0.0 and score <= 1.0
    end
  end
end
