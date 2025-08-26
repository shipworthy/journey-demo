defmodule DemoWeb.Live.Home.DevTogglesTest do
  use DemoWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import DemoWeb.LiveViewTestHelpers

  describe "dev toggles" do
    test "dev_show_execution_history toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-execution-history-id")

      # Toggle ON - should become visible
      toggle_checkbox(lv, "#form-dev-show-execution-history-id", "#dev_show_execution_history-id")
      assert wait_for_element_appearance(lv, "#section-execution-history-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before, so execution history should be visible
      assert element_exists?(lv2, "#section-execution-history-id")

      # Toggle OFF - should disappear
      toggle_checkbox(
        lv2,
        "#form-dev-show-execution-history-id",
        "#dev_show_execution_history-id"
      )

      assert wait_for_element_disappearance(lv2, "#section-execution-history-id")
    end

    test "dev_show_computation_states toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Add some data to trigger computation
      fill_input(lv, "#input-name-id", "Test User")
      select_option(lv, "#form-birth-month-id", "birth_month", "March")
      fill_input(lv, "#input-birth-day-id", "15")

      # Wait for zodiac computation
      Process.sleep(1000)

      # Initially computation states should not be visible
      refute element_exists?(lv, "#computation-state-zodiac_sign-id")

      # Toggle ON - should show computation states
      toggle_checkbox(
        lv,
        "#form-dev-show-computation-states-id",
        "#dev_show_computation_states-id"
      )

      assert wait_for_element_appearance(lv, "#computation-state-zodiac_sign-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#computation-state-zodiac_sign-id")

      # Toggle OFF - should hide computation states
      toggle_checkbox(
        lv2,
        "#form-dev-show-computation-states-id",
        "#dev_show_computation_states-id"
      )

      assert wait_for_element_disappearance(lv2, "#computation-state-zodiac_sign-id")
    end

    test "dev_show_other_computed_values toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-other-computed-values-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_other_computed_values")
      assert wait_for_element_appearance(lv, "#section-other-computed-values-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-other-computed-values-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_other_computed_values")
      assert wait_for_element_disappearance(lv2, "#section-other-computed-values-id")
    end

    test "dev_show_all_values toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-all-values-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_all_values")
      assert wait_for_element_appearance(lv, "#section-all-values-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-all-values-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_all_values")
      assert wait_for_element_disappearance(lv2, "#section-all-values-id")
    end

    test "dev_show_recent_executions toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-recent-executions-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_recent_executions")
      assert wait_for_element_appearance(lv, "#section-recent-executions-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-recent-executions-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_recent_executions")
      assert wait_for_element_disappearance(lv2, "#section-recent-executions-id")
    end

    test "dev_show_journey_execution_summary toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-execution-summary-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_journey_execution_summary")
      assert wait_for_element_appearance(lv, "#section-execution-summary-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-execution-summary-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_journey_execution_summary")
      assert wait_for_element_disappearance(lv2, "#section-execution-summary-id")
    end

    test "dev_show_flow_analytics_table toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-flow-analytics-table-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_flow_analytics_table")
      assert wait_for_element_appearance(lv, "#section-flow-analytics-table-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-flow-analytics-table-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_flow_analytics_table")
      assert wait_for_element_disappearance(lv2, "#section-flow-analytics-table-id")
    end

    test "dev_show_flow_analytics_json toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-flow-analytics-json-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_flow_analytics_json")
      assert wait_for_element_appearance(lv, "#section-flow-analytics-json-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-flow-analytics-json-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_flow_analytics_json")
      assert wait_for_element_disappearance(lv2, "#section-flow-analytics-json-id")
    end

    test "dev_show_workflow_graph toggle visibility and persistence", %{conn: conn} do
      {:ok, lv, _html} = live(conn, "/")

      # First enable dev_show_more to make dev toggles visible
      element(lv, "[phx-click='on-dev-show-more-click']")
      |> render_click()

      # Initially should not be visible
      refute element_exists?(lv, "#section-workflow-graph-id")

      # Toggle ON - should become visible
      click_chevron_toggle(lv, "dev_show_workflow_graph")
      assert wait_for_element_appearance(lv, "#section-workflow-graph-id")

      # Use assert_patch to capture the URL change and get the new path
      current_path = assert_patch(lv)

      # Reload the page at that URL
      {:ok, lv2, _html} = live(conn, current_path)

      # Verify toggle state persisted across reload
      # dev_show_more should be persisted from before
      assert element_exists?(lv2, "#section-workflow-graph-id")

      # Toggle OFF - should disappear
      click_chevron_toggle(lv2, "dev_show_workflow_graph")
      assert wait_for_element_disappearance(lv2, "#section-workflow-graph-id")
    end
  end
end
