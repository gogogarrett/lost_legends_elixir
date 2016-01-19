defmodule LostLegends.RoomChannel do
  use LostLegends.Web, :channel

  alias LostLegends.{Repo, Monster, Battle}
  alias LostLegends.BattleChannel.Monitor

  def join("battle:" <> battle_id, payload, socket) do
    channel_name = battle_key(battle_id)

    id = random_id
    user = %{id: id, name: "user:#{id}"}

    send self, {:after_join, Monitor.user_joined(channel_name, user)[channel_name] }

    socket = socket
             |> assign(:battle, battle_id)
             |> assign(:user, user.id)
    {:ok, socket}
  end

  def handle_in("attack:" <> user_id, %{"damage" => damage}, socket) do
    {:noreply, socket}
  end

  def handle_info({:after_join, connected_users}, socket) do
    broadcast! socket, "user:joined", %{users: connected_users}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    battle_id = socket.assigns.battle
    user_id = socket.assigns.user

    channel_name = battle_key(battle_id)

    broadcast! socket, "user:left", %{
      users: Monitor.user_left(channel_name, user_id)[channel_name]
    }

    :ok
  end

  defp battle_key(battle_id), do: "battle:#{battle_id}"
  defp random_id do
    {{_, _, _}, {_, _, id}} = :calendar.local_time |>
                              :calendar.local_time_to_universal_time
    id
  end
end
