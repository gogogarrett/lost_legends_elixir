defmodule LostLegends.BattleChannel do
  use LostLegends.Web, :channel

  alias LostLegends.Monster
  alias LostLegends.BattleChannel.StateMachine

  def join("battles:" <> battle_id = channel_name, payload, socket) do
    StateMachine.player_joined(channel_name, socket.assigns.current_user)
    send self, {:after_join, channel_name}

    {state_name, state} = StateMachine.get_state
    players = state[channel_name]

    {:ok, %{players: players, state_name: state_name}, assign(socket, :battle_id, battle_id)}
  end

  def handle_info({:after_join, channel_name}, socket) do
    {state_name, state} = StateMachine.get_state
    players = state[channel_name]
    broadcast! socket, "player:joined", %{players: players}

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    channel_name = "battles:#{socket.assigns.battle_id}"

    StateMachine.player_left(channel_name, socket.assigns.current_user)

    {_, state} = StateMachine.get_state
    players = state[channel_name]

    broadcast! socket, "player:left", %{players: players}

    :ok
  end
end
