defmodule DemoWeb.Live.Home.Components.DevShowJourneyExecutionSummary do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div class="flex items-center bg-blue-50 p-4 rounded-lg mt-4">
      <form
        id="form-dev-show-journey-execution-summary-id"
        phx-value-toggle_field_name="dev_show_journey_execution_summary"
        phx-change="dev_toggle"
      >
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_journey_execution_summary"
          checked={Map.get(@values, :dev_show_journey_execution_summary, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label
          for="dev_show_journey_execution_summary"
          class="ml-2 inline-block text-sm text-gray-700"
        >
          Devs: See Journey Execution Summary
        </label>
      </form>
    </div>

    <div
      :if={Map.get(@values, :dev_show_journey_execution_summary, false)}
      id="section-execution-summary"
      class="mt-4"
    >
      <pre class={Classes.debug_pre()}><%= "iex> \"#{@execution_id}\" |> Journey.Tools.summarize() |> IO.puts()\n#{@execution_summary}" %></pre>
    </div>
    """
  end
end
