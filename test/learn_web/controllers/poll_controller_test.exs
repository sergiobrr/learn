defmodule PollControllerTest do
  use LearnWeb.ConnCase

  alias LearnWeb.PollController
  alias Learn.Accounts
  alias Learn.Votes

  @moduletag :capture_log

  doctest PollController

  setup do
    conn = build_conn()
    {:ok, user} = Accounts.create_user(%{
      username: "test",
      email: "test@test.com",
      password: "test",
      password_confirmation: "test"
    })
    {:ok, conn: conn, user: user}
  end

  defp login(conn, user) do
    conn |> post("/sessions", %{username: user.username, password: user.password})
  end

  test "module exists" do
    assert is_list(PollController.module_info())
  end

  test "GET /polls", %{conn: conn} do
    conn = get conn, "/polls"
    assert html_response(conn, 200) =~ "Polls now!"
  end

  test "GET /polls/new with a logged in user", %{conn: conn, user: user} do
    conn = login(conn, user) |> get("/polls/new")
    assert html_response(conn, 200) =~ "New Poll"
  end

  test "POST /polls (with valid data)", %{conn: conn, user: user} do
    conn = login(conn, user)
      |> post("/polls", %{"poll" => %{ "title" => "Test Poll" }, "options" => "One,Two,Three" })
    assert redirected_to(conn) == "/polls"
  end

  test "POST /polls (with invalid data)", %{conn: conn, user: user} do
    conn = login(conn, user)
      |> post("/polls", %{"poll" => %{ title: nil }, "options" => "One,Two,Three" })
    assert html_response(conn, 302)
    assert redirected_to(conn) == "/polls/new"
  end

  test "GET /polls/new without a logged in user", %{conn: conn} do
    conn = get(conn, "/polls/new")
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :error) == "You must be logged in to do that!"
  end

  test "POST /polls (with valid data, without logged in user)", %{conn: conn} do
    conn = post(conn, "/polls", %{"poll" => %{ "title" => "Test Poll" }, "options" => "One,Two,Three" })
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :error) == "You must be logged in to do that!"
  end
end
