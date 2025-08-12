defmodule DemoWeb.Live.Home.Index do
  use DemoWeb, :live_view

  @moduledoc false

  require Logger

  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.AboutSection
  alias DemoWeb.Live.Home.Components.ComputationState
  alias DemoWeb.Live.Home.Components.DevShowAllValues
  alias DemoWeb.Live.Home.Components.DevShowFlowAnalyticsTable
  alias DemoWeb.Live.Home.Components.DevShowJourneyExecutionSummary
  alias DemoWeb.Live.Home.Components.DevShowOtherComputedValues
  alias DemoWeb.Live.Home.Components.DevShowWorkflowGraph
  alias DemoWeb.Live.Home.Components.FlowAnalyticsJson

  @impl true
  def mount(%{"execution_id" => execution_id} = _params, _session, socket) do
    Logger.info("home.mount execution_id: #{execution_id}")

    socket =
      socket
      |> assign(:connected?, connected?(socket))
      |> set_system_stats_if_needed()

    loaded_execution = Journey.load(execution_id)

    socket =
      if loaded_execution == nil do
        socket
        |> assign(:execution_id, nil)
        |> create_execution_if_needed()
      else
        # Subscribe to PubSub for this execution
        :ok = Phoenix.PubSub.subscribe(Demo.PubSub, "execution:#{execution_id}")

        socket
        |> assign(:execution_id, execution_id)
        |> refresh_execution_state(loaded_execution)
      end

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    Logger.info("home.mount")

    socket =
      socket
      |> assign(:connected?, connected?(socket))
      |> set_system_stats_if_needed()
      |> assign(:execution_id, nil)
      |> assign(:values, %{})
      |> assign(:all_values, %{})
      |> assign(:execution_summary, nil)
      |> assign(:computation_states, %{})
      |> assign(:execution_history, [])

    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    Logger.info("handle_params: params: #{inspect(params)}, uri: #{inspect(uri)}")
    {:noreply, socket}
  end

  @impl true
  def handle_event("on-dev-show-more-click", _params, socket) do
    socket = create_execution_if_needed(socket)

    execution = Journey.load(socket.assigns.execution_id)
    current_value = Map.get(Journey.values(execution), :dev_show_more, false)
    updated_execution = Journey.set_value(execution, :dev_show_more, !current_value)

    socket = refresh_execution_state(socket, updated_execution)
    {:noreply, socket}
  end

  @impl true
  def handle_event("dev_toggle", params, socket) do
    socket = create_execution_if_needed(socket)
    field_name = Map.get(params, "toggle_field_name") |> String.to_existing_atom()
    bool_value = Map.get(params, "dev_toggle", "off") == "on"

    socket = apply_toggle_value(socket, field_name, bool_value)
    {:noreply, socket}
  end

  @impl true
  def handle_event("chevron_toggle", params, socket) do
    socket = create_execution_if_needed(socket)
    field_name = Map.get(params, "toggle_field_name") |> String.to_existing_atom()
    current_value = Map.get(socket.assigns.values, field_name, false)
    bool_value = !current_value

    socket = apply_toggle_value(socket, field_name, bool_value)
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_value", %{"field" => field, "value" => value}, socket) do
    socket = create_execution_if_needed(socket)

    Logger.info("update_value field: #{field} value: #{value}")

    field_atom = String.to_existing_atom(field)

    # Convert birth_day to integer if it's a number
    parsed_value =
      if field == "birth_day" and value != "" do
        case Integer.parse(value) do
          {num, ""} -> num
          _ -> value
        end
      else
        value
      end

    if !Map.has_key?(socket.assigns.values, field_atom) and parsed_value == "" do
      {:noreply, socket}
    else
      # Load execution, set the value, and reload to get updated values
      execution = Journey.load(socket.assigns.execution_id)
      updated_execution = Journey.set_value(execution, field_atom, parsed_value)

      socket = refresh_execution_state(socket, updated_execution)

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("update_select", %{"field" => field} = params, socket) do
    socket = create_execution_if_needed(socket)

    # For select elements, the value comes as params[field]
    value = Map.get(params, field, "")
    Logger.info("update_select field: #{field} value: #{value}")

    field_atom = String.to_existing_atom(field)

    execution = Journey.load(socket.assigns.execution_id)

    updated_execution =
      if value == "" do
        # TODO: update this after publishing the change in journey.
        # Journey.unset_value(execution, field_atom)
        Journey.set_value(execution, field_atom, value)
      else
        Journey.set_value(execution, field_atom, value)
      end

    socket = refresh_execution_state(socket, updated_execution)

    {:noreply, socket}
  end

  # Shared helper for applying toggle values
  defp apply_toggle_value(socket, field_name, bool_value) do
    Logger.info("toggle value: #{bool_value}, field: #{field_name}")
    execution = Journey.load(socket.assigns.execution_id)
    updated_execution = Journey.set_value(execution, field_name, bool_value)
    refresh_execution_state(socket, updated_execution)
  end

  @impl true
  def handle_info({:refresh, step_name, _value}, socket) do
    Logger.info("Received refresh notification for step: #{step_name}")

    # Reload the execution to get the latest values
    execution = Journey.load(socket.assigns.execution_id)

    socket = refresh_execution_state(socket, execution)

    {:noreply, socket}
  end

  # Helper function to create execution if it doesn't exist
  defp create_execution_if_needed(socket) do
    if is_nil(socket.assigns.execution_id) do
      # Create new execution
      graph = Demo.HoroscopeGraph.graph()

      new_execution =
        Journey.start_execution(graph)
        |> Journey.set_value(:email_address, "me@example.com")

      # Subscribe to PubSub for updates
      :ok = Phoenix.PubSub.subscribe(Demo.PubSub, "execution:#{new_execution.id}")

      Logger.info("create_execution_if_needed: created a new execution #{new_execution.id}")

      socket
      |> assign(:execution_id, new_execution.id)
      |> refresh_execution_state(new_execution)
      |> push_patch(to: "/s/#{new_execution.id}")
    else
      # Execution already exists, do nothing
      socket
    end
  end

  defp set_system_stats_if_needed(socket) do
    # Get flow analytics if not already loaded
    graph = Demo.HoroscopeGraph.graph()

    flow_analytics =
      socket.assigns[:flow_analytics] ||
        Journey.Insights.FlowAnalytics.flow_analytics(graph.name, graph.version)

    # Get graph mermaid if not already loaded
    graph_mermaid =
      socket.assigns[:graph_mermaid] ||
        Journey.Tools.generate_mermaid_graph(graph)

    socket
    |> assign(:flow_analytics, flow_analytics)
    |> assign(:graph_mermaid, graph_mermaid)
  end

  # Centralized function to refresh execution state in socket
  # Always refreshes all execution data for simplicity
  defp refresh_execution_state(socket, execution) do
    execution_history = Journey.Executions.history(execution.id) |> format_history()

    socket
    |> assign(:values, Journey.values(execution))
    |> assign(:all_values, Journey.values_all(execution))
    |> assign(:execution_summary, Journey.Tools.summarize(execution.id))
    |> assign(:computation_states, get_computation_states(execution.id))
    |> assign(:execution_history, execution_history)
  end

  # Helper function to get computation states for all computed nodes
  defp get_computation_states(execution_id) do
    %{
      name_validation: Journey.Tools.what_am_i_waiting_for(execution_id, :name_validation),
      zodiac_sign: Journey.Tools.what_am_i_waiting_for(execution_id, :zodiac_sign),
      horoscope: Journey.Tools.what_am_i_waiting_for(execution_id, :horoscope),
      anonymize_name: Journey.Tools.what_am_i_waiting_for(execution_id, :anonymize_name),
      email_horoscope: Journey.Tools.what_am_i_waiting_for(execution_id, :email_horoscope),
      weekly_reminder_schedule:
        Journey.Tools.what_am_i_waiting_for(execution_id, :weekly_reminder_schedule),
      send_weekly_reminder:
        Journey.Tools.what_am_i_waiting_for(execution_id, :send_weekly_reminder),
      schedule_archive: Journey.Tools.what_am_i_waiting_for(execution_id, :schedule_archive),
      auto_archive: Journey.Tools.what_am_i_waiting_for(execution_id, :auto_archive)
    }
  end

  # Helper function to format timestamp fields
  def format_timestamp(nil), do: "not set"

  def format_timestamp(unix_timestamp) when is_integer(unix_timestamp) do
    DateTime.from_unix!(unix_timestamp)
    |> Calendar.strftime("%B %d, %Y at %I:%M %p")
  end

  def format_timestamp(_), do: "not set"

  # Helper function to format Journey.Executions.history output into human-friendly strings
  def format_history(nil), do: []

  def format_history(history_entries) when is_list(history_entries) do
    history_entries
    |> Enum.reverse()
    |> Enum.reduce([], fn entry, acc ->
      case entry do
        %{
          computation_or_value: :computation,
          node_name: node_name,
          node_type: node_type,
          ex_revision_at_completion: revision
        } ->
          acc ++ [{revision, "computation `#{node_name}` (#{inspect(node_type)}) completed"}]

        %{
          computation_or_value: :value,
          node_name: node_name,
          value: value,
          ex_revision_at_completion: revision
        } ->
          formatted_value = format_history_value(value)
          acc ++ [{revision, "value `#{node_name}` was set (#{formatted_value})"}]

        _ ->
          acc
      end
    end)
  end

  defp format_history_value(value) when is_binary(value), do: inspect(value)
  defp format_history_value(value) when is_integer(value), do: value
  defp format_history_value(value) when is_atom(value), do: inspect(value)
  defp format_history_value(value), do: inspect(value)
end
