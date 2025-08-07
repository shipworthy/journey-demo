defmodule DemoWeb.Live.Home.Components.ButtonsPrevNext do
  use Phoenix.Component
  alias DemoWeb.Live.Home.Components.ButtonPrev
  alias DemoWeb.Live.Home.Components.ButtonNext

  @moduledoc false

  def render(assigns) do
    ~H"""
    <span class="mt-2 flex flex-row justify-between">
      <%= if @prev_text == nil do %>
        <span></span>
      <% else %>
        <ButtonPrev.render current_step_number={@this_step_number} button_text={@prev_text} />
      <% end %>

      <%= if @next_text == nil do %>
        <span></span>
      <% else %>
        <span class={if @prev_text == nil, do: " w-full ", else: " w-5/6 "}>
          <ButtonNext.render
            button_state={:call_to_action}
            current_step_number={@this_step_number}
            button_text={@next_text}
          />
        </span>
      <% end %>
    </span>
    """
  end
end
