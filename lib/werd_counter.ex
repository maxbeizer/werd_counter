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
    |> Enum.reduce {"none", 0}, fn (i, acc) ->
      if first_value_greater?(i, acc) do
        i
      else
        acc
      end
    end
  end

  defp reduce(word_list) do
    Enum.reduce word_list, %{}, fn (i, acc) ->
      Dict.update acc, i, 1, &(&1 + 1)
    end
  end

  defp first_value_greater?(tup1, tup2) do
    elem(tup1, 1) > elem(tup2, 1)
  end
end
