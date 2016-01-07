defmodule LostLegends.PageController do
  use LostLegends.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
