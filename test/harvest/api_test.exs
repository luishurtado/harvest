defmodule Harvest.APITest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    unless Application.get_env(:harvest, :company) do
      Application.put_env(:harvest, :company, "acme")
    end

    unless Application.get_env(:harvest, :email) do
      Application.put_env(:harvest, :email, "roadrunner@acme.com")
    end

    unless Application.get_env(:harvest, :password) do
      Application.put_env(:harvest, :password, "beepbeep")
    end

    unless Application.get_env(:harvest, :has_ssl) do
      Application.put_env(:harvest, :has_ssl, true)
    end
  end

  defp time_entries do
    %{day_entries: [time_entry],
      for_day: "2015-09-29",
      projects: [
        %Harvest.Model.Project{
          billable: true,
          code: "",
          id: 3960746,
          name: "Customer Project 1",
          tasks: [
            %Harvest.Model.Task{
              billable: true,
              id: 698927,
              name: "Software Development"}]}]}
  end

  defp time_entry do
    %Harvest.Model.DayEntry{
      client: "Customer1",
      created_at: "2015-09-29T13:54:49Z",
      ended_at: nil,
      hours: 2.12,
      id: 379234955,
      notes: "Fixing login issues",
      project: "Customer Project 2",
      project_id: "2501399",
      spent_at: "2015-09-29",
      started_at: nil,
      task: "Software Development",
      task_id: "698927",
      timer_started_at: nil,
      updated_at: "2015-10-05T14:32:51Z",
      user_id: 174807}
  end

  test "today time entries by requesting user" do
    use_cassette "time_entries" do
      result = Harvest.get_entries()
      assert result == time_entries
    end
  end

  test "today time entries by a given user" do
    use_cassette "time_entries_user" do
      result = Harvest.get_entries([user: "174807"])
      assert result == time_entries
    end
  end

  test "time entries by a given user on given date" do
    use_cassette "time_entries_user_and_date" do
      result = Harvest.get_entries([user: "174807", year: "2015", day: "272"])
      assert result == time_entries
    end
  end

  test "selected time entry by requesting user" do
    use_cassette "time_entry" do
      result = Harvest.get_entry([day_entry_id: "379234955"])
      assert result == %{entry: time_entry}
    end
  end

  test "selected time entry by a given user" do
    use_cassette "time_entry_user" do
      result = Harvest.get_entry([user: "174807", day_entry_id: "379234955"])
      assert result == %{entry: time_entry}
    end
  end

end
