defmodule WerdCounter.File do
  @max_current_line_tasks 20
  @print_top_words 5

  def count(file_path) do
    file_path
    |> File.stream!
    |> Enum.reduce({0,[]},&task_counting/2)
    |> summarize
  end

  def task_counting(line, {outstanding_tasks, tasks})
    when outstanding_tasks >= @max_current_line_tasks do

    wait_for_tasks(tasks)

    task_counting(line, {0, []})
  end
  def task_counting(line, {outstanding_tasks, tasks}) do
    task_pid = Task.async(fn -> count_words(line) end)
    {outstanding_tasks + 1, [task_pid | tasks]}
  end

  def wait_for_tasks(tasks) do
    tasks
    |> Enum.reverse
    |> Enum.map(&(Task.await(&1)))

    :ok
  end

  def summarize({_, tasks}) do
    wait_for_tasks(tasks)

    WerdCounter.WordsAgent.sort_desc
    |> Enum.take(@print_top_words)
    |> Enum.reduce({1, "\nCount complete, Top #{@print_top_words} words by usage:\n"},
        fn
          {word, count}, {index, summary} -> {index + 1, summary <> "#{index}: #{word} - #{count}\n"}
        end
      )
    |> (fn {_, summary} -> summary end).()
  end

  def count_words(line) do
    line
    |> String.strip
    |> String.downcase
    |> String.split
    |> Enum.map(fn word -> WerdCounter.WordsAgent.increment_word(word) end)
  end
end
