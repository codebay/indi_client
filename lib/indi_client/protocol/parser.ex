defmodule IndiClient.Protocol.Parser do
  def parse(xml, state) do
    Saxy.parse_string(xml, IndiClient.Protocol.SaxEventHandler, state)
  end
end
