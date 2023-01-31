defmodule GhClientWeb.GHProjectLiveTest do
  use GhClientWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Github user from Elixir projects"
  end
end

