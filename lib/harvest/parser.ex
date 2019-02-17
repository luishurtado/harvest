defmodule Harvest.Parser do
  @moduledoc """
  Provides parser logics for API results.
  """

  alias Harvest.Model.TimeEntry
  alias Harvest.Model.Task
  alias Harvest.Model.Project

  def parse_result(result, action), do: parse(result, action)

  defp parse(:time_entries, l) when is_list(l), do: Enum.map(l, &(parse(TimeEntry, &1)))
  defp parse(:projects, l) when is_list(l), do: Enum.map(l, &(parse(Project, &1)))
  defp parse(:tasks, l) when is_list(l), do: Enum.map(l, &(parse(Task, &1)))

  defp parse(result, :entries), do: %{time_entries: parse(:time_entries, result[:time_entries])}
  defp parse(result, :entry), do: %{entry: parse(TimeEntry, result)}
  defp parse(result, :projects), do: %{projects: parse(:projects, result[:projects])}
  defp parse(result, :project), do: %{project: parse(Project, result)}
  defp parse(result, :tasks), do: %{tasks: parse(:tasks, result[:tasks])}
  defp parse(result, :task), do: %{task: parse(Task, result)}

  defp parse(type, val) do
    struct(type, val)
  end

end
