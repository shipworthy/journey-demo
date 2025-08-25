defmodule DemoWeb.Live.Home.Components.Dialogs.ContactUs do
  @moduledoc false

  use Phoenix.Component
  import DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div
      id="contact-dialog-id"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm"
    >
      <div class="w-full max-w-md mx-auto bg-white rounded-xl shadow-xl border border-gray-200 transform transition-all">
        <div class="p-6">
          <h3 class="text-xl font-bold text-gray-900 mb-4">
            Contact Us
          </h3>

          <div class="space-y-4 text-gray-800 text-lg">
            <p class="leading-relaxed">
              We'd love to hear your feedback!
            </p>
            <div class="w-full">
              <form>
                <textarea
                  type="text"
                  disabled={false}
                  id="feedback-text-field-id"
                  autofocus={true}
                  name="feedback-text-field-name"
                  rows="4"
                  maxlength="2000"
                  placeholder="Your message here..."
                  class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-800 focus:border-blue-800 text-blue-800 bg-white shadow-sm transition-all duration-200 text-xl"
                  phx-change="on-feedback-text-change"
                ><%= @feedback_text %></textarea>
              </form>
            </div>
            <p class="text-md text-gray-800 italic">
              Please avoid providing personal information here. To contact us securely or to request a response, please go to
              <a href="https://gojourney.dev/faq" class={href_inline()} target="_blank">
                https://gojourney.dev/faq
              </a>
              .
            </p>
          </div>

          <div class="mt-6 flex justify-center">
            <button
              id="hide-contact-us-dialog-button-id"
              phx-click="on-hide-contact-us-dialog-click"
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
