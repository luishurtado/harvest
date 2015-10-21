defmodule Harvest do
  defdelegate get_entries,       to: Harvest.API
  defdelegate get_entries(opts), to: Harvest.API
  defdelegate get_entry(opts),   to: Harvest.API
end
