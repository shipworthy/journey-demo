defmodule DemoWeb.Live.Home.Components.DevShowRecentExecutions do
  @moduledoc false

  use Phoenix.Component
  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.Gear

  def render(assigns) do
    ~H"""
    <div
      class={Classes.devs_chevron()}
      phx-click="chevron_toggle"
      phx-value-toggle_field_name="dev_show_recent_executions"
    >
      <div class="flex items-center text-sm text-gray-700">
        <span class="mr-2">
          {if Map.get(@values, :dev_show_recent_executions, false), do: "▲", else: "▼"}
        </span>
        <span>
          <Gear.render checked={Map.get(@values, :dev_show_recent_executions, false)} />
          Recent executions (20 most recently updated)
        </span>
      </div>
    </div>

    <div :if={Map.get(@values, :dev_show_recent_executions, false)} id="section-recent-executions-id">
      <pre class={Classes.debug_pre()}><%= "iex> Journey.list_executions(order_by_execution_fields: [updated_at: :desc], limit: 20) |> Enum.map(fn e -> Journey.values(e) end) |> IO.inspect()\n\n#{get_recent_executions()}" %></pre>
    </div>
    """
  end

  defp get_recent_executions do
    case Journey.list_executions(order_by_execution_fields: [updated_at: :desc], limit: 20) do
      executions when is_list(executions) ->
        executions
        |> Enum.map(fn e -> Journey.values(e) end)
        |> inspect(pretty: true, limit: :infinity)

      _ ->
        "[]"
    end
  end
end
