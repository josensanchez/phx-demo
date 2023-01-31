defmodule GhClientWeb.PageController do
  use GhClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
