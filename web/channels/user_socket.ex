defmodule LostLegends.UserSocket do
  use Phoenix.Socket

  channel "battles:*", LostLegends.BattleChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, assign(socket, :current_user, %{id: random_id, name: "Player"})}
  end

  def id(_socket), do: nil

  defp random_id do
    {{_, _, _}, {_, _, id}} = :calendar.local_time |>
                              :calendar.local_time_to_universal_time
    id
  end
end
