defmodule LostLegends.BattleChannel.StateMachine do
  @name :StateMachine

  #####
  # External API
  def start_link(initial_state) do
    :gen_fsm.start_link({:local, @name}, __MODULE__, initial_state, [])
  end

  def get_state do
    :gen_fsm.sync_send_event(@name, :get_state)
  end

  def player_joined(channel, player) do
    :gen_fsm.sync_send_event(@name, {:player_joined, channel, player})
  end

  def player_left(channel, player) do
    :gen_fsm.sync_send_event(@name, {:player_left, channel, player})
  end

  def get_players(channel) do
    :gen_fsm.sync_send_event(@name, {:get_players, channel})
  end

  #####
  # GenFSM API
  def init(state) do
    {:ok, :waiting, state}
  end

  @doc """
    State: - waiting
    :get_state event

    This will return the current state and the current state
  """
  def waiting(:get_state, from, state) do
    {:reply, {:waiting, state}, :waiting, state}
  end

  @doc """
    State: - waiting
    :get_players event

    This will return the current players in the state for a given channel
  """
  def waiting({:get_players, channel}, from, state) do
    players = list_players(state, channel)
    {:reply, {:ok, players}, :waiting, state}
  end

  @doc """
    State: - waiting
    :player_joined event

    This will add a player to the channel map. When 4 uniq players are in the same channel
    we transition to the `playing` state. If there is less than 4 players, we stay in the `waiting` state.
  """
  def waiting({:player_joined, channel, player}, from, state) do
    {next_state, new_state} = case Map.get(state, channel) do
      nil ->
        {:waiting, Map.put(state, channel, [player])}
      players ->
        uniq_players = Enum.uniq([player | players])
        updated_state = Map.put(state, channel, uniq_players)
        if Enum.count(uniq_players) == 4 do
          {:playing, updated_state}
        else
          {:waiting, updated_state}
        end
    end
    {:reply, new_state, next_state, new_state}
  end

  @doc """
    State: - waiting
    :player_left event

    This will remove a player from the channel map. We stay in the `waiting` state.
  """
  def waiting({:player_left, channel, player}, from, state) do
    new_state = case Map.get(state, channel) do
      nil ->
        {:waiting, Map.put(state, channel, [])}
      players ->
        new_players = state
                      |> Map.get(channel)
                      |> Enum.reject(&(&1.id == player.id))

        Map.update!(state, channel, fn(_) -> new_players end)
    end
    {:reply, new_state, :waiting, new_state}
  end

  def playing(:get_state, from, state) do
    {:reply, {:playing, state}, :playing, state}
  end

  def playing({:get_players, channel}, from, state) do
    players = list_players(state, channel)
    {:reply, {:ok, players}, :playing, state}
  end

  defp list_players(map, key) do
    Map.get(map, key)
  end
end
