defmodule Demo.HoroscopeGraph do
  @moduledoc """
  Journey graph for the horoscope demo application.

  This demonstrates Journey's key features:
  - Input validation and conditional flow
  - Automatic computation when dependencies are satisfied
  - Data mutation for privacy
  - Scheduled one-time and recurring events
  - Clean separation of workflow and business logic
  """

  import Journey.Node
  import Journey.Node.UpstreamDependencies
  import Journey.Node.Conditions

  require Logger

  # Helper function to notify LiveView of updates
  defp notify(execution_id, step, data) do
    Logger.info("Journey notify: execution_id: #{execution_id}, step: #{step}")
    Phoenix.PubSub.broadcast(Demo.PubSub, "execution:#{execution_id}", {:refresh, step, data})
    :ok
  end

  def graph() do
    Journey.new_graph(
      "Horoscope Demo App",
      "v1.0.1",
      [
        # === Input Nodes ===
        input(:name),
        input(:birth_day),
        input(:birth_month),
        input(:pet_preference),
        input(:email_address),
        input(:subscribe_weekly),

        # === Name Validation (Conditional Flow) ===
        compute(
          :name_validation,
          [:name],
          &validate_name/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :name_validation, result)
          end
        ),

        # === Zodiac Computation ===
        compute(
          :zodiac_sign,
          unblocked_when({
            :and,
            [
              {:birth_month, &provided?/1},
              {:birth_day, &provided?/1},
              {:name_validation,
               fn validation ->
                 validation.node_value == "valid"
               end}
            ]
          }),
          &compute_zodiac_sign/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :zodiac_sign, result)
          end
        ),

        # === Horoscope Generation ===
        compute(
          :horoscope,
          [:zodiac_sign, :pet_preference, :name],
          &generate_horoscope/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :horoscope, result)
          end
        ),

        # === Data Mutation (Privacy) ===
        mutate(
          :anonymize_name,
          # Only anonymize after validation passes
          [:name_validation],
          &anonymize_name_value/1,
          mutates: :name,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :anonymize_name, result)
          end
        ),

        # === Email Horoscope ===
        compute(
          :email_horoscope,
          [:horoscope, :email_address, :name],
          &send_horoscope_email/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :email_horoscope, result)
          end
        ),

        # === Weekly Reminder Scheduling ===
        schedule_recurring(
          :weekly_reminder_schedule,
          unblocked_when({
            :and,
            [
              {:subscribe_weekly, fn sub -> sub.node_value == true end},
              {:horoscope, &provided?/1}
            ]
          }),
          &schedule_weekly_reminders/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :weekly_reminder_schedule, result)
          end
        ),

        # === Send Weekly Reminder ===
        compute(
          :send_weekly_reminder,
          unblocked_when({
            :and,
            [
              {:subscribe_weekly, fn sub -> sub.node_value == true end},
              {:weekly_reminder_schedule, &provided?/1},
              {:email_address, &provided?/1}
            ]
          }),
          # [:weekly_reminder_schedule, :email_address, :name],
          &send_weekly_reminder_email/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :send_weekly_reminder, result)
          end
        ),

        # === Auto-archive after 2 weeks of inactivity ===
        schedule_once(
          :schedule_archive,
          [:last_updated_at],
          &schedule_archive_time/1,
          f_on_save: fn execution_id, result ->
            notify(execution_id, :schedule_archive, result)
          end
        ),
        archive(
          :auto_archive,
          [:schedule_archive],
          f_on_save: fn execution_id, result ->
            notify(execution_id, :auto_archive, result)
          end
        ),
        input(:show_computation_states)
      ]
    )
  end

  # === Business Logic Functions ===
  # These are placeholders demonstrating where real business logic would go

  def validate_name(%{name: name}) do
    # In production, this might check against a database of blocked names,
    # validate name format, check for profanity, etc.
    case String.downcase(String.trim(name)) do
      "bowser" ->
        {:ok, :bad_bad_bad}

      _ ->
        {:ok, :valid}
    end
  end

  def compute_zodiac_sign(%{birth_month: month, birth_day: day}) do
    # In production, this would use a proper astrological calculation
    # or API service for accurate zodiac determination
    sign =
      case {String.downcase(month), day} do
        {"january", d} when d >= 20 -> "Aquarius"
        {"january", _} -> "Capricorn"
        {"february", d} when d >= 19 -> "Pisces"
        {"february", _} -> "Aquarius"
        {"march", d} when d >= 21 -> "Aries"
        {"march", _} -> "Pisces"
        {"april", d} when d >= 20 -> "Taurus"
        {"april", _} -> "Aries"
        {"may", d} when d >= 21 -> "Gemini"
        {"may", _} -> "Taurus"
        {"june", d} when d >= 21 -> "Cancer"
        {"june", _} -> "Gemini"
        {"july", d} when d >= 23 -> "Leo"
        {"july", _} -> "Cancer"
        {"august", d} when d >= 23 -> "Virgo"
        {"august", _} -> "Leo"
        {"september", d} when d >= 23 -> "Libra"
        {"september", _} -> "Virgo"
        {"october", d} when d >= 23 -> "Scorpio"
        {"october", _} -> "Libra"
        {"november", d} when d >= 22 -> "Sagittarius"
        {"november", _} -> "Scorpio"
        {"december", d} when d >= 22 -> "Capricorn"
        {"december", _} -> "Sagittarius"
        # Default fallback
        _ -> "Taurus"
      end

    {:ok, sign}
  end

  def generate_horoscope(%{zodiac_sign: sign, pet_preference: pet_pref, name: name}) do
    # In production, this would call an LLM API like OpenAI GPT-4
    # with a prompt combining the user's zodiac sign and preferences
    base_horoscope = get_base_horoscope(sign)
    pet_modifier = get_pet_modifier(pet_pref)

    horoscope =
      "#{base_horoscope} #{pet_modifier} This cosmic wisdom is specifically calibrated for #{String.first(name)}****."

    {:ok, horoscope}
  end

  def send_horoscope_email(%{horoscope: _horoscope, email_address: email, name: name}) do
    # In production, this would integrate with SendGrid, Mailgun, AWS SES, etc.
    # and send an actual email with the horoscope content
    # Simulate API call delay
    Process.sleep(500)

    # Simulate occasional API failures for demo purposes
    # 10% failure rate
    if :rand.uniform(100) <= 10 do
      {:error, "Email service temporarily unavailable. Mercury must be in microwave mode."}
    else
      {:ok, "Horoscope successfully sent to #{email} for #{name}!"}
    end
  end

  def schedule_weekly_reminders(_values) do
    # In production, this might check user timezone, optimal send times, etc.
    next_week = System.system_time(:second) + 7 * 24 * 60 * 60
    {:ok, next_week}
  end

  def send_weekly_reminder_email(%{email_address: email, name: name}) do
    # In production, this would send a personalized weekly horoscope update
    # Simulate API call
    Process.sleep(200)
    {:ok, "Weekly cosmic update sent to #{email} for #{name}!"}
  end

  def anonymize_name_value(%{name: name}) do
    # In production, this might be more sophisticated PII handling
    # following GDPR, CCPA, or other privacy regulations
    case String.length(name) do
      0 ->
        {:ok, ""}

      1 ->
        {:ok, "*"}

      len ->
        first_char = String.first(name)
        asterisks = String.duplicate("*", len - 1)
        {:ok, first_char <> asterisks}
    end
  end

  def schedule_archive_time(_values) do
    # Archive execution 2 weeks after completion
    two_weeks = System.system_time(:second) + 14 * 24 * 60 * 60
    {:ok, two_weeks}
  end

  # === Helper Functions ===

  defp get_base_horoscope(sign) do
    # Hardcoded funny horoscopes for demo purposes
    horoscopes = %{
      "Aries" => "Your fiery energy will combust a small appliance today.",
      "Taurus" => "The stars suggest you should eat more cheese. The stars are very wise.",
      "Gemini" => "You will have two conversations at once and confuse yourself magnificently.",
      "Cancer" => "Your shell is showing. Consider wearing a better disguise.",
      "Leo" => "Today you will roar at something inappropriate. Own it.",
      "Virgo" =>
        "Your perfectionism will be tested by a crooked picture frame that haunts your dreams.",
      "Libra" => "The cosmic scales are unbalanced. Blame Mercury, not your poor life choices.",
      "Scorpio" => "Your mysterious aura will mystify a cashier at the grocery store.",
      "Sagittarius" => "Adventure calls, but so does your couch. The couch will win.",
      "Capricorn" =>
        "Your mountain-climbing spirit will be challenged by a particularly steep curb.",
      "Aquarius" =>
        "Your unique perspective will confuse three people and enlighten a houseplant.",
      "Pisces" => "You will swim upstream today, metaphorically speaking. Probably."
    }

    Map.get(horoscopes, sign, "The universe has mixed feelings about you today.")
  end

  defp get_pet_modifier(preference) do
    case preference do
      "cats" ->
        "A feline will judge you silently but approvingly."

      "dogs" ->
        "A canine's enthusiasm will briefly restore your faith in existence."

      "both" ->
        "The eternal cat-dog conflict within your soul will reach a temporary ceasefire."

      "neither" ->
        "Your lack of pet preference disturbs the cosmic pet balance. Consider a houseplant."

      _ ->
        "The universe questions your pet-related decision-making abilities."
    end
  end
end
