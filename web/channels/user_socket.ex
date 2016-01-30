defmodule LostLegends.UserSocket do
  use Phoenix.Socket

  channel "battles:*", LostLegends.BattleChannel

  transport :websocket, Phoenix.Transports.WebSocket

  @max_age 2 * 7 * 24 * 60 * 60

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        user = LostLegends.Repo.get!(LostLegends.User, user_id)
        {:ok, assign(socket, :user_id, Integer.to_string user.id)}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error_handler

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
