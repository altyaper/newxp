defmodule Newxp.HtmlUtilsTest do
  use ExUnit.Case, async: true
  alias Newxp.HtmlUtils

  describe "clean_html_content/1" do
    test "removes figure elements" do
      html = "<div><p>Text</p><figure><img src=\"photo.jpg\"/><figcaption>Caption</figcaption></figure></div>"
      result = HtmlUtils.clean_html_content(html)
      refute result =~ "<figure"
      refute result =~ "<figcaption"
      assert result =~ "<p>Text</p>"
    end

    test "removes table elements" do
      html = "<div><p>Text</p><table><tr><td>Cell</td></tr></table></div>"
      result = HtmlUtils.clean_html_content(html)
      refute result =~ "<table"
      refute result =~ "<tr"
      refute result =~ "<td"
      assert result =~ "<p>Text</p>"
    end

    test "removes noscript elements" do
      html = "<div><p>Text</p><noscript><p>Please enable JS</p></noscript></div>"
      result = HtmlUtils.clean_html_content(html)
      refute result =~ "<noscript"
      refute result =~ "Please enable JS"
      assert result =~ "<p>Text</p>"
    end

    test "removes multiple element types in one pass" do
      html = """
      <div>
        <p>Keep this</p>
        <figure><img src="x.jpg"/></figure>
        <table><tr><td>Remove</td></tr></table>
        <noscript>Also remove</noscript>
      </div>
      """
      result = HtmlUtils.clean_html_content(html)
      refute result =~ "<figure"
      refute result =~ "<table"
      refute result =~ "<noscript"
      assert result =~ "Keep this"
    end

    test "returns html unchanged when no target elements are present" do
      html = "<div><p>Clean content</p><span>More text</span></div>"
      result = HtmlUtils.clean_html_content(html)
      assert result =~ "<p>Clean content</p>"
      assert result =~ "<span>More text</span>"
    end

    test "handles empty html string" do
      result = HtmlUtils.clean_html_content("")
      assert is_binary(result)
    end
  end
end
