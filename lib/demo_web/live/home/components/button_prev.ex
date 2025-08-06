defmodule DemoWeb.Live.Home.Components.ButtonPrev do
  use Phoenix.Component

  @moduledoc false

  def render(assigns) do
    ~H"""
    <span class="w-1/6">
      <% button_class =
        " cursor-pointer rounded-lg py-2 my-2 justify-center w-full text-xl  text-blue-old-glory border-2 border-gray-200 hover:underline hover:bg-gold-cta " %>

      <button
        id="button-prev-step-button-id"
        phx-click="on-prev-step-button-click"
        type="button"
        phx-value-button_in_step_number={@current_step_number}
        disabled={false}
        class={button_class}
      >
        <div class="flex flex-row align-middle justify-center ">
          <span class="mx-2 justify-center">{@button_text}</span>
        </div>
      </button>
    </span>
    """
  end
end
