defmodule Harvest.API do
  @moduledoc """
  Provides basic functionalities for Harvest Time Tracking API.
  """

  alias Harvest.Model.Error

  defp access_token, do: Application.get_env(:harvest, :access_token)
  defp account_id, do: Application.get_env(:harvest, :account_id)
  defp user_agent, do: Application.get_env(:harvest, :user_agent)
  defp has_ssl, do: Application.get_env(:harvest, :has_ssl)

  defp protocol do
    if has_ssl(), do: "https", else: "http"
  end

  #Time Entries
  defp build_url(:entry, []) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries"
  end

  defp build_url(:entry, [user: user]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries?of_user=#{user}"
  end

  defp build_url(:entry, [date: date]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries?from=#{date}&to=#{date}"
  end

  defp build_url(:entry, [user: user, date: date]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries?from=#{date}&to=#{date}&user_id=#{user}"
  end

  defp build_url(:entry, [time_entry_id: time_entry_id]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries/#{time_entry_id}"
  end

  defp build_url(:entry, [user: user, time_entry_id: time_entry_id]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries/#{time_entry_id}?of_user=#{user}"
  end

  #Projects
  defp build_url(:project, []) do
    "#{protocol()}://api.harvestapp.com/v2/projects"
  end

  defp build_url(:project, [date: date]) do
    "#{protocol()}://api.harvestapp.com/v2/projects?from=#{date}&to=#{date}"
  end

  defp build_url(:project, [project_id: project_id]) do
    "#{protocol()}://api.harvestapp.com/v2/projects/#{project_id}"
  end

  #Tasks
  defp build_url(:task, []) do
    "#{protocol()}://api.harvestapp.com/v2/tasks"
  end

  defp build_url(:task, [task_id: task_id]) do
    "#{protocol()}://api.harvestapp.com/v2/tasks/#{task_id}"
  end

  defp headers do
    %{"Content-Type" => "application/json",
      "Accept" => "application/json",
      "Authorization" => access_token(),
      "Harvest-Account-ID" => account_id(),
      "User-Agent" => user_agent(),
    }
  end

  def get_entries do
    request(:entry, [])
    |> process_response(:entries)
  end

  def get_entries([user: user]) do
    request(:entry, [user: user])
    |> process_response(:entries)
  end

  def get_entries([year: year, month: month, day: day]) do
    {:ok, date} = Date.new(year, month, day)
    request(:entry, [date: date])
    |> process_response(:entries)
  end

  def get_entries([user: user, year: year, month: month, day: day]) do
    {:ok, date} = Date.new(year, month, day)
    request(:entry, [user: user, date: date])
    |> process_response(:entries)
  end

  def get_entry([time_entry_id: time_entry_id]) do
    request(:entry, [time_entry_id: time_entry_id])
    |> process_response(:entry)
  end

  def get_entry([user: user, time_entry_id: time_entry_id]) do
    request(:entry, [user: user, time_entry_id: time_entry_id])
    |> process_response(:entry)
  end

  def get_projects do
    request(:project, [])
    |> process_response(:projects)
  end

  def get_projects([year: year, month: month, day: day]) do
    {:ok, date} = Date.new(year, month, day)
    request(:project, [date: date])
    |> process_response(:projects)
  end

  def get_project([project_id: project_id]) do
    request(:project, [project_id: project_id])
    |> process_response(:project)
  end

  def get_tasks do
    request(:task, [])
    |> process_response(:tasks)
  end

  def get_task([task_id: task_id]) do
    request(:task, [task_id: task_id])
    |> process_response(:task)
  end

  defp request(api_object, params) do
    build_url(api_object, params)
    |> HTTPoison.get(headers())
  end

  defp process_response(response, action) do
    case response do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, %Error{reason: reason}}
      {:ok, %HTTPoison.Response{body: body}} ->
        Poison.decode!(body, keys: :atoms)
        |> Harvest.Parser.parse_result(action)
    end
  end

end
