defmodule Newxp.SimilarityUtils do
  @doc "Extract n-grams from a list of tokens."
  def ngrams(tokens, n) do
    count = max(length(tokens) - n + 1, 0)

    if count == 0 do
      []
    else
      Enum.map(0..(count - 1), fn i -> Enum.slice(tokens, i, n) end)
    end
  end

  @doc "Lowercase and split text into word tokens."
  def normalize_text(text) do
    Regex.scan(~r/\w+/, String.downcase(text))
    |> List.flatten()
  end

  @doc """
  Calculate Jaccard similarity between two token lists over n-grams up to n_range.

  Jaccard(A, B) = |A ∩ B| / |A ∪ B|

  Score range is 0.0–1.0, where 1.0 means identical.
  """
  def jaccard_similarity(text_1_tokens, text_2_tokens, n_range) do
    n_scores =
      Enum.map(1..n_range//1, fn n ->
        t1_ng = text_1_tokens |> ngrams(n) |> MapSet.new()
        t2_ng = text_2_tokens |> ngrams(n) |> MapSet.new()

        if MapSet.size(t1_ng) == 0 or MapSet.size(t2_ng) == 0 do
          0.0
        else
          intersection = t1_ng |> MapSet.intersection(t2_ng) |> MapSet.size()
          union = t1_ng |> MapSet.union(t2_ng) |> MapSet.size()
          intersection / union
        end
      end)

    Enum.sum(n_scores) / length(n_scores)
  end
end
