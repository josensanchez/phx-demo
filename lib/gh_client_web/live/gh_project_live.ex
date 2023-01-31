defmodule GhClientWeb.GHProjectLive do
  use GhClientWeb, :live_view
  

  def mount(_params, _session, socket) do
    IO.puts "MOUNT LIVEVIEW"
    page = ApiClient.get_page()
    repos = ApiClient.get_repos("")
    users = ApiClient.get_users("")
    Process.send_after(self(), "update", 500)
    {:ok, assign(socket, :data, %{:page => page, :repos => repos, :users=> users, :user_count=> 50, :q=>"", :only=>false})}
  end

  def handle_event("paginate_users", _, socket) do
    IO.puts "HANDLE PAGINATE USERS"
    socket = update(socket, :data, fn b -> %{ b | :user_count => b.user_count + 20} end)
    {:noreply, socket}
  end

  def handle_event("search", %{ "user"=> q }, socket) do
    IO.puts "HANDLE GENERIC EVENT: search" 
    socket = update(socket, :data, fn b -> %{ b | :q => q} end)
    Process.send(self(), "update_now", [])
    {:noreply, socket}

  end

  def handle_info("update_now", socket) do
    [page, repos, users, only] = update_data(socket.assigns.data.q)
    {:noreply, update(socket, :data, fn b -> %{ b | :page => page, :repos => repos, :users=> users, :only=> only} end)}
  end

  def handle_info("update", socket) do
    [page, repos, users, only] = update_data(socket.assigns.data.q)
    Process.send_after(self(), "update", 5000)
    {:noreply, update(socket, :data, fn b -> %{ b | :page => page, :repos => repos, :users=> users, :only=> only} end)}
  end

  defp update_data(q) do
    page = ApiClient.get_page()
    repos = ApiClient.get_repos(q)
    users = ApiClient.get_users(q)
    only = length(users) == 1
    [page, repos, users, only]
  end

end
