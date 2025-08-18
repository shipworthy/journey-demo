defmodule DemoWeb.Live.Home.Components.Gear do
  use Phoenix.Component

  @moduledoc false

  def render(assigns) do
    ~H"""
    <span class="text-2xl font-normal" aria-label="Developer settings" role="img">⚙️</span>
    """
  end
end
