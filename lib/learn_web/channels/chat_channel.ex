defmodule LearnWeb.ChatChannel do
  @moduledoc """
  Chat channeland relative methods
"""
  use LearnWeb, :channel

  alias Learn.Votes.Message
  alias Learn.Votes

  def join("chat:" <> _poll_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("new_message", %{"author" => author, "message" => message}, socket) do
    poll_id = case socket.topic do
      "chat:lobby" -> nil
      "chat:" <> id -> id
      _ -> nil
    end
    with {:ok, _message} <- Votes.create_message(%{
        author: author,
      message: message,
      poll_id: poll_id
    }) do
      broadcast socket, "new_message", %{author: author, message: message}
      {:reply, {:ok, %{author: author, message: message}}, socket}
    else
      _ -> {:reply, {:error, %{message: "Failed to send chat message"}}, socket}
    end
  end

end
