defmodule LostLegends.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]
  import Phoenix.Controller

  alias LostLegends.User
  alias LostLegends.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    if user = user_id && repo.get(User, user_id) do
      put_current_user(conn, user)
    else
      assign(conn, :current_user, nil)
    end
  end

  @doc """
  A helper function to verify we have a current_user in the session

  If there is not a user, we halt the request and put a flash message in
  """
  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  @doc """
  Looks up the specific user trying to log in and verifies they have a correct
  password.

  If they are valid, we call `login` to log them in

  If they invalid, we return {:error, _, conn} to be handled elsewhere
  """
  def login_by_username_and_pass(conn, username, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, username: username)

    cond do
      user && checkpw(given_pass, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end
  end

  @doc """
  Sets the current_user into the conn.assigns
  Puts `user_id` into the session
  Puts `user_token` into the session
  Renews the session
  """
  def login(conn, user) do
    conn
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  @doc """
  Drops the session - removing the current_user / user_id
  """
  def logout(conn) do
    configure_session(conn, drop: true)
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end
end
