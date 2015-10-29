defmodule WerdCounter.File do
  @max_current_line_tasks 100

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
    "Done!"
  end

  def count_words(line) do
    line
    |> String.strip
    |> String.downcase
    |> String.split
    |> Enum.map(fn word -> WerdCounter.WordsAgent.increment_word(word) end)
  end
end
