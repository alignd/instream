defmodule Instream.Log.DefaultLoggerTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias Instream.Log.DefaultLogger
  alias Instream.Log.WriteEntry

  test "write log entry" do
    entry = %WriteEntry{ points: 16 }

    log = capture_io :user, fn ->
      DefaultLogger.log(entry)

      :timer.sleep(10)
    end

    assert String.contains?(log, "#{ entry.points } points")
  end
end
