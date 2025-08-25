defmodule DemoWeb.Live.Home.Components.Dialogs.About do
  use Phoenix.Component

  import DemoWeb.Live.Classes
  @moduledoc false

  def render(assigns) do
    ~H"""
    <div
      id="about-dialog-id"
      class="fixed inset-0 z-50 flex overflow-y-auto p-4 bg-black/50 backdrop-blur-sm"
    >
      <div class="m-auto w-full max-w-md bg-white rounded-xl shadow-xl border border-gray-200 transform transition-all">
        <div class="p-6">
          <h3 class="text-xl font-bold text-gray-900 mb-4">
            What is this?
          </h3>

          <div class="space-y-2 text-gray-800 text-lg">
            <p class="leading-relaxed">
              This is a silly horoscope web application.
            </p>
            <p class="leading-relaxed">
              This is also a technical demo for Journey, an Elixir package for building reliable applications, quickly and easily.
            </p>
            <p class="leading-relaxed">
              Some useful references:
            </p>
            <p class="mt-1">
              * Journey: <a
                href="https://hex.pm/packages/journey"
                class={href_inline()}
                target="_blank"
              >https://hex.pm/packages/journey</a>.
            </p>
            <p class="">
              * Journey's source code: <a
                href="https://github.com/markmark206/journey"
                class={href_inline()}
                target="_blank"
              >https://github.com/markmark206/journey</a>.
            </p>
            <p class="">
              * This web app's source code: <a
                href="https://github.com/shipworthy/journey-demo"
                class={href_inline()}
                target="_blank"
              >https://github.com/shipworthy/journey-demo</a>.
            </p>
          </div>

          <div class="mt-6 flex justify-center">
            <button
              id="hide-about-dialog-button-id"
              phx-click="on-hide-about-dialog-click"
              type="button"
              class="w-full py-2.5 px-5 bg-blue-800 hover:bg-gold-cta hover:text-blue-800 text-gold-cta font-medium rounded-lg transition-colors duration-200 border-2 border-gold-cta focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gold-cta"
            >
              Ok
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
