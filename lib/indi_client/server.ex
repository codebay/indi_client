defmodule IndiClient.Server do
  use GenServer

  alias IndiClient.Client

  def start_link(host, port) do
    GenServer.start_link(__MODULE__, {host, port})
  end

  def init({host, port}) do
    {:ok, Client.connect(host, port)}
  end

  def handle_call(:get_properties, _from, client_pid) do
    {client_pid, data} = Client.getProperties(client_pid)
    {:reply, data, client_pid}
  end

  def handle_call(:close, _from, client) do
    client = Client.disconnect(client)
    {:reply, nil, client}
  end
end
