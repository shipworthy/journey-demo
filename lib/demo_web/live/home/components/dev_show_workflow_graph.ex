defmodule DemoWeb.Live.Home.Components.DevShowWorkflowGraph do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div :if={@graph_mermaid} class="flex items-center bg-blue-50 p-4 rounded-lg mt-4">
      <form
        id="form-dev-show-workflow-graph-id"
        phx-value-toggle_field_name="dev_show_workflow_graph"
        phx-change="dev_toggle"
      >
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_workflow_graph-id"
          checked={Map.get(@values, :dev_show_workflow_graph, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label for="dev_show_workflow_graph-id" class="ml-2 inline-block text-sm text-gray-700">
          Devs: See Workflow Graph Definition (Mermaid)
        </label>
      </form>
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
