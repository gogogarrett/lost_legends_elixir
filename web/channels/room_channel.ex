defmodule LostLegends.RoomChannel do
  use LostLegends.Web, :channel

  alias LostLegends.{Repo, Monster, Battle}

  def join("rooms:battle:" <> battle_id, payload, socket) do
    if authorized?(payload) do
      # :timer.send_interval(5000, :attack_random)
      send(self, {:after_join, battle_id})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("attack:" <> user_id, %{"damage" => damage}, socket) do
    battle = Repo.get(Battle, 1) |> Repo.preload(:monster)
    monster = battle.monster

    Repo.get!(Monster, monster.id)
    |> Monster.changeset(%{health: monster.health - damage})
    |> Repo.update!

    new_health = Repo.get!(Monster, monster.id).health

    cond do
      new_health <= 0 ->
        broadcast! socket, "attack", %{
          user_id: user_id,
          damage: damage,
          monster_health: 0
        }

        broadcast! socket, "monster_kill", %{
          user_id: user_id,
          damage: damage,
          monster_health: 0
        }
      new_health > 0 ->
        broadcast! socket, "attack", %{
          user_id: user_id,
          damage: damage,
          monster_health: new_health
        }
      true ->
        IO.puts "huh?"
    end

    {:noreply, socket}
  end

  def handle_info({:after_join, battle_id}, socket) do
    IO.puts battle_id

    # why you no work?
    # Repo.get(Battle, battle_id, preload: :monster)
    battle = Repo.get(Battle, battle_id) |> Repo.preload(:monster)
    monster = battle.monster

    broadcast! socket, "load_monster_info", %{
      name: monster.name, desc: monster.desc, health: monster.health
    }
    {:noreply, socket}
  end

  # def handle_info(:attack_random, socket) do
  #   broadcast! socket, "attack_random_user", %{}
  #   {:noreply, socket}
  # end
  defp authorized?(_payload), do: true
end
