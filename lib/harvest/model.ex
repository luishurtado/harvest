defmodule Harvest.Model do
  @moduledoc """
  Types used in Harvest Time Tracking API.

  ## Reference
  https://github.com/harvesthq/api/blob/master/Sections/Time%20Tracking.md
  """

  defmodule DayEntry do
    defstruct id:               nil,
              spent_at:         nil,
              user_id:          nil,
              client:           nil,
              project_id:       nil,
              project:          nil,
              task_id:          nil,
              task:             nil,
              hours:            nil,
              notes:            nil,
              created_at:       nil,
              updated_at:       nil,
              timer_started_at: nil,
              started_at:       nil,
              ended_at:         nil

    @type t :: %DayEntry{
      id:               integer,
      spent_at:         binary,
      user_id:          integer,
      client:           binary,
      project_id:       binary,
      project:          binary,
      task_id:          binary,
      task:             binary,
      hours:            float,
      notes:            binary,
      created_at:       binary,
      updated_at:       binary,
      timer_started_at: binary,
      started_at:       binary,
      ended_at:         binary
    }
  end

  defmodule Timer do
    defstruct day_entry: nil,
              hours_for_previously_running_timer: nil

    @type t :: %Timer{
      day_entry: DayEntry.t,
      hours_for_previously_running_timer: float
    }
  end

  defmodule Task do
    defstruct id: nil,
              name: nil,
              billable: true

    @type t :: %Task{
      id: integer,
      name: binary,
      billable: boolean
    }
  end

  defmodule Project do
    defstruct id: nil,
              name: nil,
              code: nil,
              billable: true,
              tasks: nil

    @type t :: %Project{
      id: integer,
      name: binary,
      code: binary,
      billable: boolean,
      tasks: [Task.t]
    }

  end

  defmodule Error do
    defexception reason: nil
    @type t :: %Error{reason: any}

    def message(%Error{reason: reason}), do: inspect(reason)
  end
end
