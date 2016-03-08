defmodule Instream.Log.DefaultLogger do
  @moduledoc """
  Default logger for all entries.
  """

  alias Instream.Log.QueryEntry
  alias Instream.Log.WriteEntry

  @doc """
  Logs a request.
  """
  @spec log(QueryEntry.t | WriteEntry.t) :: QueryEntry.t | WriteEntry.t
  def log(%QueryEntry{} = entry), do: entry
  def log(%WriteEntry{} = entry), do: entry
end
