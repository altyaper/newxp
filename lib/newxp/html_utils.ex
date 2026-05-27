defmodule Newxp.HtmlUtils do
  @doc "Apply core HTML cleaning transformations."
  def clean_html_content(html) do
    {:ok, doc} = Floki.parse_document(html)

    doc
    |> remove_figures()
    |> remove_tables()
    |> remove_noscript()
    |> Floki.raw_html()
  end

  # Removes all <figure> elements from the parsed document.
  defp remove_figures(doc), do: Floki.filter_out(doc, "figure")

  # Removes all <table> elements from the parsed document.
  defp remove_tables(doc), do: Floki.filter_out(doc, "table")

  # Removes all <noscript> elements from the parsed document.
  defp remove_noscript(doc), do: Floki.filter_out(doc, "noscript")

  @doc "Remove italic and emphasis tags."
  def convert_italic_and_emphasis_to_plain_text(html) do
    {:ok, doc} = Floki.parse_document(html)

    doc
    |> Floki.filter_out("i")
    |> Floki.filter_out("em")
    |> Floki.raw_html()
  end
end
