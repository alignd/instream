defmodule Instream.Log.QueryEntry do
  @moduledoc """
  Log entry definition for query requests.
  """

  defstruct [
    type: nil,
    data: %{}
  ]

  @type t :: %__MODULE__{
    type: atom,
    data: map
  }
end
