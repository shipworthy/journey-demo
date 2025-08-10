defmodule DemoWeb.Live.HomeLiveTest do
  use DemoWeb.ConnCase
  import Phoenix.LiveViewTest
  import DemoWeb.LiveViewTestHelpers

  describe "sunny day flow" do
    test "completes full user interaction with incremental computations", %{conn: conn} do
      {:ok, lv, html} = live(conn, "/")

      assert html =~ "Horoscopes with Journey"
      refute html =~ "Pisces"

      fill_input(lv, "#input-name-id", "Sarah Johnson")

      select_option(lv, "#form-birth-month-id", "birth_month", "March")
      fill_input(lv, "#input-birth-day-id", "15")

      assert wait_for_element_text(lv, "#output-zodiac-sign-id", "Pisces")

      select_option(lv, "#form-pet-preference-id", "pet_preference", "cats")

      assert wait_for_element_text(
               lv,
               "#output-horoscope-id",
               ~r/cosmic|wisdom|upstream|feline/i
             )

      fill_input(lv, "#input-email-address-id", "sarah@example.com")
      assert wait_for_element_text(lv, "#output-email-horoscope-id", "sent")

      toggle_checkbox(lv, "#form-subscribe-weekly-id", "#subscribe_weekly-id")
      html = render(lv)
      assert element_checked?(html, "#subscribe_weekly-id")

      # Test dev toggles
      toggle_checkbox(lv, "#form-dev-show-execution-history-id", "#dev_show_execution_history-id")
      assert wait_for_element_appearance(lv, "#section-execution-history-id")

      toggle_checkbox(
        lv,
        "#form-dev-show-computation-states-id",
        "#dev_show_computation_states-id"
      )

      html = render(lv)
      assert html =~ "Upstream Dependencies"

      toggle_checkbox(
        lv,
        "#form-dev-show-other-computed-values-id",
        "#dev_show_other_computed_values-id"
      )

      assert wait_for_element_appearance(lv, "#section-other-computed-values-id")

      html = render(lv)
      assert html =~ "Other Computed Values"
    end

    test "validates name is required for zodiac computation", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Try to compute zodiac without name - should not work
      select_option(lv, "#form-birth-month-id", "birth_month", "March")
      fill_input(lv, "#input-birth-day-id", "15")

      # Wait a bit and verify zodiac_sign is still not set
      Process.sleep(200)
      html = render(lv)
      refute html =~ "Pisces"
      assert html =~ "not set"

      # Now add name and zodiac should compute
      fill_input(lv, "#input-name-id", "Test User")

      assert wait_for_element_text(lv, "#output-zodiac-sign-id", "Pisces")
    end

    test "handles navigation with execution_id", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")
      fill_input(lv, "#input-name-id", "First User")
      assert wait_for_input_value(lv, "#input-name-id", "F*********")
    end
  end
end
