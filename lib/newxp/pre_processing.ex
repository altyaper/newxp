defmodule Newxp.PreProcessing do
  alias Newxp.HtmlUtils

  @doc "Get configured html2text options."
  def get_html2text_handler do
    [
      link_footnotes: false,
      empty_img_mode: :ignore,
      width: :infinity
    ]
  end

  @doc "Convert HTML to plain text for summarization."
  def process_for_summary(html) do
    HTML2Text.convert!(html, get_html2text_handler())
  end

  @doc """
  Process content for general applications.

  This includes:
  - Core HTML cleaning (figures, tables, read-more)
  - Convert to plaintext (preserving most HTML structure)
  """
  def process_for_general(html) do
    {:ok, doc} =
      html
      |> HtmlUtils.clean_html_content()
      |> Floki.parse_document()

    cleaned =
      doc
      |> remove_read_more()
      |> Floki.raw_html()

    HTML2Text.convert!(cleaned, width: :infinity)
  end

  # Removes read-more elements (common class and link patterns).
  defp remove_read_more(doc) do
    doc
    |> Floki.filter_out("[class*=read-more]")
    |> Floki.filter_out("[class*=readmore]")
  end


end
