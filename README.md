# Horoscopes Website – Journey Demo Application


## Summary

This simple Elixir Phoenix Liveview Horoscopes web application demonstrates using [Journey](https://hex.pm/packages/journey).

You can see this application running at https://demo.gojourney.dev/

THe application prompts the user for some inputs (name, birthday, pet preferences), validates the data (is the user's name "Bowser"?), computes the results as the data becomes available (zodiac sign, horoscope, "emailing" the horoscope to the user), and schedules recurring actions for the future (weekly horoscope "emails"). The session will also archive itself after a two weeks of inactivity. The application also gives the user some UI toggles, to get some insights into what happens behind the scenes.  

The application uses Journey to define its flow – inputs and computations, and their dependencies.

The application also uses Journey for creating and executing instance of that flow – from the moment the user engages with the page, at which point the id of the execution becomes part of the URL. 

The application also uses Journey for persisting user-provided and computed data points.

The application also uses Journey for persisting the state of the toggles in the UI -- the user's selection is preserved across page reloads. 

The application also uses Journey to get some analytics about the state of the flow, and the visual representation of the graph itself.


## Running the app

To clone and run the application (assuming you already have elixir installed). THe sequence gives yu the option of running a postgres db in a container.

```
~/src $ git clone git@github.com:shipworthy/journey-demo.git
~/src/journey-demo $ mix deps.get
~/src/journey-demo $ # if you want to create the db running in a container:
~/src/journey-demo $ # make db-local-rebuild
~/src/journey-demo $ make run-dev
...
[info] Access DemoWeb.Endpoint at http://localhost:4000
...
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser and play with the app running on your machine.


## Learn more

  * see this running live https://demo.gojourney.dev
  * Journey documentation: https://hexdocs.pm/journey/Journey.html
  * Journey source code: https://github.com/markmark206/journey
  * About Journey: https://gojourney.dev
  * Elixir: https://elixir-lang.org/
  * Phoenix Docs: https://hexdocs.pm/phoenix
