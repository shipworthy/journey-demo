defmodule DemoWeb.Live.Home.Index do
  use DemoWeb, :live_view

  @moduledoc false

  require Logger

  alias DemoWeb.Live.Classes

  # alias DemoWeb.Live.Home.Components.Footer
  # alias DemoWeb.Live.Home.Components.ButtonsPrevNext
  # alias DemoWeb.Live.Home.Components.ButtonPrev
  # alias DemoWeb.Live.Home.Components.ButtonNext

  @impl true
  def mount(%{"execution_id" => execution_id} = _params, _session, socket) do
    Logger.info("home.mount execution_id: #{execution_id}")

    socket = socket |> assign(:connected?, connected?(socket))

    socket =
      if connected?(socket) do
        loaded_execution = Journey.load(execution_id)
        graph = Demo.HoroscopeGraph.graph()

        if loaded_execution == nil do
          new_execution = Journey.start_execution(graph)

          socket
          |> push_navigate(to: "/s/#{new_execution.id}")
        else
          # Subscribe to PubSub for this execution
          :ok = Phoenix.PubSub.subscribe(Demo.PubSub, "execution:#{execution_id}")

          summary = Journey.Tools.summarize(execution_id)

          flow_analytics =
            Journey.Insights.FlowAnalytics.flow_analytics(graph.name, graph.version)

          graph_mermaid = Journey.Tools.generate_mermaid_graph(graph)

          socket
          |> assign(:execution_id, execution_id)
          |> assign(:values, Journey.values(loaded_execution))
          |> assign(:all_values, Journey.values_all(loaded_execution))
          |> assign(:execution_summary, summary)
          |> assign(:flow_analytics, flow_analytics)
          |> assign(:graph_mermaid, graph_mermaid)
        end
      else
        socket
        |> assign(:execution_id, execution_id)
        |> assign(:values, %{})
        |> assign(:all_values, %{})
        |> assign(:execution_summary, nil)
        |> assign(:flow_analytics, nil)
        |> assign(:graph_mermaid, nil)
      end

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    Logger.info("home.mount")

    graph = Demo.HoroscopeGraph.graph()

    flow_analytics =
      Journey.Insights.FlowAnalytics.flow_analytics(graph.name, graph.version)

    graph_mermaid = Journey.Tools.generate_mermaid_graph(graph)

    socket =
      socket
      |> assign(:connected?, connected?(socket))
      |> assign(:execution_id, nil)
      |> assign(:values, %{})
      |> assign(:all_values, %{})
      |> assign(:execution_summary, nil)
      |> assign(:flow_analytics, flow_analytics)
      |> assign(:graph_mermaid, graph_mermaid)

    {:ok, socket}
  end

  # defp set_execution_to_socket(execution, socket) do
  #   socket =
  #     execution
  #     |> Journey.values_all()
  #     |> IO.inspect(label: "values_all")
  #     |> Enum.reduce(socket, fn
  #       {key, :not_set}, soc ->
  #         soc |> assign(key, nil)

  #       {key, {:set, value}}, soc ->
  #         soc |> assign(key, value)
  #     end)
  #     |> assign(:execution_id, execution.id)

  #   IO.inspect(socket.assigns, label: "socket.assigns")
  #   socket
  # end

  @impl true
  def handle_event("update_value", %{"field" => field, "value" => value}, socket) do
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

    # Load execution, set the value, and reload to get updated values
    execution = Journey.load(socket.assigns.execution_id)
    updated_execution = Journey.set_value(execution, field_atom, parsed_value)

    summary = Journey.Tools.summarize(updated_execution.id)

    socket =
      socket
      # todo: no need to do this here.
      |> assign(:values, Journey.values(updated_execution))
      |> assign(:all_values, Journey.values_all(updated_execution))
      |> assign(:execution_summary, summary)

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_select", %{"field" => field} = params, socket) do
    # For select elements, the value comes as params[field]
    value = Map.get(params, field, "")
    Logger.info("update_select field: #{field} value: #{value}")

    field_atom = String.to_existing_atom(field)

    execution = Journey.load(socket.assigns.execution_id)
    updated_execution = Journey.set_value(execution, field_atom, value)

    summary = Journey.Tools.summarize(updated_execution.id)

    socket =
      socket
      |> assign(:values, Journey.values(updated_execution))
      |> assign(:all_values, Journey.values_all(updated_execution))
      |> assign(:execution_summary, summary)

    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle_subscribe", params, socket) do
    # Form checkbox sends "on" when checked, missing when unchecked
    bool_value = Map.get(params, "subscribe_weekly", "off") == "on"

    Logger.info("toggle_subscribe value: #{bool_value}")

    execution = Journey.load(socket.assigns.execution_id)
    updated_execution = Journey.set_value(execution, :subscribe_weekly, bool_value)

    summary = Journey.Tools.summarize(updated_execution.id)

    socket =
      socket
      |> assign(:values, Journey.values(updated_execution))
      |> assign(:all_values, Journey.values_all(updated_execution))
      |> assign(:execution_summary, summary)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:refresh, step_name, _value}, socket) do
    Logger.info("Received refresh notification for step: #{step_name}")

    # Reload the execution to get the latest values
    execution = Journey.load(socket.assigns.execution_id)
    summary = Journey.Tools.summarize(socket.assigns.execution_id)

    socket =
      socket
      |> assign(:values, Journey.values(execution))
      |> assign(:all_values, Journey.values_all(execution))
      |> assign(:execution_summary, summary)

    {:noreply, socket}
  end
end
