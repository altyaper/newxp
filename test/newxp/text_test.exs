defmodule Newxp.TextTest do
  use ExUnit.Case, async: true
  alias Newxp.Text

  describe "remove_converted_currency_parenthesis/1" do
    test "removes a simple dollar amount in parentheses" do
      assert Text.remove_converted_currency_parenthesis("Price is ($500) today") ==
               "Price is  today"
    end

    test "removes dollar amount with comma-separated digits" do
      assert Text.remove_converted_currency_parenthesis("($1,200) was the cost") ==
               " was the cost"
    end

    test "removes multiple occurrences" do
      assert Text.remove_converted_currency_parenthesis("($100) and ($200)") == " and "
    end

    test "leaves text unchanged when no pattern is present" do
      assert Text.remove_converted_currency_parenthesis("Hello world") == "Hello world"
    end

    test "handles empty string" do
      assert Text.remove_converted_currency_parenthesis("") == ""
    end

    test "does not remove regular parentheses without dollar sign" do
      assert Text.remove_converted_currency_parenthesis("(hello)") == "(hello)"
    end
  end

  describe "sentence_split/2" do
    test "returns empty list for empty string" do
      assert Text.sentence_split("", true) == []
    end

    test "returns empty list for whitespace-only string" do
      assert Text.sentence_split("   ", true) == []
    end

    test "returns single-element list when no split point is found" do
      result = Text.sentence_split("Hello world.", true)
      assert length(result) == 1
      assert hd(result) =~ "Hello world."
    end

    test "splits two sentences at period followed by capital letter" do
      result = Text.sentence_split("Hello world. How are you?", true)
      assert length(result) == 2
      assert Enum.any?(result, &(&1 =~ "Hello world."))
      assert Enum.any?(result, &(&1 =~ "How are you?"))
    end

    test "does not split after single uppercase abbreviation like U.S." do
      result = Text.sentence_split("U.S. stocks fell. Markets closed.", true)
      assert Enum.any?(result, &(&1 =~ "U.S. stocks fell"))
    end

    test "does not split after Inc." do
      result = Text.sentence_split("Apple Inc. released a product. It was great.", true)
      assert Enum.any?(result, &(&1 =~ "Apple Inc. released a product"))
    end

    test "remove_empty true filters blank strings" do
      result = Text.sentence_split("Hello.\n\nWorld.", true)
      assert Enum.all?(result, &(String.trim(&1) != ""))
    end

    test "remove_empty false preserves newline characters in output" do
      result = Text.sentence_split("Hello.\n\nWorld.", false)
      assert Enum.any?(result, &(&1 =~ "\n"))
    end

    test "returns a list of strings" do
      result = Text.sentence_split("Hello world.", true)
      assert is_list(result)
      assert Enum.all?(result, &is_binary/1)
    end
  end
end
