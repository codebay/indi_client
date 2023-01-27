defmodule IndiClient.Client do
  alias Indi.TCPClient

  defmodule State do
    defstruct tcp_pid: nil
  end

  def connect(host, port) do
    {:ok, tcp_pid} = TCPClient.start_link(host, port, [mode: :binary])
    %State{tcp_pid: tcp_pid}
  end

  def getProperties(%State{tcp_pid: tcp_pid} = client) when is_pid(tcp_pid) do
    TCPClient.send(tcp_pid, '<getProperties version="1.7"/>')
    {:ok, data} = TCPClient.recv(tcp_pid, 0)
    {client, data}
  end

  def disconnect(%State{tcp_pid: tcp_pid} = client) when tcp_pid !== nil do
    TCPClient.close(tcp_pid)
    %{client | tcp_pid: nil}
  end
end
