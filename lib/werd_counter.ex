defmodule WerdCounter do
  def count(string) do
    string
    |> String.downcase
    |> String.split
    |> reduce
  end

  def most(string) do
    string
    |> count
    |> Enum.reduce {"none", 0}, &pick_greater(&1, &2)
  end

  defp pick_greater(first, second) do
    cond do
      elem(first, 1) > elem(second, 1) -> first
      elem(first, 1) < elem(second, 1) -> second
    end
  end

  defp reduce(word_list) do
    Enum.reduce word_list, %{}, fn (i, acc) ->
      Dict.update acc, i, 1, &(&1 + 1)
    end
  end
end
