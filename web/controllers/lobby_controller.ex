defmodule LostLegends.LobbyController do
  use LostLegends.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
