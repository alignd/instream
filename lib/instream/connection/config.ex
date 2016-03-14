defmodule Instream.Connection.Config do
  @moduledoc """
  Configuration helper module.
  """

  @defaults [
    loggers: [{ Instream.Log.DefaultLogger, :log, [] }],
    port:    8086,
    scheme:   "http",
    writer:  Instream.Writer.Line
  ]

  @doc """
  Retrieves the connection configuration for `conn` in `otp_app`.
  """
  @spec config(atom, atom) :: Keyword.t
  def config(otp_app, conn) do
    if config = Application.get_env(otp_app, conn) do
      ([ otp_app: otp_app ] ++ config) |> add_defaults()
    else
      raise ArgumentError,
        "configuration for #{ inspect conn } not found in #{ inspect otp_app } configuration"
    end
  end


  defp add_defaults(config), do: Keyword.merge(@defaults, config)
end
