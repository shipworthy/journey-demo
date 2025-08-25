defmodule DemoWeb.Live.Home.Components.Gear do
  @moduledoc false

  use Phoenix.Component
  import DemoWeb.CoreComponents, only: [icon: 1]

  def render(assigns) do
    assigns = assign_new(assigns, :checked, fn -> false end)

    ~H"""
    <.icon
      name={if(@checked, do: "hero-wrench-screwdriver-solid", else: "hero-wrench-screwdriver")}
      class={"w-8 h-8 p-1 " <> if(@checked, do: " text-blue-500 ", else: " text-gray-500")}
    />
    """
  end
end
