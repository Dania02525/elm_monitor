defmodule ElmMon.MonitorChannel do
  use ElmMon.Web, :channel

  def join("monitor:memory", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("ping", _payload, socket) do
    payload = %{ "topic" => "",
                 "event" => "pong",
                 "payload" => %{"message" => "pong"},
                 "ref" => ""
               }
    {:reply, {:ok, payload}, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end