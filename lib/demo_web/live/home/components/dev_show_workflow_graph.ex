defmodule DemoWeb.Live.Home.Components.DevShowWorkflowGraph do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div :if={@graph_mermaid} class="flex items-center bg-blue-50 p-4 rounded-lg mt-4">
      <form phx-value-toggle_field_name="dev_show_workflow_graph" phx-change="dev_toggle">
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_workflow_graph"
          checked={Map.get(@values, :dev_show_workflow_graph, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label for="dev_show_workflow_graph" class="ml-2 inline-block text-sm text-gray-700">
          Devs: See Workflow Graph Definition (Mermaid)
        </label>
      </form>
    </div>

    <div :if={@graph_mermaid && Map.get(@values, :dev_show_workflow_graph, false)} class="mt-4">
      <div class="mt-2 p-4 bg-white border rounded">
        <div class="text-md text-gray-600 mb-2">
          Journey Workflow (Mermaid Format) - Paste this into
          <a href="https://mermaid.live/" target="_blank" class="text-blue-600 hover:underline">
            https://mermaid.live/
          </a>
          to view the visual representation.
        </div>
        <pre class={Classes.debug_pre()}>
          <%= "iex> Demo.HoroscopeGraph.graph() |> Journey.Tools.generate_mermaid_graph() |> IO.puts()\n#{@graph_mermaid}\n\n" %>
        </pre>
      </div>
    </div>
    """
  end
end
