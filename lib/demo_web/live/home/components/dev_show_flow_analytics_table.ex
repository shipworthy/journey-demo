defmodule DemoWeb.Live.Home.Components.DevShowFlowAnalyticsTable do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.FlowAnalytics

  def render(assigns) do
    ~H"""
    <div
      :if={@flow_analytics}
      class={Classes.devs_chevron()}
      phx-click="chevron_toggle"
      phx-value-toggle_field_name="dev_show_flow_analytics_table"
    >
      <div class="flex items-center text-sm text-gray-700">
        <span class="mr-2">
          {if Map.get(@values, :dev_show_flow_analytics_table, false), do: "▲", else: "▼"}
        </span>
        <span>Devs: See Flow Analytics Table</span>
      </div>
    </div>

    <div
      :if={@flow_analytics && Map.get(@values, :dev_show_flow_analytics_table, false)}
      id="section-flow-analytics-table-id"
    >
      <FlowAnalytics.render flow_analytics={@flow_analytics} />
    </div>
    """
  end
end
