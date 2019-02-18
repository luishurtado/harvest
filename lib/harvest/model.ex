defmodule Harvest.Model do
  @moduledoc """
  Types used in Harvest Time Tracking API.

  ## Reference
  https://help.getharvest.com/api-v2/
  """

  defmodule TimeEntry do
    defstruct id:               nil,
              spent_date:       nil,
              user:             nil,
              client:           nil,
              project:          nil,
              user_assignment:  nil,
              task:             nil,
              task_assignment:  nil,
              hours:            nil,
              notes:            nil,
              created_at:       nil,
              updated_at:       nil,
              timer_started_at: nil,
              started_time:     nil,
              ended_at:         nil

    @type t :: %TimeEntry{
      id:                integer,
      spent_date:        binary,
      user:              integer,
      client:            binary,
      project:           binary,
      user_assignment:   binary,
      task:              binary,
      task_assignment:   binary,
      hours:             float,
      notes:             binary,
      created_at:        binary,
      updated_at:        binary,
      timer_started_at:  binary,
      started_time:      binary,
      ended_at:          binary
    }
  end

  defmodule Task do
    defstruct id: nil,
              name: nil,
              billable_by_default:  true

    @type t :: %Task{
      id: integer,
      name: binary,
      billable_by_default: boolean
    }
  end

  defmodule Project do
    defstruct id: nil,
              name: nil,
              code: nil,
              is_billable: true

    @type t :: %Project{
      id: integer,
      name: binary,
      code: binary,
      is_billable: boolean
    }

  end

end
