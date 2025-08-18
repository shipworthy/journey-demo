defmodule DemoWeb.Live.Home.Components.Gear do
  @moduledoc false

  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <span class="text-2xl font-normal" aria-label="Developer settings" role="img">⚙️</span>
    """
  end
end
