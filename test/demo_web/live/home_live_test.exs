defmodule DemoWeb.Live.HomeLiveTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "sunny day flow" do
    test "completes full user interaction with incremental computations", %{conn: conn} do
      # Start on the home page
      {:ok, lv, html} = live(conn, "/")

      # Initial state - no computed values should be set
      assert html =~ "Horoscopes with Journey"
      refute html =~ "Pisces"

      # Stage 1: Fill in name - name validation happens internally
      fill_input(lv, "#input-name", "Sarah Johnson")
      # Name validation is internal, no visible output to check


      # Stage 2: Fill birth date and wait for zodiac sign
      select_option(lv, "#input-birth-month", "March")
      fill_input(lv, "#input-birth-day", "15")


      # Now wait for Pisces specifically
      assert wait_for_element_text(lv, "#output-zodiac-sign", "Pisces", 10000)

      # Stage 3: Select pet preference and wait for horoscope
      select_option(lv, "#input-pet-preference", "cats")

      assert wait_for_element_text(lv, "#output-horoscope", ~r/cosmic|wisdom|upstream|feline/i, 5000)

      # Stage 4: Enter email and wait for email status
      fill_input(lv, "#input-email-address", "sarah@example.com")
      assert wait_for_element_text(lv, "#output-email-horoscope", "sent", 5000)

      # Stage 5: Enable weekly subscription
      toggle_checkbox(lv, "#subscribe_weekly")
      html = render(lv)
      assert element_checked?(html, "#subscribe_weekly")

      # Stage 6: Test dev toggles
      # Enable execution history
      toggle_checkbox(lv, "#dev_show_execution_history")
      assert wait_for_element(lv, "#section-execution-history", 2000)

      # Enable computation states
      toggle_checkbox(lv, "#dev_show_computation_states")
      html = render(lv)
      assert html =~ "Upstream Dependencies"

      # Enable other computed values
      toggle_checkbox(lv, "#dev_show_other_computed_values")
      assert wait_for_element(lv, "#section-other-computed-values", 2000)

      # Verify that the other computed values section is now visible
      html = render(lv)
      assert html =~ "Other Computed Values"
    end

    test "validates name is required for zodiac computation", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Try to compute zodiac without name - should not work
      select_option(lv, "#input-birth-month", "March")
      fill_input(lv, "#input-birth-day", "15")

      # Wait a bit and verify zodiac_sign is still not set
      Process.sleep(200)
      html = render(lv)
      refute html =~ "Pisces"
      assert html =~ "not set"

      # Now add name and zodiac should compute
      fill_input(lv, "#input-name", "Test User")

      assert wait_for_element_text(lv, "#output-zodiac-sign", "Pisces", 10000)
    end

    test "handles navigation with execution_id", %{conn: conn} do
      # First visit creates an execution
      {:ok, lv1, _html} = live(conn, "/")
      fill_input(lv1, "#input-name", "First User")

      # Get the execution ID from the URL after it's created
      Process.sleep(500)
      # LiveView should navigate after creating execution - just verify it works
      # Give time for navigation
      Process.sleep(1000)

      # Extract execution_id from the URL - LiveView should have navigated
      # The name should be anonymized to "F****" (first char + asterisks)
      html = render(lv1)
      assert html =~ "F****"
    end
  end

  # Helper functions

  defp wait_for_element_text(lv, selector, expected_text, timeout) do
    interval = 1000
    max_attempts = div(timeout, interval)

    Enum.reduce_while(1..max_attempts, false, fn _attempt, _ ->
      # Ensure all pending messages (including PubSub) are processed
      # This is critical for LiveViews that receive async updates via handle_info
      html = render(lv)

      # Parse the HTML properly - it might be coming as a string that needs parsing
      parsed_html = Floki.parse_document!(html)
      
      found =
        case Floki.find(parsed_html, selector) do
          [] ->
            false

          elements ->
            text = Floki.text(elements) |> String.trim()

            case expected_text do
              %Regex{} = regex -> text =~ regex
              string -> text == string || text =~ string
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

  defp wait_for_element(lv, selector, timeout) do
    interval = 1000
    max_attempts = div(timeout, interval)

    Enum.reduce_while(1..max_attempts, false, fn _, _ ->
      html = render(lv)
      parsed_html = Floki.parse_document!(html)

      case Floki.find(parsed_html, selector) do
        [] ->
          Process.sleep(interval)
          {:cont, false}

        _ ->
          {:halt, true}
      end
    end)
  end

  defp fill_input(lv, selector, value) do
    element(lv, selector)
    |> render_blur(%{value: value})
  end

  defp select_option(lv, selector, value) do
    # Extract field name from selector (e.g., "#input-birth-month" -> "birth_month")  
    field_name = selector |> String.replace("#input-", "") |> String.replace("-", "_")

    # Target the specific form by ID with -id suffix
    form_id = "#form-#{field_name |> String.replace("_", "-")}-id"
    form = form(lv, form_id, %{field_name => value})

    render_change(form)
  end

  defp toggle_checkbox(lv, selector) do
    # Extract checkbox name from selector (e.g., "#subscribe_weekly" -> "subscribe-weekly")
    checkbox_name = String.replace(selector, "#", "") |> String.replace("_", "-")

    # Target the specific form by ID with -id suffix
    form_id = "#form-#{checkbox_name}-id"

    # Get the checkbox's current state
    html = render(lv)
    checked = element_checked?(html, selector)

    # Toggle the checkbox
    new_value = if checked, do: "off", else: "on"
    form = form(lv, form_id, %{"dev_toggle" => new_value})

    render_change(form)
  end

  defp element_checked?(html, selector) do
    parsed_html = Floki.parse_document!(html)
    case Floki.find(parsed_html, "#{selector}[checked]") do
      [] -> false
      _ -> true
    end
  end
end
