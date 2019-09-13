defmodule LearnWeb.PageController do
  use LearnWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
