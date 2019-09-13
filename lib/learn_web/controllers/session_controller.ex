defmodule LearnWeb.SessionController do
  @moduledoc """
  This is the controller responsible for user's authentication
  and session management
  """

  use LearnWeb, :controller
  alias Learn.Accounts

  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  def create(conn, %{"username" => username, "password" => password}) do
    with user <- Accounts.get_user_by_username(username),
         {:ok, login_user} <- login(user, password)
      do
        conn
        |> put_flash(:info, "Logged succesfully")
        |> put_session(
             :user,
             %{id: login_user.id, username: login_user.username, email: login_user.email}
           )
        |> redirect(to: "/")
      else
        {:error, _} ->
        conn
        |> put_flash(:error, "Bad credentials")
        |> redirect(to: "/login")
    end
  end

  defp login(user, password) do
    Bcrypt.check_pass(user, password, hash_key: :encrypted_password)
  end

  defp delete_session(_) do
    true
  end

end
