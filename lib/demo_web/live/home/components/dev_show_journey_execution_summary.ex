defmodule DemoWeb.Live.Home.Components.DevShowJourneyExecutionSummary do
  @moduledoc false

  use Phoenix.Component
  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.Gear

  def render(assigns) do
    ~H"""
    <div
      class={Classes.devs_chevron()}
      phx-click="chevron_toggle"
      phx-value-toggle_field_name="dev_show_journey_execution_summary"
    >
      <div class="flex items-center text-sm text-gray-700">
        <span class="mr-2">
          {if Map.get(@values, :dev_show_journey_execution_summary, false), do: "▲", else: "▼"}
        </span>
        <span>
          <Gear.render checked={Map.get(@values, :dev_show_journey_execution_summary, false)} />
          Journey Execution Summary
        </span>
      </div>
    </div>

    <div
      :if={Map.get(@values, :dev_show_journey_execution_summary, false)}
      id="section-execution-summary-id"
      class=""
    >
      <pre class={Classes.debug_pre()}><%= "iex> \"#{@execution_id}\" |> Journey.Tools.summarize_as_text() |> IO.puts()\n#{@execution_summary}" %></pre>
    </div>
    """
  end
end
