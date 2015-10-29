defmodule WerdCounter do
  use Application

  def start(_,_) do
    import Supervisor.Spec, warn: false

    children = [
      worker(WerdCounter.WordsAgent, [])
    ]

    Supervisor.start_link(children, [strategy: :one_for_one, name: __MODULE__])
  end

  def process_file_async(file_path) do
    WerdCounter.WordsAgent.clear_words
    IO.puts "Starting to count words in file"
    Task.async(fn -> WerdCounter.File.count(file_path) end)
    |> Task.await(:infinity)
    |> IO.puts
  end

  def process_file(path_to_file) do
    path_to_file
    |> File.stream!
    |> Stream.map(&count/1)
    |> build_words_and_counts
    |> get_the_biggest_count
  end

  defp count(string) do
    string
    |> String.strip
    |> String.downcase
    |> String.split
    |> agent_count
  end

  defp most(string) do
    string
    |> count
    |> get_the_biggest_count
  end

  defp build_words_and_counts(collection) do
    IO.puts "building words and count"
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

  defp agent_count(list) do
    pid = CounterAgent.new
    CounterAgent.count(pid, list)
  end
end
