# phx-demo

Demo project using github public API.

The basic idea is to query the public API but not directly.
That job is performed by a Supervised GenServer.

A LiveView will query that data from the existing pool and will show user and repositories from github related to elixir projects.



## Instalation

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Tests

Some test where added, run `mix test` to execute them.

## Depencencies

- httpoison
- poison
- picocss

## Usage

Search users and their repositories 


