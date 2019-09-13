defmodule LearnWeb.UserControllerTest do
  use LearnWeb.ConnCase

  alias LearnWeb.UserController

  @moduletag :capture_log

  doctest UserController

  @create_params %{
    "username" => "test",
    "email" => "test@test.com",
    "password" => "test",
    "password_confirmation" => "test"
  }

  test "module exists" do
    assert is_list(UserController.module_info())
  end

  test "GET /users/new", %{conn: conn} do
    conn = get conn, "/users/new"
    response = html_response(conn, 200)
    assert response =~ "User Signup"
    assert conn.assigns.user.__struct__ == Ecto.Changeset
    assert response =~ "action=\"/users\" method=\"post\""
  end

  test "GET /users/:id", %{conn: conn} do
    with {:ok, user} <- Learn.Accounts.create_user(@create_params) do
      conn = get conn, "/users/#{user.id}"
      assert html_response(conn, 200) =~ user.username
    else
      _ -> assert false
    end
  end

  test "POST /users", %{conn: conn} do
    conn = post conn, "/users", %{"user" => @create_params}
    assert redirected_to(conn) =~ "/users/"
  end
end
