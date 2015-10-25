defmodule WerdCounter do
  def count(string) do
    string
    |> String.strip
    |> String.downcase
    |> String.split
    |> reduce
  end

  def most(string) do
    string
    |> count
    |> get_the_biggest_count
  end

  def process_file(path_to_file) do
    path_to_file
    |> File.stream!
    |> Stream.map(&count/1)
    |> build_words_and_counts
    |> get_the_biggest_count
  end

  defp build_words_and_counts(collection) do
    collection
    |> Enum.reduce %{}, fn(x, acc) -> merge_counts(x, acc) end
  end

  defp merge_counts(map1, map2) do
    Map.merge map1, map2, fn(_k, v1, v2) -> v1 + v2 end
  end

  defp get_the_biggest_count(list_of_words_and_counts) do
    list_of_words_and_counts
    |> Enum.reduce {"none", 0}, &pick_greater(&1, &2)
  end

  defp pick_greater(first, second) do
    cond do
      elem(first, 1) >= elem(second, 1) -> first
      elem(first, 1) <  elem(second, 1) -> second
    end
  end

  defp reduce(word_list) do
    Enum.reduce word_list, %{}, fn (i, acc) ->
      Dict.update acc, i, 1, &(&1 + 1)
    end
  end
end
