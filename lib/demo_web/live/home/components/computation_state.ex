defmodule DemoWeb.Live.Home.Components.ComputationState do
  @moduledoc false

  use Phoenix.Component
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <pre id={"computation-state-#{@node_name}-id"} class={Classes.debug_pre()}>{"iex> Journey.Tools.what_am_i_waiting_for(\"#{@execution_id}\", :#{@node_name}) |> IO.puts\n" <>
      Map.get(@computation_states, @node_name, "")}</pre>
    """
  end
end
