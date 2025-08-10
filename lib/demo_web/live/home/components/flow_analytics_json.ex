defmodule DemoWeb.Live.Home.Components.FlowAnalyticsJson do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div class="flex items-center bg-blue-50 p-4 rounded-lg mt-4">
      <form
        id="form-dev-show-flow-analytics-json-id"
        phx-value-toggle_field_name="dev_show_flow_analytics_json"
        phx-change="dev_toggle"
      >
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_flow_analytics_json"
          checked={Map.get(@values, :dev_show_flow_analytics_json, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label for="dev_show_flow_analytics_json" class="ml-2 inline-block text-sm text-gray-700">
          Devs: See Flow Analytics (raw data)
        </label>
      </form>
    </div>

    <div
      :if={Map.get(@values, :dev_show_flow_analytics_json, false)}
      id="section-flow-analytics-json"
      class="mt-4"
    >
      <pre class={Classes.debug_pre()}><%= "iex> g = Demo.HoroscopeGraph.graph()\niex> Journey.Insights.FlowAnalytics.flow_analytics(g.name, g.version)\n#{inspect(@flow_analytics, pretty: true)}" %></pre>
    </div>
    """
  end
end
