defmodule Newxp.Text do
  # Splits at sentence boundaries: after [.!?], not after abbreviations like U.S., Inc.,
  # and only when followed by whitespace + optional bullet + capital letter or digit.
  # Also splits after a colon before a newline-delimited bullet list.
  @sentence_pattern ~r/(?<=[.!?])(?<![A-Z]\.)(?<![A-Z]\.[A-Z]\.)(?<!Inc\.)(?=\s+(?:[\*\-•]\s*)?[""'(\[]?(?:[A-Z]|\d))|(?<=:)(?=\s*\n+(?=[\*\-•]\s*))/u

  @doc "Remove strings like ($500) or ($1,200) from text."
  def remove_converted_currency_parenthesis(body) do
    Regex.replace(~r/\(\$\d+[^\(]*\)/, body, "")
  end

  @doc """
  Split news article text into sentences with newline-aware chunking.

  When `remove_empty` is false, newline separators are appended to the
  preceding sentence. When true, blank sentences are filtered out.
  """
  def sentence_split(body, remove_empty) do
    if String.trim(body) == "" do
      []
    else
      chunks = Regex.split(~r/\n{1,2}/, body)
      newlines = (Regex.scan(~r/\n{1,2}/, body) |> List.flatten()) ++ [nil]

      sentences =
        Enum.zip(chunks, newlines)
        |> Enum.reduce([], fn {chunk, newline}, acc ->
          chunk_sents = Regex.split(@sentence_pattern, chunk)
          updated = acc ++ chunk_sents

          if newline != nil and not remove_empty do
            List.update_at(updated, -1, fn last -> last <> newline end)
          else
            updated
          end
        end)

      if remove_empty do
        Enum.filter(sentences, fn s -> String.trim(s) != "" end)
      else
        sentences
      end
    end
  end
end
