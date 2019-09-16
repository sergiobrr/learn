defmodule LearnWeb.PollController do
  use LearnWeb, :controller

  alias Learn.Votes

  plug LearnWeb.VerifyUserSession when action in [:new, :create]

  def index(conn, _params) do
    polls = Votes.list_polls()

    conn
    |> render("index.html", polls: polls)
  end

  def new(conn, _params) do
    poll = Votes.new_poll()

    conn
    |> render("new.html", poll: poll)
  end

  def vote(conn, %{"id" => id}) do
    with {:ok, option} <- Votes.vote_on_option(id) do
      conn
      |> put_flash(:info, "Placed a vote for #{option.title}!")
      |> redirect(to: Routes.poll_path(conn, :index))
    end
  end

  def create(conn, %{"poll" => poll_params, "options" => options}) do
    split_options = String.split(options, ",")
    with user <- get_session(conn, :user),
         poll_params <- Map.put(poll_params, "user_id", user.id),
         {:ok, poll} <- Votes.create_poll_with_options(poll_params, split_options) do
      conn
      |> put_flash(:info, "Poll created successfully!")
      |> redirect(to: Routes.poll_path(conn, :index))
    else
      {:error, _poll} ->
        conn
        |> put_flash(:alert, "Error creating poll!")
        |> redirect(to: Routes.poll_path(conn, :new))
    end
  end

  def show(conn, %{"id" => id}) do
    with poll <- Votes.get_poll(id) do
      conn
      |> render("show.html", %{poll: poll})
    end
  end

end
