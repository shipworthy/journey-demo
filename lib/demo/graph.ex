defmodule Demo.Graph do
  @moduledoc false

  import Journey.Node

  require Logger

  import Journey.Node
  import Journey.Node.UpstreamDependencies

  def graph() do
    Journey.new_graph(
      "Horoscope workflow",
      "v1.0.0",
      [
        input(:first_name),
        input(:birth_day_of_month),
        input(:birth_month),
        input(:favorite_ice_cream_flavor),
        input(:cats_or_dogs),
        input(:preferred_cat_name),
        input(:email_address),
        compute(
          :zodiac_sign,
          [:birth_month, :birth_day_of_month],
          fn %{birth_month: _birth_month, birth_day_of_month: _birth_day_of_month} ->
            Process.sleep(1000)
            {:ok, "Taurus"}
          end
        ),
        compute(
          :horoscope,
          [:first_name, :zodiac_sign],
          fn %{first_name: first_name, astrological_sign: sign} ->
            Process.sleep(1000)
            {:ok, "🍪s await, #{sign} #{first_name}!"}
          end
        ),
        mutate(
          :redact_first_name,
          [:first_name],
          fn %{first_name: first_name} -> {:ok, "<redacted> #{first_name}"} end,
          mutates: :first_name
        ),
        mutate(
          :redact_favorite_ice_cream_flavor,
          [:favorite_ice_cream_flavor],
          fn %{favorite_ice_cream_flavor: favorite_ice_cream_flavor} ->
            {:ok, "<redacted> #{favorite_ice_cream_flavor}"}
          end,
          mutates: :favorite_ice_cream_flavor
        ),
        input(:subscribe_to_weekly_horoscope_emails),
        schedule_recurring(
          :weekly_horoscope_email_schedule,
          [:subscribe_to_weekly_horoscope_emails],
          fn
            %{subscribe_to_weekly_horoscope_emails: true} ->
              {:ok, System.system_time(:second) + one_week_in_seconds()}

            _ ->
              {:ok, nil}
          end
        ),
        compute(
          :send_weekly_horoscope_email,
          [:first_name, :email_address, :weekly_horoscope_email_schedule],
          fn %{first_name: first_name, email_address: email_address} ->
            Logger.info("Sending weekly horoscope email to #{first_name} at #{email_address}...")
            {:ok, true}
          end
        ),
        archive(
          :archive,
          unblocked_when({:last_updated_at, &long_time_since_last_update?/1})
        )
      ]
    )
  end

  defp long_time_since_last_update?(%{node_value: last_updated_at, execution_id: _execution_id}) do
    System.system_time(:second) - last_updated_at > 60 * 60 * 24
  end

  defp one_week_in_seconds() do
    604_800
  end
end
