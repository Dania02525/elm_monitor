defmodule ElmMon.MemoryStats do
  use GenServer

  @mem_log_frequency 1_000

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    wait_interval()
    {:ok, []}
  end

  def handle_info(:log_mem, state) do
    state = do_log_mem(state)
    wait_interval()
    {:noreply, state}
  end

  defp do_log_mem(state) do
    ElmMon.Endpoint.broadcast("monitor:memory", "update", %{stat: "#{:erlang.memory(:total)}"})
    state
  end

  defp wait_interval() do
    Process.send_after(self(), :log_mem, @mem_log_frequency)
  end

end