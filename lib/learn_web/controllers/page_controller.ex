defmodule LearnWeb.PageController do
  use LearnWeb, :controller

  alias Learn.Votes

  def index(conn, _params) do
    messages = Votes.list_lobby_messages() |> Enum.reverse()
    render(conn, "index.html", messages: messages)
  end
end
