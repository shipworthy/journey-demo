defmodule DemoWeb.Live.Home.Components.FlowAnalyticsJson do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div
      class={Classes.devs_chevron()}
      phx-click="chevron_toggle"
      phx-value-toggle_field_name="dev_show_flow_analytics_json"
    >
      <div class="flex items-center text-sm text-gray-700">
        <span class="mr-2">
          {if Map.get(@values, :dev_show_flow_analytics_json, false), do: "▲", else: "▼"}
        </span>
        <span>Devs: See Flow Analytics (raw data)</span>
      </div>
    </div>

    <div
      :if={Map.get(@values, :dev_show_flow_analytics_json, false)}
      id="section-flow-analytics-json-id"
      class=""
    >
      <pre class={Classes.debug_pre()}><%= "iex> g = Demo.HoroscopeGraph.graph()\niex> Journey.Insights.FlowAnalytics.flow_analytics(g.name, g.version)\n#{inspect(@flow_analytics, pretty: true)}" %></pre>
    </div>
    """
  end
end
