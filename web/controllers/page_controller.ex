defmodule LostLegends.PageController do
  use LostLegends.Web, :controller

  plug :take_to_lobby

  def index(conn, _params) do
    render conn, "index.html"
  end

  def take_to_lobby(conn, opts) do
    if conn.assigns.current_user do
      conn
      |> redirect(to: lobby_path(conn, :index))
    else
      conn
    end
  end
end
