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
    Logger.debug(fn -> log_entry(entry) end)

    entry
  end

  def log(%WriteEntry{} = entry) do
    Logger.debug fn ->
      "write #{ entry.points } points"
    end

    entry
  end


  # Query string construction methods

  defp log_entry(%QueryEntry{ type: :ping, data: data }) do
    [ "[ping ", data[:host], "] ", to_string(data[:result]) ]
  end

  defp log_entry(%QueryEntry{ type: :read, data: data }) do
    [ "[read] ", data[:query] ]
  end
end
