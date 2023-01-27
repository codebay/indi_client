defmodule IndiClient do
  @moduledoc """
  Documentation for `IndiClient`.
  """

  def connect(host \\ '127.0.0.1', port \\ 7624) do
    INDI.Server.start_link(host, port)
  end

  def getProperties(server_pid) do
    GenServer.call(server_pid, :get_properties)
  end

  def disconnect(server_pid) do
    GenServer.call(server_pid, :close)
  end
end
