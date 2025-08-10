defmodule DemoWeb.Live.Home.Components.DevShowAllValues do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div
      class={Classes.devs_chevron()}
      phx-click="chevron_toggle"
      phx-value-toggle_field_name="dev_show_all_values"
    >
      <div class="flex items-center text-sm text-gray-700">
        <span class="mr-2">
          {if Map.get(@values, :dev_show_all_values, false), do: "▲", else: "▼"}
        </span>
        <span>Devs: See All Values (raw data)</span>
      </div>
    </div>

    <div :if={Map.get(@values, :dev_show_all_values, false)} id="section-all-values-id">
      <pre class={Classes.debug_pre()}><%= "iex> \"#{@execution_id}\" |> Journey.load() |> Journey.values_all()\n#{inspect(@all_values, pretty: true)}" %></pre>
    </div>
    """
  end
end
