defmodule DemoWeb.Live.Home.Components.DevShowOtherComputedValues do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.ComputationState

  # Helper function to format timestamp fields
  defp format_timestamp(nil), do: "not set"

  defp format_timestamp(unix_timestamp) when is_integer(unix_timestamp) do
    DateTime.from_unix!(unix_timestamp)
    |> Calendar.strftime("%B %d, %Y at %I:%M %p")
  end

  defp format_timestamp(_), do: "not set"

  def render(assigns) do
    ~H"""
    <div :if={@connected?} class="flex items-center bg-blue-50 p-4 rounded-lg mt-4">
      <form phx-value-toggle_field_name="dev_show_other_computed_values" phx-change="dev_toggle">
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_other_computed_values"
          checked={Map.get(@values, :dev_show_other_computed_values, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label for="dev_show_other_computed_values" class="ml-2 inline-block text-sm text-gray-700">
          Devs: See All Other Computed Values
        </label>
      </form>
    </div>

    <div
      :if={@connected? and Map.get(@values, :dev_show_other_computed_values, false)}
      class="bg-white p-6 rounded-lg shadow mt-4"
    >
      <h2 class="text-xl font-semibold mb-4">Other Computed Values</h2>

      <div class="space-y-4">
        <div>
          <label class={Classes.label()}>name_validation</label>
          <div class={Classes.read_only_value(Map.has_key?(@values, :name_validation))}>
            {Map.get(@values, :name_validation, "not set")}
          </div>
          <ComputationState.render
            execution_id={@execution_id}
            node_name={:name_validation}
            computation_states={@computation_states}
          />
        </div>

        <div>
          <label class={Classes.label()}>weekly_reminder_schedule</label>
          <div class={Classes.read_only_value(Map.has_key?(@values, :weekly_reminder_schedule))}>
            {format_timestamp(Map.get(@values, :weekly_reminder_schedule))}
          </div>
          <ComputationState.render
            execution_id={@execution_id}
            node_name={:weekly_reminder_schedule}
            computation_states={@computation_states}
          />
        </div>

        <div>
          <label class={Classes.label()}>schedule_archive</label>
          <div class={Classes.read_only_value(Map.has_key?(@values, :schedule_archive))}>
            {format_timestamp(Map.get(@values, :schedule_archive))}
          </div>
          <ComputationState.render
            execution_id={@execution_id}
            node_name={:schedule_archive}
            computation_states={@computation_states}
          />
        </div>

        <div>
          <label class={Classes.label()}>send_weekly_reminder</label>
          <div class={Classes.read_only_value(Map.has_key?(@values, :send_weekly_reminder))}>
            {Map.get(@values, :send_weekly_reminder, "not set")}
          </div>
          <ComputationState.render
            execution_id={@execution_id}
            node_name={:send_weekly_reminder}
            computation_states={@computation_states}
          />
        </div>

        <div>
          <label class={Classes.label()}>auto_archive</label>
          <div class={Classes.read_only_value(Map.has_key?(@values, :auto_archive))}>
            {Map.get(@values, :auto_archive, "not set")}
          </div>
          <ComputationState.render
            execution_id={@execution_id}
            node_name={:auto_archive}
            computation_states={@computation_states}
          />
        </div>

        <div>
          <label class={Classes.label()}>anonymize_name</label>
          <div class={Classes.read_only_value(Map.has_key?(@values, :anonymize_name))}>
            {Map.get(@values, :anonymize_name, "not set")}
          </div>
          <ComputationState.render
            execution_id={@execution_id}
            node_name={:anonymize_name}
            computation_states={@computation_states}
          />
        </div>
      </div>
    </div>
    """
  end
end
