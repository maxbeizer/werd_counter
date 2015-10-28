defmodule CounterAgent do
  def new do
    {:ok, pid} = Agent.start_link(fn -> %{} end)
    pid
  end

  def count(pid, word_list) do
    case word_list do
      [head|tail] -> do_count(pid, head, tail)
      []          -> Agent.get(pid, fn(counts) -> counts end)
    end
  end

  defp do_count(pid, word, rest) do
    Agent.get_and_update(pid, fn(counts) -> {counts, Dict.update(counts, word, 1, &(&1 + 1))} end)
    count(pid, rest)
  end
end
