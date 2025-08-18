defmodule DemoWeb.Live.Home.Components.DevShowWorkflowGraph do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.Gear

  def render(assigns) do
    ~H"""
    <div
      :if={@graph_mermaid}
      class={Classes.devs_chevron()}
      phx-click="chevron_toggle"
      phx-value-toggle_field_name="dev_show_workflow_graph"
    >
      <div class="flex items-center text-sm text-gray-700">
        <span class="mr-2">
          {if Map.get(@values, :dev_show_workflow_graph, false), do: "▲", else: "▼"}
        </span>
        <span><Gear.render /> See Workflow Graph Definition (Mermaid)</span>
      </div>
    </div>

    <div
      :if={Map.get(@values, :dev_show_workflow_graph, false)}
      id="section-workflow-graph-id"
      class="text-md text-gray-600 my-2"
    >
      Journey Workflow (Mermaid Format) - Paste mermaid code into
      <a href="https://mermaid.live/" target="_blank" class="text-blue-600 hover:underline">
        https://mermaid.live/
      </a>
      to view the visual representation.
    </div>

    <div
      :if={Map.get(@values, :dev_show_workflow_graph, false)}
      id="section-workflow-graph-code-id"
      class="mt-4"
    >
      <pre class={Classes.debug_pre()}><%= "iex> Demo.HoroscopeGraph.graph() |> Journey.Tools.generate_mermaid_graph() |> IO.puts()\n#{@graph_mermaid}\n\n" %></pre>
    </div>
    """
  end
end
