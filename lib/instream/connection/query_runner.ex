defmodule Instream.Connection.QueryRunner do
  @moduledoc """
  Executes a query for a connection.
  """

  alias Instream.Log.QueryEntry
  alias Instream.Query
  alias Instream.Query.Headers
  alias Instream.Query.URL
  alias Instream.Response

  @doc """
  Executes `:ping` queries.
  """
  @spec ping(Query.t, Keyword.t, Keyword.t) :: :pong | :error
  def ping(%Query{} = query, opts, conn) do
    headers = conn |> Headers.assemble()
    result  =
      conn
      |> URL.ping(query.opts[:host])
      |> :hackney.head(headers)
      |> Response.parse_ping()

    if false != opts[:log] do
      conn[:module].__log__(%QueryEntry{
        type: :ping,
        data: %{
          host:   query.opts[:host] || hd(conn[:hosts]),
          result: result
        }
      })
    end

    result
  end

  @doc """
  Executes `:read` queries.
  """
  @spec read(Query.t, Keyword.t, Keyword.t) :: any
  def read(%Query{} = query, opts, conn) do
    headers = conn |> Headers.assemble()
    url     =
      conn
      |> URL.query()
      |> URL.append_database(opts[:database])
      |> URL.append_epoch(query.opts[:precision])
      |> URL.append_query(query.payload)

    { :ok, status, headers, client } = :hackney.get(url, headers)
    { :ok, response }                = :hackney.body(client)

    result =
      { status, headers, response }
      |> Response.maybe_parse(opts)

    if false != opts[:log] do
      conn[:module].__log__(%QueryEntry{
        type: :read,
        data: %{ query: query.payload }
      })
    end

    result
  end

  @doc """
  Execute `:status` queries.
  """
  @spec status(Query.t, Keyword.t, Keyword.t) :: :ok | :error
  def status(%Query{} = query, _opts, conn) do
    headers = conn |> Headers.assemble()

    conn
    |> URL.status(query.opts[:host])
    |> :hackney.head(headers)
    |> Response.parse_status()
  end

  @doc """
  Executes `:write` queries.
  """
  @spec write(Query.t, Keyword.t, Keyword.t) :: any
  def write(%Query{} = query, opts, conn) do
    query
    |> conn[:writer].write(opts, conn)
    |> Response.maybe_parse(opts)
  end
end
