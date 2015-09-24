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
      cond do
        elem(i, 1) > elem(acc, 1) == true ->
          i
        elem(i, 1) < elem(acc, 1) == true ->
          acc
      end
    end
  end

  defp reduce(word_list) do
    Enum.reduce word_list, %{}, fn (i, acc) ->
      Dict.update acc, i, 1, &(&1 + 1)
    end
  end
end
