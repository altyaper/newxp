defmodule Newxp.PreProcessing do
  @moduledoc """
  Functions for processing HTML content into plain text for different use cases.
  """

  alias Newxp.HtmlUtils

  @doc """
  Get configured html2text options.

  Returns a keyword list suitable for passing to `HTML2Text.convert/2`:

  - `link_footnotes: false` — omits link footnotes
  - `empty_img_mode: :ignore` — skips images without alt text
  - `width: :infinity` — disables line wrapping

  ## Examples

      Newxp.PreProcessing.get_html2text_handler()
      # => [link_footnotes: false, empty_img_mode: :ignore, width: :infinity]

  """
  def get_html2text_handler do
    [
      link_footnotes: false,
      empty_img_mode: :ignore,
      width: :infinity
    ]
  end

  @doc """
  Convert HTML to plain text for summarization.

  Strips links, images, and formatting. Output is unwrapped plain text
  suitable for feeding into summarization models.

  ## Examples

      html = "<p>Hello <a href=\\"https://example.com\\">world</a></p>"
      Newxp.PreProcessing.process_for_summary(html)
      # => "Hello world\\n"

  """
  def process_for_summary(html) do
    HTML2Text.convert!(html, get_html2text_handler())
  end

  @doc """
  Process content for general applications.

  This includes:
  - Core HTML cleaning (figures, tables, noscript, read-more)
  - Convert to plaintext (preserving most HTML structure)

  ## Examples

      html = "<p>Hello</p><figure><img/></figure>"
      Newxp.PreProcessing.process_for_general(html)
      # => "Hello\\n"

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
