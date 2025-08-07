defmodule DemoWeb.Live.Home.Components.FlowAnalytics do
  use Phoenix.Component

  @moduledoc false

  def render(assigns) do
    ~H"""
    <div id="flow-analytics-table" class="mt-2 p-4 bg-white border rounded">
      <div class="space-y-4">
        <!-- Overview Stats -->
        <div class="bg-gray-50 p-3 rounded">
          <h4 class="font-semibold text-md mb-2">
            Overview: {@flow_analytics.graph_name} ({@flow_analytics.graph_version})
          </h4>
          <div class="grid grid-cols-3 gap-4 text-md">
            <div>
              <span class="text-gray-600">Total Executions:</span>
              <span class="font-medium ml-1">{@flow_analytics.executions.count}</span>
            </div>
            <div>
              <span class="text-gray-600">Avg Duration:</span>
              <span class="font-medium ml-1">
                <%= if avg = @flow_analytics.executions.duration_avg_seconds_to_last_update do %>
                  {cond do
                    avg < 60 ->
                      "#{round(avg)}s"

                    avg < 3600 ->
                      minutes = div(round(avg), 60)
                      secs = rem(round(avg), 60)
                      if secs > 0, do: "#{minutes}m #{secs}s", else: "#{minutes}m"

                    true ->
                      hours = div(round(avg), 3600)
                      minutes = div(rem(round(avg), 3600), 60)
                      if minutes > 0, do: "#{hours}h #{minutes}m", else: "#{hours}h"
                  end}
                <% else %>
                  N/A
                <% end %>
              </span>
            </div>
            <div>
              <span class="text-gray-600">Median Duration:</span>
              <span class="font-medium ml-1">
                <%= if median = @flow_analytics.executions.duration_median_seconds_to_last_update do %>
                  {cond do
                    median < 60 ->
                      "#{round(median)}s"

                    median < 3600 ->
                      minutes = div(round(median), 60)
                      secs = rem(round(median), 60)
                      if secs > 0, do: "#{minutes}m #{secs}s", else: "#{minutes}m"

                    true ->
                      hours = div(round(median), 3600)
                      minutes = div(rem(round(median), 3600), 60)
                      if minutes > 0, do: "#{hours}h #{minutes}m", else: "#{hours}h"
                  end}
                <% else %>
                  N/A
                <% end %>
              </span>
            </div>
          </div>
        </div>
        
    <!-- Node Statistics Table -->
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b text-left">
              <th class="pb-2">Node</th>
              <th class="pb-2">Type</th>
              <th class="pb-2 text-right">Reached</th>
              <th class="pb-2 text-right">Avg Time</th>
              <th class="pb-2 text-right">Drop-off</th>
            </tr>
          </thead>
          <tbody>
            <%= for node <- (@flow_analytics.node_stats.nodes || []) |> Enum.sort_by(& &1.average_time_to_reach) do %>
              <tr class={
                if node.reached_percentage < 100, do: "border-b bg-yellow-50", else: "border-b"
              }>
                <td class="py-2 font-medium">{node.node_name}</td>
                <td class="py-2 text-gray-600">{node.node_type}</td>
                <td class="py-2 text-right">
                  {node.reached_count}/{@flow_analytics.executions.count} ({Float.round(
                    node.reached_percentage,
                    1
                  )}%)
                </td>
                <td class="py-2 text-right">
                  {time = node.average_time_to_reach

                  cond do
                    time < 60 ->
                      "#{round(time)}s"

                    time < 3600 ->
                      minutes = div(round(time), 60)
                      secs = rem(round(time), 60)
                      if secs > 0, do: "#{minutes}m #{secs}s", else: "#{minutes}m"

                    true ->
                      hours = div(round(time), 3600)
                      minutes = div(rem(round(time), 3600), 60)
                      if minutes > 0, do: "#{hours}h #{minutes}m", else: "#{hours}h"
                  end}
                </td>
                <td class={
                    "py-2 text-right " <>
                    if node.flow_ends_here_percentage_of_all > 0 do
                      "text-orange-600"
                    else
                      "text-green-600"
                    end
                  }>
                  {Float.round(node.flow_ends_here_percentage_of_all, 1)}%
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
        
    <!-- Key Insights -->
        <div class="bg-blue-50 p-3 rounded">
          <h4 class="font-semibold text-md mb-2">Key Insights</h4>
          <ul class="text-md space-y-1">
            <% total = @flow_analytics.executions.count

            completed_nodes =
              (@flow_analytics.node_stats.nodes || [])
              |> Enum.filter(&(&1.reached_percentage == 100.0))
              |> length()

            partial_nodes =
              (@flow_analytics.node_stats.nodes || [])
              |> Enum.filter(&(&1.reached_percentage < 100.0 && &1.reached_percentage > 0))

            first_partial = if length(partial_nodes) > 0, do: hd(partial_nodes), else: nil %>
            <li>• {completed_nodes} nodes reached by all {total} executions</li>
            <%= if first_partial do %>
              <li>
                • {first_partial.node_name} has {Float.round(
                  first_partial.reached_percentage,
                  1
                )}% conversion rate
              </li>
            <% end %>
            <% email_node =
              Enum.find(
                @flow_analytics.node_stats.nodes || [],
                &(&1.node_name == :email_address)
              ) %>
            <%= if email_node && email_node.average_time_to_reach > 120 do %>
              <li>
                • Users take ~{div(round(email_node.average_time_to_reach), 60)} minutes before entering email
              </li>
            <% end %>
            <% name_node =
              Enum.find(@flow_analytics.node_stats.nodes || [], &(&1.node_name == :name)) %>
            <%= if name_node && name_node.average_time_to_reach < 10 do %>
              <li>
                • Quick start: names entered within {round(name_node.average_time_to_reach)} seconds
              </li>
            <% end %>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
