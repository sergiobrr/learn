defmodule LearnWeb.SessionControllerTest do
  use LearnWeb.ConnCase

  alias LearnWeb.SessionController
  alias Learn.Accounts

  @moduletag :capture_log

  doctest SessionController

  @valid_create_params %{
    username: "test",
    email: "test@test.com",
    password: "test",
    password_confirmation: "test"
  }

  setup do
    conn = build_conn()
    {:ok, user} = Accounts.create_user(@valid_create_params)
    {:ok, conn: conn, user: user}
  end

  test "module exists" do
    assert is_list(SessionController.module_info())
  end

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Login"
  end

  test "POST /sessions (with valid data)", %{conn: conn, user: user} do
    conn = post conn, "/sessions", %{ username: user.username, password: "test"}
    assert redirected_to(conn) == "/"
    assert Plug.Conn.get_session(conn, :user)
  end

  test "POST /sessions (with invalid data)", %{conn: conn, user: user} do
    conn = post conn, "/sessions", %{ username: user.username, password: "fail"}
    assert html_response(conn, 302)
    assert is_nil(Plug.Conn.get_session(conn, :user))
  end

  test "DELETE /sessions", %{conn: conn, user: user} do
    conn = post conn, "/sessions", %{ username: user.username, password: "test"}
    assert Plug.Conn.get_session(conn, :user)
    conn = get conn, "/logout"
    assert is_nil(Plug.Conn.get_session(conn, :user))
  end

end
