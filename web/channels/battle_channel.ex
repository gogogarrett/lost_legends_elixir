defmodule LostLegends.BattleChannel do
  use LostLegends.Web, :channel

  alias LostLegends.{Repo, User, Monster}
  alias LostLegends.Battle.{Supervisor, StateMachine}

  def join("battles:" <> battle_id, payload, socket) do
    Supervisor.start_child(battle_id)

    user = Repo.get(User, socket.assigns.user_id)
    StateMachine.player_joined(battle_id, user)

    send self, {:after_join, battle_id}

    {state_name, players} = StateMachine.get_state(battle_id)
    {:ok, %{players: render_players(players), state_name: state_name}, assign(socket, :battle_id, battle_id)}
  end

  def handle_info({:after_join, battle_id}, socket) do
    broadcast! socket, "player:joined", %{
      players: render_players(StateMachine.get_players(battle_id))
    }

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    battle_id = socket.assigns.battle_id

    user = Repo.get(User, socket.assigns.user_id)
    StateMachine.player_left(battle_id, user)

    broadcast! socket, "player:left", %{
      players: render_players(StateMachine.get_players(battle_id))
    }

    :ok
  end

  defp render_players(players) do
    Phoenix.View.render_many(players, LostLegends.UserView, "user.json")
  end
end
