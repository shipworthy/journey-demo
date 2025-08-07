defmodule DemoWeb.Live.Home.Components.ComputationState do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div class={Classes.computation_state()}>
      {"Requires:\n" <> Map.get(@computation_states, @node_name, "No computation state")}
    </div>
    """
  end
end
