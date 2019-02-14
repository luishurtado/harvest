defmodule Harvest.Parser do
  @moduledoc """
  Provides parser logics for API results.
  """

  alias Harvest.Model.DayEntry
  alias Harvest.Model.Task
  alias Harvest.Model.Project

  def parse_result(result, action), do: parse(result, action)

  defp parse(:day_entries, l) when is_list(l), do: Enum.map(l, &(parse(DayEntry, &1)))
  defp parse(:projects, l) when is_list(l), do: Enum.map(l, &(parse(Project, &1)))

  defp parse(result, :entries) do
    %{
      day_entries: parse(:time_entries, result[:time_entries]),
      #projects: parse(:projects, result[:projects]),
      #for_day: result[:for_day]
    }
  end
  defp parse(result, :entry), do: %{entry: parse(DayEntry, result)}

  defp parse(Project, p) when is_map(p) do
    struct(Project, Enum.map(p, &(parse(&1))))
  end

  defp parse(type, val) do
    struct(type, Enum.map(val, &(parse(&1))))
  end

  defp parse({:tasks, tasks}) when is_list(tasks) do
    {:tasks, Enum.map(tasks, &(parse(Task, &1)))}
  end

  defp parse(others), do: others
end
