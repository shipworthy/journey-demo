defmodule DemoWeb.Live.Home.Index do
  use DemoWeb, :live_view

  @moduledoc false

  require Logger

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

        if loaded_execution == nil do
          new_execution =
            Demo.HoroscopeGraph.graph()
            |> Journey.start_execution()

          socket
          |> push_navigate(to: "/s/#{new_execution.id}")
        else
          socket
          |> assign(:execution_id, loaded_execution.id)
          |> assign(:values, Journey.values(loaded_execution))
        end
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def mount(_params, _session, socket) do
    Logger.info("home.mount")
    socket = socket |> assign(:connected?, connected?(socket))

    socket =
      if connected?(socket) do
        socket
        |> assign(:connected?, connected?(socket))
        |> assign(:execution_id, nil)
        |> assign(:values, %{})
      else
        socket
      end

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

  # @impl true
  # def handle_event("on-next-step-button-click", _params, socket) do
  #   socket =
  #     socket
  #     |> assign(:current_step_number, socket.assigns.current_step_number + 1)

  #   {:noreply, socket}
  # end

  # @impl true
  # def handle_event("on-prev-step-button-click", _params, socket) do
  #   socket =
  #     socket
  #     |> assign(:current_step_number, socket.assigns.current_step_number - 1)

  #   {:noreply, socket}
  # end
end
