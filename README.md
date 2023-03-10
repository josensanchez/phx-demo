# phx-demo

Demo project using github public API.

The basic idea is to query the public API but not directly.
That job is performed by a Supervised GenServer.

A LiveView will query that data from the existing pool and will show user and repositories from github related to elixir projects.

It relies on a ApiClient GenServer running on a Supervisor and it contains all information in it's state. The ApiClient schedule queries to the GihHub Api as soon as it fires up and keep pulling until the quota is completed.

### There is also a [Nextjs 13 application](https://github.com/josensanchez/nextjs13-demo) in with I explore other github public API features

![phx-demo3](https://user-images.githubusercontent.com/5849818/215769318-36003d37-1093-4a04-ab4b-9db56783da8d.png)

## Basic structure

The main view is a LiveView that handles user interactions.

- **[GhClient.GhProjectLive](lib/gh_client_web/live/gh_project_live.ex)** main view  

- **Supervisor**: makes sure that the ApliClient si always running 
  - **[ApiClient](lib/gh_client/api_client.ex)**: handles the state
    - **GitServer** -> **[GitHub](lib/gh_client/github.ex)** (implementation of GitServer) query the github RestAPi
 


## Instalation

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Tests

The ApliClient GenServer is tested, run `mix test` to execute them.

## Depencencies

- httpoison
- poison
- picocss




