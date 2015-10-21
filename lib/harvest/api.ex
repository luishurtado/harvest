defmodule Harvest.API do
  @moduledoc """
  Provides basic functionalities for Harvest Time Tracking API.
  """

  alias Harvest.Model.Error

  defp company, do: Application.get_env(:harvest, :company)
  defp email, do: Application.get_env(:harvest, :email)
  defp password, do: Application.get_env(:harvest, :password)
  defp has_ssl, do: Application.get_env(:harvest, :has_ssl)

  defp protocol do
    if has_ssl, do: "https", else: "http"
  end

  defp build_url([]) do
    "#{protocol}://#{company}.harvestapp.com/daily"
  end

  defp build_url([user: user]) do
    "#{protocol}://#{company}.harvestapp.com/daily?of_user=#{user}"
  end

  defp build_url([year: year, day: day_of_the_year]) do
    "#{protocol}://#{company}.harvestapp.com/daily/#{day_of_the_year}/#{year}"
  end

  defp build_url([user: user, year: year, day: day_of_the_year]) do
    "#{protocol}://#{company}.harvestapp.com/daily/#{day_of_the_year}/#{year}?of_user=#{user}"
  end

  defp build_url([day_entry_id: day_entry_id, action: action]) do
    "#{protocol}://#{company}.harvestapp.com/daily/#{action}/#{day_entry_id}"
  end

  defp build_url([user: user, day_entry_id: day_entry_id, action: action]) do
    "#{protocol}://#{company}.harvestapp.com/daily/#{action}/#{day_entry_id}?of_user=#{user}"
  end

  defp headers do
    %{"Content-Type" => "application/json",
      "Accept" => "application/json"}
  end

  defp basic_auth do
    [hackney: [basic_auth: {email, password}]]
  end

  def get_entries do
    request([])
    |> process_response(:entries)
  end

  def get_entries([user: user]) do
    request([user: user])
    |> process_response(:entries)
  end

  def get_entries([user: user, year: year, day: day_of_the_year]) do
    request([user: user, year: year, day: day_of_the_year])
    |> process_response(:entries)
  end

  def get_entry([day_entry_id: day_entry_id]) do
    request([day_entry_id: day_entry_id, action: :show])
    |> process_response(:entry)
  end

  def get_entry([user: user, day_entry_id: day_entry_id]) do
    request([user: user, day_entry_id: day_entry_id, action: :show])
    |> process_response(:entry)
  end

  defp request(params) do
    build_url(params)
    |> HTTPoison.get(headers, basic_auth)
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
