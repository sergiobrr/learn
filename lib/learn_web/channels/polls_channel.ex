defmodule LearnWeb.PollsChannel do
  use LearnWeb, :channel

  alias Learn.Votes

  def join("polls:" <> _poll_id, _payload, socket) do
    IO.puts "MARONNA:::::::"
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", _payload, socket) do
    broadcast socket, "pong", %{message: "pong"}
    {:reply, {:ok, %{message: "pong"}}, socket}
  end

  def handle_in("vote", %{"option_id" => option_id}, socket) do
    with {:ok, option} <- Votes.vote_on_option(option_id) do
      broadcast socket, "new_vote", %{"option_id" => option.id, "votes" => option.votes}
      {:reply, {:ok, %{"option_id" => option.id, "votes" => option.votes}}, socket}
    else
      {:error, _} ->
        {:reply, {:error, %{message: "Failed to vote for option!"}}, socket}
    end
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (polls:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
