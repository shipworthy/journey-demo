defmodule DemoWeb.Live.Home.Components.DevShowAllValues do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div class="flex items-center bg-blue-50 p-4 rounded-lg mt-6">
      <form
        id="form-dev-show-all-values-id"
        phx-value-toggle_field_name="dev_show_all_values"
        phx-change="dev_toggle"
      >
        <input
          type="checkbox"
          name="dev_toggle"
          id="dev_show_all_values-id"
          checked={Map.get(@values, :dev_show_all_values, false) == true}
          disabled={!@connected?}
          class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded disabled:bg-gray-100"
        />
        <label for="dev_show_all_values-id" class="ml-2 inline-block text-sm text-gray-700">
          Devs: See All Values (raw data)
        </label>
      </form>
    </div>

    <div :if={Map.get(@values, :dev_show_all_values, false)} id="section-all-values-id" class="mt-4">
      <pre class={Classes.debug_pre()}><%= "iex> \"#{@execution_id}\" |> Journey.load() |> Journey.values_all()\n#{inspect(@all_values, pretty: true)}" %></pre>
    </div>
    """
  end
end
