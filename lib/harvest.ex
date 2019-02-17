defmodule Harvest do
  defdelegate get_entries,        to: Harvest.API
  defdelegate get_entries(opts),  to: Harvest.API
  defdelegate get_entry(opts),    to: Harvest.API
  defdelegate get_projects,       to: Harvest.API
  defdelegate get_projects(opts), to: Harvest.API
  defdelegate get_project(opts),  to: Harvest.API
  defdelegate get_tasks,          to: Harvest.API
  defdelegate get_task(opts),     to: Harvest.API
end
