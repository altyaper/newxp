defmodule Newxp.HtmlUtils do
  @moduledoc """
  Utility functions for cleaning and transforming HTML content.
  """

  @doc """
  Apply core HTML cleaning transformations.

  Removes `<figure>`, `<table>`, and `<noscript>` elements from the HTML string
  and returns the cleaned HTML.

  ## Examples

      html = "<p>Hello</p><figure><img/></figure>"
      Newxp.HtmlUtils.clean_html_content(html)
      # => "<p>Hello</p>"

  """
  def clean_html_content(html) do
    {:ok, doc} = Floki.parse_document(html)

    doc
    |> remove_figures()
    |> remove_tables()
    |> remove_noscript()
    |> Floki.raw_html()
  end

  @doc """
  Remove italic and emphasis tags.

  Strips `<i>` and `<em>` elements from the HTML string and returns the result.

  ## Examples

      html = "<p>Hello <em>world</em></p>"
      Newxp.HtmlUtils.convert_italic_and_emphasis_to_plain_text(html)
      # => "<p>Hello </p>"

  """
  def convert_italic_and_emphasis_to_plain_text(html) do
    {:ok, doc} = Floki.parse_document(html)

    doc
    |> Floki.filter_out("i")
    |> Floki.filter_out("em")
    |> Floki.raw_html()
  end

  # Removes all <figure> elements from the parsed document.
  defp remove_figures(doc), do: Floki.filter_out(doc, "figure")

  # Removes all <table> elements from the parsed document.
  defp remove_tables(doc), do: Floki.filter_out(doc, "table")

  # Removes all <noscript> elements from the parsed document.
  defp remove_noscript(doc), do: Floki.filter_out(doc, "noscript")
end
