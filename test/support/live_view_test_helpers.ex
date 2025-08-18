defmodule DemoWeb.LiveViewTestHelpers do
  @moduledoc """
  Shared helper functions for LiveView tests.
  """

  import Phoenix.LiveViewTest

  def toggle_checkbox(lv, form_id, checkbox_id) do
    # Get the checkbox's current state
    html = render(lv)
    checked = element_checked?(html, checkbox_id)

    # Toggle the checkbox value
    new_value = if checked, do: "off", else: "on"

    # Submit the form with the checkbox value
    element(lv, form_id)
    |> render_change(%{"dev_toggle" => new_value})
  end

  def click_chevron_toggle(lv, toggle_field_name) do
    # Click the chevron toggle div
    element(lv, "[phx-value-toggle_field_name='#{toggle_field_name}']")
    |> render_click(%{})
  end

  def element_checked?(html, selector) do
    parsed_html = Floki.parse_document!(html)

    case Floki.find(parsed_html, "#{selector}[checked]") do
      [] -> false
      _ -> true
    end
  end

  def element_exists?(lv, selector) do
    html = render(lv)
    parsed_html = Floki.parse_document!(html)

    case Floki.find(parsed_html, selector) do
      [] -> false
      _ -> true
    end
  end

  def fill_input(lv, selector, value) do
    element(lv, selector)
    |> render_blur(%{value: value})
  end

  def select_option(lv, form_id, field_name, value) do
    form(lv, form_id, %{field_name => value})
    |> render_change()
  end

  def wait_for_element_appearance(lv, selector) do
    interval = 500
    timeout = 10_000
    max_attempts = div(timeout, interval)

    Enum.reduce_while(1..max_attempts, false, fn _, _ ->
      if element_exists?(lv, selector) do
        {:halt, true}
      else
        Process.sleep(interval)
        {:cont, false}
      end
    end)
  end

  def wait_for_element_disappearance(lv, selector) do
    interval = 500
    timeout = 10_000
    max_attempts = div(timeout, interval)

    Enum.reduce_while(1..max_attempts, false, fn _, _ ->
      if element_exists?(lv, selector) do
        Process.sleep(interval)
        {:cont, false}
      else
        {:halt, true}
      end
    end)
  end

  def wait_for_element_text(lv, selector, expected_text) do
    interval = 1000
    timeout = 10_000
    max_attempts = div(timeout, interval)

    Enum.reduce_while(1..max_attempts, false, fn _attempt, _ ->
      html = render(lv)
      parsed_html = Floki.parse_document!(html)

      found =
        case Floki.find(parsed_html, selector) do
          [] ->
            false

          elements ->
            el_value = Floki.text(elements) |> String.trim()

            # credo:disable-for-next-line Credo.Check.Refactor.Nesting
            case expected_text do
              %Regex{} = regex -> el_value =~ regex
              string -> el_value == string || el_value =~ string
            end
        end

      if found do
        {:halt, true}
      else
        Process.sleep(interval)
        {:cont, false}
      end
    end)
  end

  def wait_for_input_value(lv, selector, expected_value) do
    interval = 1000
    timeout = 10_000
    max_attempts = div(timeout, interval)

    Enum.reduce_while(1..max_attempts, false, fn _attempt, _ ->
      html = render(lv)
      parsed_html = Floki.parse_document!(html)

      found =
        case Floki.find(parsed_html, selector) do
          [] ->
            false

          elements ->
            el_value =
              Floki.attribute(elements, "value") |> List.first() |> to_string() |> String.trim()

            # credo:disable-for-next-line Credo.Check.Refactor.Nesting
            case expected_value do
              %Regex{} = regex -> el_value =~ regex
              string -> el_value == string
            end
        end

      if found do
        {:halt, true}
      else
        Process.sleep(interval)
        {:cont, false}
      end
    end)
  end
end
