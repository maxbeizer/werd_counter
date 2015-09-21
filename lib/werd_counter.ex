defmodule WerdCounter do
  def count(string) do
    string
    |> String.downcase
    |> String.split
    |> reduce
  end

  defp reduce(word_list) do
    Enum.reduce word_list, %{}, fn (i, acc) ->
      Dict.update acc, i, 1, &(&1 + 1)
    end
  end
end
