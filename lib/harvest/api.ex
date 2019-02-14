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

  defp build_url([]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries"
  end

  defp build_url([user: user]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries?of_user=#{user}"
  end

  defp build_url([date: date]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries?from=#{date}&to=#{date}"
  end

  defp build_url([user: user, date: date]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries?from=#{date}&to=#{date}&user_id=#{user}"
  end

  defp build_url([day_entry_id: day_entry_id]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries/#{day_entry_id}"
  end

  defp build_url([user: user, day_entry_id: day_entry_id]) do
    "#{protocol()}://api.harvestapp.com/v2/time_entries/#{day_entry_id}?of_user=#{user}"
  end

  defp headers do
    %{"Content-Type" => "application/json",
      "Accept" => "application/json",
      "Authorization" => access_token(),
      "Harvest-Account-ID" => account_id(),
      "User-Agent" => user_agent(),
    }
  end

  defp basic_auth do
    #[hackney: [basic_auth: {email, password}]]
  end

  def get_entries do
    request([])
    |> process_response(:entries)
  end

  def get_entries([user: user]) do
    request([user: user])
    |> process_response(:entries)
  end

  def get_entries([year: year, month: month, day: day]) do
    {:ok, date} = Date.new(year, month, day)
    request([date: date])
    |> process_response(:entries)
  end

  def get_entries([user: user, year: year, month: month, day: day]) do
    {:ok, date} = Date.new(year, month, day)
    request([user: user, date: date])
    |> process_response(:entries)
  end

  def get_entry([day_entry_id: day_entry_id]) do
    request([day_entry_id: day_entry_id])
    |> process_response(:entry)
  end

  def get_entry([user: user, day_entry_id: day_entry_id]) do
    request([user: user, day_entry_id: day_entry_id])
    |> process_response(:entry)
  end

  defp request(params) do
    build_url(params)
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
