defmodule Learn.AccountsTest do
  use Learn.DataCase

  alias Learn.Accounts

  @moduletag :capture_log

  doctest Accounts

  test "module exists" do
    assert is_list(Accounts.module_info())
  end

  describe "users" do
    @valid_attrs %{username: "Pino Nano", email: "em@ail.com", active: true}

    def user_fixture(attrs \\ @valid_attrs) do
      with create_attrs <- Map.merge(@valid_attrs, attrs),
        {:ok, user} <- Accounts.create_user(create_attrs)
      do
        user
      end
    end

    test "list_users/0 return proper user list" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user/1 return desired user" do
      user = user_fixture()
      assert Accounts.get_user(user.id) === user
      assert Accounts.get_user(11) !== user
    end

    test "new_user/0 return an empty changeset" do
      assert Accounts.new_user().__struct__ == Ecto.Changeset
    end

    test "create_user/1 properly create a new user" do
      assert Accounts.list_users() === []
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert length(Accounts.list_users()) == 1
      assert user in Accounts.list_users()
    end

  end
end
