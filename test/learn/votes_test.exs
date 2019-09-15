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

end

