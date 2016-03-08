defmodule Instream.Log.DefaultLogger do
  @moduledoc """
  Default logger for all entries.
  """

  require Logger

  alias Instream.Log.QueryEntry
  alias Instream.Log.WriteEntry

  @doc """
  Logs a request.
  """
  @spec log(QueryEntry.t | WriteEntry.t) :: QueryEntry.t | WriteEntry.t
  def log(%QueryEntry{} = entry) do
    Logger.debug fn ->
      entry.query
    end

    entry
  end

  def log(%WriteEntry{} = entry) do
    Logger.debug fn ->
      "write #{ entry.points } points"
    end

    entry
  end
end
