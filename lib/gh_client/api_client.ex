defmodule ApiClient do
  use GenServer
  @one_second 1000
  @ten_seconds 10000
  @one_minute  60000

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :initial_state, [])
    opts = Keyword.put_new(opts, :name, :api_client)

    GitServer.start
    GenServer.start_link(__MODULE__, opts[:initial_state], name: opts[:name])
  end

  def init([]) do
    IO.puts "Api Client Started XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    Process.send_after(self(), :update, @one_second)
    Process.send_after(self(), :process_data, @one_second)

    {:ok, %{:page => 1, :raw=>[],:repos=>[], :users=>%{}}}
  end
  
  def init(state) do
    {:ok, state}
  end

  def get_page(name \\ :api_client) do
    GenServer.call(name, {:get_page})
  end
  def get_repos(name \\ :api_client, q) do
    GenServer.call(name, {:get_repos, q})
  end

  def get_users(name \\ :api_client, q) do

    GenServer.call(name, {:get_users, q})
  end

  def handle_call({:get_page}, _from, state) do
    current = Map.get(state, :page)
    {:reply, current, state}
  end

  def handle_call({:get_repos, ""}, _from, state) do
    current = Map.get(state, :repos)
    {:reply, current, state}
  end

  def handle_call({:get_repos, q}, _from, state) do
    current = Map.get(state, :repos)
              |> Enum.filter(fn (repository) -> String.contains?(repository[:owner][:login], q) end)
    {:reply, current, state}
  end

  def handle_call({:get_users, ""}, _from, state) do
    current = state 
              |> Map.get(:users) 
              |> Enum.map(fn ({_, user}) -> user end)
    {:reply, current, state}
  end

  def handle_call({:get_users, q}, _from, state) do
    current = state 
              |> Map.get(:users) 
              |> Enum.map(fn ({_, user}) -> user end)
              |> Enum.filter(fn (user) -> String.contains?(user[:login], q) end)
    {:reply, current, state}
  end

  def handle_info(:update, state) do
    resp = GitServer.get_repositories(state.page)
    { state, time } = update_state(state, resp)
    Process.send_after(self(), :update, time)
    {:noreply, state}
  end

  def handle_info(:process_data, state) do
    [repo | raw ] = state.raw
    new_state = state
    |> Map.put(:raw, raw)
    |> Map.put(:users, update_users(state.users, repo))
    |> Map.put(:repos, update_repos(state.repos, repo))
    Process.send_after(self(), :process_data, 333)
    {:noreply, new_state}
  end

  defp update_state(state, [_items={:items, i}, _total_count]) do
    new_state = state
      |> Map.put(:raw, state.raw ++ i)
      |> Map.put(:page, state.page + 1)
    IO.puts "Apli Client HANDLE INFO update XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    { new_state,  @ten_seconds }
  end 

  defp update_state(state, _response) do
    IO.puts "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF   Apli Client HANDLE INFO update FAILED "
    { state,  @one_minute }
  end 

  defp update_users(users, repo) do
    Map.put(users, repo[:owner][:id], repo[:owner])
  end

  defp update_repos(repos, repo) do
    repos ++ [repo]
  end

end
