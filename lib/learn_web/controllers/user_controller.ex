defmodule LearnWeb.UserController do
  @moduledoc """
  This controller is the one dedicated to manage
  the user CRUD operations
  """

  use LearnWeb, :controller
  alias Learn.Accounts

  def new(conn, _params) do
    user = Accounts.new_user()

    conn
    |> render("new.html", user: user)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_flash(:info, "User created!")
      |> redirect(to: Routes.user_path(conn, :show, user.id))
    end
  end

  def show(conn, %{"id" => user_id}) do
    user = Accounts.get_user(user_id)

    conn
    |> render("user.html", user: user)
  end

end
