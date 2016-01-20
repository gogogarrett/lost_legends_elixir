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
    :gen_fsm.send_event(@name, {:player_joined, channel, player})
  end

  def get_players(channel) do
    :gen_fsm.sync_send_event(@name, {:get_players, channel})
  end

  #####
  # GenFSM API
  def init(state) do
    {:ok, :waiting, state}
  end

  def waiting(:get_state, from, state) do
    {:reply, {:waiting, state}, :waiting, state}
  end
  def waiting({:get_players, channel}, from, state) do
    players = list_players(state, channel)
    {:reply, {:ok, players}, :waiting, state}
  end
  def waiting({:player_joined, channel, player}, state) do
    new_state = case Map.get(state, channel) do
      nil ->
        Map.put(state, channel, [player])
      players ->
        uniq_players = Enum.uniq([player | players])
        Map.put(state, channel, uniq_players)
    end
    {:next_state, :waiting, new_state}
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
