defmodule Instream.Log.WriteEntryTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias Instream.TestHelpers.LogConnection


  defmodule TestSeries do
    use Instream.Series

    series do
      database    "test_database"
      measurement "log_write_entry_test"

      tag :t

      field :f
    end
  end


  test "logging write requests" do
    points = [
      %TestSeries{
        tags:   %TestSeries.Tags{ t: "foo" },
        fields: %TestSeries.Fields{ f: "foo" }
      },
      %TestSeries{
        tags:   %TestSeries.Tags{ t: "bar" },
        fields: %TestSeries.Fields{ f: "bar" }
      }
    ]

    log = capture_io :user, fn ->
      :ok = LogConnection.write(points)

      :timer.sleep(10)
    end

    assert String.contains?(log, "write")
    assert String.contains?(log, "#{ length(points) } points")
  end
end
