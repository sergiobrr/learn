defmodule Learn.VotesTest do
  use Learn.DataCase

  alias Learn.Votes
  alias Learn.Accounts
  alias Learn.Repo

  @moduletag :capture_log

  doctest Votes

  setup do
    {:ok, user} = Accounts.create_user(%{
      username: "test",
      email: "test@test.com",
      password: "test",
      password_confirmation: "test"
    })
    {:ok, user: user}
  end

  test "module exists" do
    assert is_list(Votes.module_info())
  end

  describe "polls" do

    @valid_attrs %{ title: "Il titolo" }

    def poll_fixture(attrs \\ %{}) do
      with create_attrs <- Enum.into(attrs, %{ title: "Il titolo" }),
           {:ok, poll} <- Votes.create_poll(create_attrs),
           poll <- Repo.preload(poll, :options)
        do
          poll
      end
    end

    test "list polls/0 returns all polls", %{user: user} do
      poll = poll_fixture(%{user_id: user.id})
      assert Votes.list_polls() == [poll]
    end

    test "create_poll/1 returns a defined poll", %{user: user} do
       {:ok, poll} = Votes.create_poll(Map.put(@valid_attrs, :user_id, user.id))
       assert poll.title == "Il titolo"
    end

    test "new_poll/0 returns a new blank changeset" do
      changeset = Votes.new_poll()
      assert changeset.__struct__ == Ecto.Changeset
    end

    test "create_poll/1 returns a new poll", %{user: user} do
      {:ok, poll1} = Votes.create_poll(Map.put(@valid_attrs, :user_id, user.id))
      {:ok, poll2} = Votes.create_poll(Map.put(@valid_attrs, :user_id, user.id))
      polls = [poll1, poll2]
      assert Enum.zip(Votes.list_polls(), polls)
      |> Enum.any?(fn t -> elem(t, 0).id == elem(t, 1).id end)
    end

    test "create_poll_with_options/2 returns a new poll with options", %{user: user} do
      title = "Poll With Options"
      options = ["Choice 1", "Choice 2", "Choice 3"]
      {:ok, poll} = Votes.create_poll_with_options(%{
        title: title,
        user_id: user.id
      }, options)
      assert poll.title == title
      assert Enum.count(poll.options) == 3
    end
  end

  describe "options" do
    test "create_option/1 creates an option on a poll", %{user: user} do
      with {:ok, poll} = Votes.create_poll(%{ title: "Sample Poll", user_id: user.id }),
           {:ok, option} = Votes.create_option(%{ title: "Sample Choice", votes: 0, poll_id: poll.id }),
           option <- Repo.preload(option, :poll)
      do
        assert Votes.list_options() == [option]
      end
    end
  end

  describe "messages" do
    setup(%{user: user}) do
      {:ok, poll} = Votes.create_poll(%{ title: "Sample Poll", user_id: user.id })
      poll_messages = [ "Hello", "there", "World" ]
      lobby_messages = [ "Polls", "are", "neat" ]
      Enum.each(poll_messages, fn m ->
        Votes.create_message(%{ message: m, author: "Someone", poll_id: poll.id })
      end)
      Enum.each(lobby_messages, fn m ->
        Votes.create_message(%{ message: m, author: "Someone" })
      end)
      {:ok, poll: poll}
    end

    test "create_message/1 creates a message on a poll" do
      with {:ok, message} <- Votes.create_message(%{ message: "Hello World", author: "Someone" }) do
        assert Enum.any?(Votes.list_lobby_messages(), fn msg -> msg.id == message.id end)
      end
    end

    test "list_lobby_messages/1 only includes lobby message" do
      assert Enum.count(Votes.list_lobby_messages()) > 0
      assert Enum.all?(Votes.list_lobby_messages(), &(is_nil(&1.poll_id)))
    end

    test "list_poll_messages/1 only includes poll message", %{poll: poll} do
      assert Enum.count(Votes.list_poll_messages(poll.id)) > 0
      assert Enum.all?(Votes.list_poll_messages(poll.id), &(&1.poll_id == poll.id))
    end
  end

end

