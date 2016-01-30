defmodule LostLegends.BattleChannel do
  use LostLegends.Web, :channel

  alias LostLegends.Monster
  alias LostLegends.BattleChannel.StateMachine

  def join("battles:" <> battle_id = channel_name, payload, socket) do
    players = StateMachine.player_joined(channel_name, socket.assigns.current_user)[channel_name]
    # send self, {:after_join, battle_id}

    # {_, state} = StateMachine.get_state
    # players = state[channel_name]

    {:ok, %{players: players}, assign(socket, :battle_id, battle_id)}
  end

  # def handle_info({:after_join, battle_id}, socket) do
  #   channel_name = "battles:#{battle_id}"
  #   StateMachine.player_joined(channel_name, socket.assigns.current_user)

  #   {:noreply, socket}
  # end

  def terminate(_reason, socket) do
    channel_name = "battles:#{socket.assigns.battle_id}"

    StateMachine.player_left(channel_name, socket.assigns.current_user)

    {_, state} = StateMachine.get_state
    players = state[channel_name]

    broadcast! socket, "player:left", %{players: players}

    :ok
  end
end
