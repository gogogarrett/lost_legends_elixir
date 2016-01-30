defmodule LostLegends.BattleController do
  use LostLegends.Web, :controller

  def show(conn, %{"id" => id} = params) do
    battle = %{id: id}
    render(conn, "show.html", battle: battle)
  end
end
