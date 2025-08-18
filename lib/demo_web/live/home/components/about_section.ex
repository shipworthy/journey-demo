defmodule DemoWeb.Live.Home.Components.AboutSection do
  @moduledoc false

  use Phoenix.Component
  alias DemoWeb.Live.Classes
  alias DemoWeb.Live.Home.Components.Gear

  def render(assigns) do
    ~H"""
    <div id="about-id" class={" my-4 " <> Classes.debug_info()}>
      <div class={Classes.dev_paragraph()}>
        This web application computes your horoscope based on your name, birth date and your pet preferences.
      </div>
      <div class={Classes.dev_paragraph()}>
        This app is also an interactive technical demo. If you are an engineer, here is a bit more data.
        <div :if={Map.get(@values, :dev_show_more, false)}>
          <div class={Classes.dev_header()}>
            Elements of Functionality
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Once you start interacting with the page, the URL in your browser changes to include session's ID. Example:
            <a href={"/s/#{@execution_id}"} target="_blank" class="text-blue-600 hover:underline">
              {"/s/#{@execution_id}"}
            </a>
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Your session is persistent – its data and its computations (including in-flight computations) will survive page reloads, re-deployments, up-/down-scaling or crashes of replicas or of the infrastructure. No, really – try reloading the page – notice that this text remains expanded.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * If your name is "Bowser", you can't use the app, sorry. ;)
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * After the app validates your name, it is abbreviated, to protect your PII. ;)
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * The horoscope is [fake-]emailed to your [fake] email address immediately after it is generated.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Recurring Schedule: horoscope updates will optionally be scheduled to be [fake-]emailed to your fake email address.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Scheduled archival: Session state is retired two weeks after your last interaction.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * User-provided values: some of the values are provided by the user (name, birth month, etc).
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Computed values: some of the values are computed (e.g. the text of the horoscope), once their upstream dependencies are in place (e.g. birth month).
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Computations will take place on any of the replicas of the service, with a retry policy.
          </div>
          <div class={Classes.dev_bulletpoint()}>
            * Introspection, analytics: the page provides some introspection (live history of events, the dump of all values – computed or provided, visial representation of the flow, some analytics around user flows).
          </div>
        </div>
        <div :if={Map.get(@values, :dev_show_more, false)}>
          <div class={Classes.dev_paragraph()}>
            <div class={Classes.dev_header()}>
              Implementation Details & Source Code
            </div>
            <div class={Classes.dev_bulletpoint()}>
              * This is an
              <a href="https://elixir-lang.org/" target="_blank" class="text-blue-600 hover:underline">
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
                href="https://hexdocs.pm/journey"
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
            <div class={Classes.dev_paragraph()}>
              Fun fact: the state of each of the "<Gear.render />" toggles on this page is persisted in the
              <a
                href="https://github.com/shipworthy/journey-demo/blob/d100f77d353a9590055f8c0d9cf66cf6dbe95399/lib/demo/horoscope_graph.ex#L152-L161"
                target="_blank"
                class="text-blue-600 hover:underline"
              >
                Journey Graph
              </a>
              and survives page reloads, deployments, and reboots.
            </div>
          </div>
        </div>
        <div
          :if={!Map.get(@values, :dev_show_more, false)}
          class="my-2 text-blue-600"
          phx-click="on-dev-show-more-click"
        >
          <Gear.render /> Show more <span>▼</span>
        </div>
        <div
          :if={Map.get(@values, :dev_show_more, false)}
          class="my-2 text-blue-600"
          phx-click="on-dev-show-more-click"
        >
          <Gear.render /> Show less <span>▲</span>
        </div>
      </div>
    </div>
    """
  end
end
