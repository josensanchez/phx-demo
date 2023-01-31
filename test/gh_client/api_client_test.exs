defmodule GhClient.ApiClientTest do
  use ExUnit.Case


  defp initial_state() do
    %{
      :page => 2, 
      :raw=>[],
      :repos=>[], 
      :users=>%{
                999999 => [
                  id: 999999,
                  login: "elixir-lang",
                  url: "https://api.github.com/users/elixir-lang"
                ]
              }
   }
  end

  test "search users with `xyz`" do
    {:ok, pid } = ApiClient.start_link([{:initial_state, initial_state()}, {:name, :test_client_api}])
    assert [] = ApiClient.get_users(pid, "xyz")

  end
  test "search users with `lang`" do
    {:ok, pid } = ApiClient.start_link([{:initial_state, initial_state()}, {:name, :test_client_api}])
    assert [
      [
          id: 999999,
          login: "elixir-lang",
          url: "https://api.github.com/users/elixir-lang"
      ]
    ] = ApiClient.get_users(pid, "lang")

  end
  test "get page" do
    {:ok, pid } = ApiClient.start_link([{:initial_state, initial_state()}, {:name, :test_client_api}])
    assert 2 = ApiClient.get_page(pid)

  end

  test "get repositories" do
    {:ok, pid } = ApiClient.start_link([{:initial_state, initial_state()}, {:name, :test_client_api}])
    assert [] = ApiClient.get_repos(pid, "")

  end
end

