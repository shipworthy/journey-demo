defmodule DemoWeb.Live.Home.Components.ComputationState do
  @moduledoc false

  use Phoenix.Component

  import DemoWeb.CoreComponents, only: [icon: 1]
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div>
      <% failure? = Journey.Tools.computation_state(@execution_id, @node_name) == :failed %>
      <pre
        id={"computation-state-#{@node_name}-id"}
        class={Classes.debug_pre() <> if(failure?, do: " bg-red-50", else: " ")}
      >{"iex> Journey.Tools.computation_status_as_text(\"#{@execution_id}\", :#{@node_name}) |> IO.puts\n" <>
      Map.get(@computation_states, @node_name, "")}</pre>
      <div
        :if={failure?}
        class="text-rose-800 hover:text-rose-900 border-rose-400 hover:border-rose-500 border bg-rose-100 hover:bg-rose-200 px-3 py-1.5 my-2 text-center font-mono text-sm rounded cursor-pointer transition-colors duration-150"
        phx-value-node_name={@node_name}
        phx-click="on-retry-computation-click"
      >
        <.icon name="hero-arrow-path" class="w-4 h-4 mr-1" /> Retry
      </div>
    </div>
    """
  end
end
