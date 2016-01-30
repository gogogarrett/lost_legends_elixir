defmodule LostLegends.UserView do
  use LostLegends.Web, :view

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end
end
