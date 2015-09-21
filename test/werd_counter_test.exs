defmodule WerdCounterTest do
  use ExUnit.Case

  test "one word" do
    assert WerdCounter.count("werd") == %{ "werd" => 1 }
  end

  test "one of each" do
    expected = %{ "one" => 1 ,  "of" => 1 ,  "each" => 1 }
    assert WerdCounter.count("one of each") == expected
  end

  test "count multiple occurrences" do
    expected = %{ "one" => 1 ,  "fish" => 4 ,  "two" => 1 ,  "red" => 1 ,  "blue" => 1 }
    assert WerdCounter.count("one fish two fish red fish blue fish") == expected
  end

  @tag :pending
  test "ignore punctuation" do
    expected = %{"car" => 1, "carpet" => 1, "as" => 1, "java" => 1, "javascript" => 1}
    assert WerdCounter.count("car : carpet as java : javascript!!&@$%^&") == expected
  end

  @tag :pending
  test "include numbers" do
    expected = %{"testing" => 2, "1" => 1, "2" => 1}
    assert WerdCounter.count("testing, 1, 2 testing") == expected
  end

  @tag :pending
  test "hyphens" do
    expected = %{"co-operative" => 1}
    assert WerdCounter.count("co-operative") == expected
  end

  @tag :pending
  test "ignore underscores" do
    expected = %{"two" => 1, "words" => 1}
    assert WerdCounter.count("two_words") == expected
  end
end
