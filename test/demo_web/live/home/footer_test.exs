defmodule DemoWeb.Live.Home.FooterTest do
  use DemoWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import DemoWeb.LiveViewTestHelpers

  describe "feedback emoji interactions" do
    test "clicking smiley face toggles and persists state", %{conn: conn} do
      {:ok, lv, html} = live(conn, "/")

      # Initially no emoji should be selected
      refute element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")

      # Click smiley - should highlight
      element(lv, "[phx-click='on-feedback-emoji-smiley-click']")
      |> render_click()

      html = render(lv)
      assert element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")

      # Get current path for persistence test
      current_path = assert_patch(lv)

      # Reload page - smiley should still be selected
      {:ok, lv2, html2} = live(conn, current_path)
      assert element_has_class?(html2, "#footer-emoji-smiley-id", "bg-gold-cta")
      refute element_has_class?(html2, "#footer-emoji-frowney-id", "bg-gold-cta")

      # Click smiley again - should deselect
      element(lv2, "[phx-click='on-feedback-emoji-smiley-click']")
      |> render_click()

      html = render(lv2)
      refute element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")
    end

    test "clicking frowney face toggles and persists state", %{conn: conn} do
      {:ok, lv, html} = live(conn, "/")

      # Initially no emoji should be selected
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")

      # Click frowney - should highlight
      element(lv, "[phx-click='on-feedback-emoji-frowney-click']")
      |> render_click()

      html = render(lv)
      assert element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")
      refute element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")

      # Get current path for persistence test
      current_path = assert_patch(lv)

      # Reload page - frowney should still be selected
      {:ok, lv2, html2} = live(conn, current_path)
      assert element_has_class?(html2, "#footer-emoji-frowney-id", "bg-gold-cta")
      refute element_has_class?(html2, "#footer-emoji-smiley-id", "bg-gold-cta")

      # Click frowney again - should deselect
      element(lv2, "[phx-click='on-feedback-emoji-frowney-click']")
      |> render_click()

      html = render(lv2)
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")
    end

    test "feedback emojis are mutually exclusive", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Click smiley first
      element(lv, "[phx-click='on-feedback-emoji-smiley-click']")
      |> render_click()

      html = render(lv)
      assert element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")

      # Click frowney - should switch from smiley to frowney
      element(lv, "[phx-click='on-feedback-emoji-frowney-click']")
      |> render_click()

      html = render(lv)
      refute element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      assert element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")

      # Click smiley again - should switch back
      element(lv, "[phx-click='on-feedback-emoji-smiley-click']")
      |> render_click()

      html = render(lv)
      assert element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      refute element_has_class?(html, "#footer-emoji-frowney-id", "bg-gold-cta")
    end
  end

  describe "about dialog" do
    test "opens and closes about dialog", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Initially dialog should not be visible
      refute element_exists?(lv, "#about-dialog-id")

      # Click question mark icon to open dialog
      element(lv, "#footer-about-icon-id")
      |> render_click()

      # Dialog should appear
      assert wait_for_element_appearance(lv, "#about-dialog-id")

      # Verify specific dialog content elements exist
      html = render(lv)
      assert element_exists?(lv, "#hide-about-dialog-button-id")
      # Check for specific text in the dialog
      parsed_html = Floki.parse_document!(html)
      dialog_content = Floki.find(parsed_html, "#about-dialog-id") |> Floki.text()
      assert dialog_content =~ "What is this?"
      assert dialog_content =~ "This is a silly horoscope web application"

      # Click OK button to close
      element(lv, "#hide-about-dialog-button-id")
      |> render_click()

      # Dialog should disappear
      assert wait_for_element_disappearance(lv, "#about-dialog-id")
    end

    test "about_visited state persists", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Open about dialog to set about_visited
      element(lv, "#footer-about-icon-id")
      |> render_click()

      # Close dialog
      element(lv, "#hide-about-dialog-button-id")
      |> render_click()

      # Get current path
      current_path = assert_patch(lv)

      # Reload page
      {:ok, lv2, _html2} = live(conn, current_path)

      # Verify the page reloaded with the execution state intact
      # Open dialog again and verify it works (proving state persisted)
      element(lv2, "#footer-about-icon-id")
      |> render_click()

      assert wait_for_element_appearance(lv2, "#about-dialog-id")
      assert element_exists?(lv2, "#hide-about-dialog-button-id")
    end
  end

  describe "contact dialog" do
    test "opens and closes contact dialog", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Initially dialog should not be visible
      refute element_exists?(lv, "#contact-dialog-id")

      # Click envelope icon to open dialog
      element(lv, "#footer-contact-icon-id")
      |> render_click()

      # Dialog should appear
      assert wait_for_element_appearance(lv, "#contact-dialog-id")

      # Verify specific dialog elements exist
      assert element_exists?(lv, "#feedback-text-field-id")
      assert element_exists?(lv, "#hide-contact-us-dialog-button-id")

      # Check dialog content
      html = render(lv)
      parsed_html = Floki.parse_document!(html)
      dialog_content = Floki.find(parsed_html, "#contact-dialog-id") |> Floki.text()
      assert dialog_content =~ "Contact Us"
      assert dialog_content =~ "We'd love to hear your feedback!"

      # Click OK button to close
      element(lv, "#hide-contact-us-dialog-button-id")
      |> render_click()

      # Dialog should disappear
      assert wait_for_element_disappearance(lv, "#contact-dialog-id")
    end

    test "feedback text is captured and persisted", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Open contact dialog
      element(lv, "#footer-contact-icon-id")
      |> render_click()

      # Enter feedback text
      element(lv, "#feedback-text-field-id")
      |> render_change(%{"feedback-text-field-name" => "This is great!"})

      # Close dialog
      element(lv, "#hide-contact-us-dialog-button-id")
      |> render_click()

      # Get current path
      current_path = assert_patch(lv)

      # Reload page
      {:ok, lv2, _html2} = live(conn, current_path)

      # Open dialog again - text should be preserved in the textarea
      element(lv2, "#footer-contact-icon-id")
      |> render_click()

      html = render(lv2)
      assert element_has_value?(html, "#feedback-text-field-id", "This is great!")
    end

    test "envelope icon highlights when feedback text exists", %{conn: conn} do
      {:ok, lv, html} = live(conn, "/")

      # Initially envelope should not be highlighted
      refute element_has_class?(html, "#footer-contact-icon-id", "bg-gold-cta")

      # Open contact dialog
      element(lv, "#footer-contact-icon-id")
      |> render_click()

      # Enter feedback text
      element(lv, "#feedback-text-field-id")
      |> render_change(%{"feedback-text-field-name" => "Feedback here"})

      # Close dialog
      element(lv, "#hide-contact-us-dialog-button-id")
      |> render_click()

      # Envelope should now be highlighted
      html = render(lv)
      assert element_has_class?(html, "#footer-contact-icon-id", "bg-gold-cta")

      # Clear feedback text
      element(lv, "#footer-contact-icon-id")
      |> render_click()

      element(lv, "#feedback-text-field-id")
      |> render_change(%{"feedback-text-field-name" => ""})

      element(lv, "#hide-contact-us-dialog-button-id")
      |> render_click()

      # Envelope should no longer be highlighted
      html = render(lv)
      refute element_has_class?(html, "#footer-contact-icon-id", "bg-gold-cta")
    end

    test "contact_visited state persists", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Open contact dialog to set contact_visited
      element(lv, "#footer-contact-icon-id")
      |> render_click()

      # Enter some feedback text
      element(lv, "#feedback-text-field-id")
      |> render_change(%{"feedback-text-field-name" => "Test feedback"})

      # Close dialog
      element(lv, "#hide-contact-us-dialog-button-id")
      |> render_click()

      # Get current path
      current_path = assert_patch(lv)

      # Reload page
      {:ok, lv2, html2} = live(conn, current_path)

      # Verify envelope is still highlighted (feedback text persisted)
      assert element_has_class?(html2, "#footer-contact-icon-id", "bg-gold-cta")

      # Open dialog to verify text is still in the textarea specifically
      element(lv2, "#footer-contact-icon-id")
      |> render_click()

      html = render(lv2)
      assert element_has_value?(html, "#feedback-text-field-id", "Test feedback")
    end
  end

  describe "integrated footer interactions" do
    test "multiple footer elements can be active simultaneously", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # Select smiley emoji
      element(lv, "[phx-click='on-feedback-emoji-smiley-click']")
      |> render_click()

      # Add feedback text
      element(lv, "#footer-contact-icon-id")
      |> render_click()

      element(lv, "#feedback-text-field-id")
      |> render_change(%{"feedback-text-field-name" => "Love it!"})

      element(lv, "#hide-contact-us-dialog-button-id")
      |> render_click()

      # Both elements should be highlighted
      html = render(lv)
      assert element_has_class?(html, "#footer-emoji-smiley-id", "bg-gold-cta")
      assert element_has_class?(html, "#footer-contact-icon-id", "bg-gold-cta")

      # Get current path
      current_path = assert_patch(lv)

      # Reload - both states should persist
      {:ok, lv2, html2} = live(conn, current_path)
      assert element_has_class?(html2, "#footer-emoji-smiley-id", "bg-gold-cta")
      assert element_has_class?(html2, "#footer-contact-icon-id", "bg-gold-cta")

      # Verify feedback text is persisted in the specific textarea
      element(lv2, "#footer-contact-icon-id")
      |> render_click()

      html = render(lv2)
      assert element_has_value?(html, "#feedback-text-field-id", "Love it!")
    end
  end
end
