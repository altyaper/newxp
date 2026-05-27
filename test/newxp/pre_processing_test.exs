defmodule Newxp.PreProcessingTest do
  use ExUnit.Case, async: true
  alias Newxp.PreProcessing

  describe "process_for_summary/1" do
    test "converts html to plain text" do
      html = "<p>Hello world</p>"
      result = PreProcessing.process_for_summary(html)
      assert result =~ "Hello world"
      refute result =~ "<p>"
    end

    test "strips links" do
      html = ~s(<p>Visit <a href="https://example.com">example</a></p>)
      result = PreProcessing.process_for_summary(html)
      assert result =~ "example"
      refute result =~ "https://example.com"
      refute result =~ "<a"
    end

    test "strips images" do
      html = ~s(<p>Text</p><img src="photo.jpg" alt="A photo"/>)
      result = PreProcessing.process_for_summary(html)
      assert result =~ "Text"
      refute result =~ "<img"
      refute result =~ "photo.jpg"
    end

    test "does not wrap long lines" do
      long_text = String.duplicate("word ", 30)
      html = "<p>#{long_text}</p>"
      result = PreProcessing.process_for_summary(html)
      assert result |> String.split("\n") |> Enum.count(fn l -> String.length(l) > 80 end) > 0
    end

    test "returns a string" do
      result = PreProcessing.process_for_summary("<p>Text</p>")
      assert is_binary(result)
    end

    test "handles empty html" do
      result = PreProcessing.process_for_summary("")
      assert is_binary(result)
    end
  end
end
