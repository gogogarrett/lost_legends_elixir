defmodule LostLegends.BattleChannel do
  use LostLegends.Web, :channel

  alias LostLegends.{Repo, User, Monster}
  alias LostLegends.BattleChannel.StateMachine

  def join("battles:" <> battle_id = channel_name, payload, socket) do
    user = Repo.get(User, socket.assigns.user_id)
    StateMachine.player_joined(channel_name, user)
    # send self, {:after_join, channel_name}

    {state_name, state} = StateMachine.get_state
    players = state[channel_name]
              |> Phoenix.View.render_many(LostLegends.UserView, "user.json")

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

    user = Repo.get(User, socket.assigns.user_id)
    StateMachine.player_left(channel_name, user)

    {_, state} = StateMachine.get_state
    players = state[channel_name]

    broadcast! socket, "player:left", %{players: players}

    :ok
  end
end
