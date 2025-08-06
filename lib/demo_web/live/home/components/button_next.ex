defmodule DemoWeb.Live.Home.Components.ButtonNext do
  use Phoenix.Component

  @moduledoc false

  import DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <span class="">
      <button
        id="next-step-button-button-id"
        phx-click="on-next-step-button-click"
        type="button"
        phx-value-button_in_step_number={@current_step_number}
        disabled={@button_state == :disabled}
        class={button_style3(@button_state) <> " w-full"}
      >
        <div class="flex flex-row align-middle justify-center ">
          <span class="mx-2 justify-center ">
            <%!-- <span class={"mx-2 justify-center " <> if @button_state == :call_to_action, do: " animate-pulse ", else: ""}> --%>
            {@button_text}
          </span>
        </div>
      </button>
    </span>
    """
  end
end
