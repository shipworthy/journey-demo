defmodule DemoWeb.Live.Home.Components.AboutSection do
  use Phoenix.Component

  @moduledoc false
  alias DemoWeb.Live.Classes

  def render(assigns) do
    ~H"""
    <div id="about-id" class={" my-4 " <> Classes.debug_info()}>
      <div class={Classes.dev_paragraph()}>
        This web application computes your horoscope based on your name, birth date and your pet preferences.
      </div>
      <div class={Classes.dev_paragraph()}>
        This app is also an interactive technical demo. If you are an engineer, here is a bit more data:
        <div :if={Map.get(@values, :dev_show_more, false)}>
          <div class={Classes.dev_bulletpoint()}>
            * Once you start your session, the URL in your browser includes the session's ID.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Your session is persistent -- its data and its computations (including in-flight computations) will survive page reloads, redeployments, up-/down-scaling of the backend, and infrastructure crashes.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Some of the values are provided by the user (name, birth month, etc).
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Some of the values are computed (e.g. the text of the horoscope), once its upstream dependencies are in place (e.g. birth month).
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Computations will take place on any of the replicas of the service, and subject to retry policy.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * The horoscope is [fake-]emailed to your [fake] email address immediately after it is generated.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * The user can ask for recurring [fake-]email updates.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * The horoscope is fake-emailed to your fake email address. ;)
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Session state is retired two weeks after your last interaction.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * If your name is "Bowser", you can't use the app, sorry. ;)
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * After the app validates your name, it is abbreviated, to protect your PII. ;)
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * The page also provides you with a bit of introspection (the history of events as they happen, the dump of all values – computed or provided, visial representation of the flow, some analytics around user flows).
          </div>
        </div>
        <div :if={Map.get(@values, :dev_show_more, false)}>
          <div class={Classes.dev_paragraph()}>
            A few words about the implementation:
            <div class={Classes.dev_bulletpoint()}>
              * This is an
              <a
                href="https://elixir-lang.org/"
                target="_blank"
                class="text-blue-600 hover:underline"
              >
                Elixir
              </a>
              /
              <a
                href="https://phoenixframework.org/"
                target="_blank"
                class="text-blue-600 hover:underline"
              >
                Phoenix LiveView
              </a>
              application.
            </div>
            <div class={Classes.dev_bulletpoint()}>
              * This app uses Postgres for persistence.
            </div>
            <div class={Classes.dev_bulletpoint()}>
              * this app uses
              <a
                href="https://shipworthy.hexdocs.pm/journey"
                target="_blank"
                class="text-blue-600 hover:underline"
              >
                Journey
              </a>
              for defining and executing the flow with persistence, reliability and scalability, and for various conveniences (introspection, visualization, analytics, scheduling).
            </div>
            <div class={Classes.dev_bulletpoint()}>
              * The source code of this app is avialable on github, <a
                href="https://github.com/shipworthy/journey-demo"
                target="_blank"
                class="text-blue-600 hover:underline"
              >https://github.com/shipworthy/journey-demo/</a>.
            </div>
            <div class={Classes.dev_bulletpoint()}>
              * The core of the app (values, functions for computing them, and their dependencies) are defined in the app's Journey Graph, <a
                href="https://github.com/shipworthy/journey-demo/blob/main/lib/demo/horoscope_graph.ex"
                target="_blank"
                class="text-blue-600 hover:underline"
              >here</a>.
            </div>
          </div>
        </div>
        <div :if={!Map.get(@values, :dev_show_more, false)} class="my-2" phx-click="on-dev-show-more-click">
          Show more <span>▼</span>
        </div>
        <div :if={Map.get(@values, :dev_show_more, false)} class="my-2" phx-click="on-dev-show-more-click">
          Show less <span>▲</span>
        </div>

      </div>
    </div>
    """
  end
end