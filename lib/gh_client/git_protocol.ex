
defmodule GitServer do

  def start(), do: GitHub.start()
  def get_user(user), do: GitHub.get_user(user)
  def get_repositories(page), do: GitHub.get_repositories(page)

end

