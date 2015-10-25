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
    |> get_the_biggest_count
  end

  def process_file(path_to_file) do
    path_to_file
    |> File.stream!
    |> Stream.take(10)
    |> Stream.map(&String.strip/1)
    |> Stream.map(&WerdCounter.count/1)
    |> Enum.map(&async_things/1)
    |> Enum.map(&Task.await/1)
    |> get_the_biggest_count
  end

  def async_things(things), do: Task.async(fn -> get_funky(things) end)

  def get_funky(col) do
    col
    |> Enum.reduce %{}, fn(x, acc) -> Map.merge x, acc, fn(_k, v1, v2) -> v1+v2 end end
  end

  def get_the_biggest_count(map) do
    map
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
