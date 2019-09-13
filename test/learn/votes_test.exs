defmodule Learn.VotesTest do
  use Learn.DataCase

  alias Learn.Votes

  @moduletag :capture_log
  @valid_attrs %{ title: "Il titolo" }

  doctest Votes

  test "module exists" do
    assert is_list(Votes.module_info())
  end

  describe "polls" do
    def poll_fixture(attrs \\ %{}) do
      with create_attrs <- Enum.into(attrs, @valid_attrs),
           {:ok, poll} <- Votes.create_poll(create_attrs),
           poll <- Repo.preload(poll, :options)
        do
          poll
      end
    end

    test "list polls/0 returns all polls" do
      poll = poll_fixture()
      assert Votes.list_polls() == [poll]
    end
  end

  test "new_poll/0 returns a new blank changeset" do
    changeset = Votes.new_poll()
    assert changeset.__struct__ == Ecto.Changeset
  end

  test "create_poll/1 returns a defined poll" do
     {:ok, poll} = Votes.create_poll(@valid_attrs)
     assert poll.title == "Il titolo"
  end

  test "create_poll/1 returns a new poll" do
    {:ok, poll1} = Votes.create_poll(@valid_attrs)
    {:ok, poll2} = Votes.create_poll(@valid_attrs)
    polls = [poll1, poll2]
    assert Enum.zip(Votes.list_polls(), polls)
    |> Enum.any?(fn t -> elem(t, 0).id == elem(t, 1).id end)
  end

  test "create_poll_with_options/2 returns a new poll with options" do
    title = "Poll With Options"
    options = ["Choice 1", "Choice 2", "Choice 3"]
    {:ok, poll} = Votes.create_poll_with_options(%{title: title}, options)
    assert poll.title == title
    assert Enum.count(poll.options) == 3
  end

end
