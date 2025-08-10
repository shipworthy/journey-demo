defmodule DemoWeb.Live.Home.Components.DevShowFlowAnalyticsTable do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Home.Components.FlowAnalytics

  def render(assigns) do
    ~H"""
    <div :if={@flow_analytics} class="flex items-center bg-blue-50 p-4 rounded-lg mt-4">
      <form
        id="form-dev-show-flow-analytics-table-id"
        phx-value-toggle_field_name="dev_show_flow_analytics_table"
        phx-change="dev_toggle"
      >
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_flow_analytics_table"
          checked={Map.get(@values, :dev_show_flow_analytics_table, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label for="dev_show_flow_analytics_table" class="ml-2 inline-block text-sm text-gray-700">
          Devs: See Flow Analytics Table
        </label>
      </form>
    </div>

    <div
      :if={@flow_analytics && Map.get(@values, :dev_show_flow_analytics_table, false)}
      id="section-flow-analytics-table"
    >
      <FlowAnalytics.render flow_analytics={@flow_analytics} />
    </div>
    """
  end
end
