defmodule GitHub do
  use HTTPoison.Base

  @expected_fields ~w(
    login id avatar_url gravatar_id url html_url followers_url
    following_url gists_url starred_url subscriptions_url
    organizations_url repos_url events_url received_events_url type
    site_admin name company blog location email hireable bio
    public_repos public_gists followers following created_at updated_at
  )

  @expected_response_body_fields ~w(
    total_count items
  ) 

  @expected_repos_fields ~w(
    id node_id name full_name private owner html_url description url created_at homepage
  )

  def process_request_url(url) do
    "https://api.github.com" <> url
  end

  def get_user(user) do
    GitHub.get!("/users/" <> user).body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  def get_repositories(page) do
    GitHub.get!(searchProjectsUrl(page)).body
    |> Poison.decode!
    |> Map.take(@expected_response_body_fields)
    |> Enum.map(&mapResponse(&1))
  end

  defp searchProjectsUrl(1) do
    "/search/repositories?q=language:elixir+sort:updated-desc&per_page=50"
  end

  defp searchProjectsUrl(page) do
    "/search/repositories?q=language:elixir+sort:updated-desc&per_page=50&page="<> to_string(page)
  end

  defp mapResponse({"items", v}) do
    items = v
      |> Enum.map(fn (item) ->
        item
        |> Map.take(@expected_repos_fields)
        |> Enum.map(&mapRepo(&1))
      end)
    {:items, items}
  end

  defp mapResponse({k, v}) do
    {String.to_atom(k), v}
  end

  defp mapRepo({"owner", v}) do
    owner = v
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
    {:owner, owner}
  end

  defp mapRepo({k, v}) do
    {String.to_atom(k), v}
  end

end
