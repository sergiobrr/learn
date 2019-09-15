defmodule Learn.AccountsTest do
  use Learn.DataCase

  alias Learn.Accounts

  @moduletag :capture_log

  doctest Accounts

  test "module exists" do
    assert is_list(Accounts.module_info())
  end

  describe "users" do
    @valid_attrs %{
      username: "Pino Nano",
      email: "em@ail.com",
      active: true,
      password: "test",
      password_confirmation: "test"
    }

    def user_fixture(attrs \\ %{}) do
      with create_attrs <- Map.merge(@valid_attrs, attrs),
        {:ok, user} <- Accounts.create_user(create_attrs)
      do
        user |> Map.merge(%{password: nil, password_confirmation: nil})
      else
        error -> error
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
      assert Map.merge(user, %{password: nil, password_confirmation: nil}) in Accounts.list_users()
    end

    test "create_user/1 fails to create the user without a password and password_confirmation" do
      {:error, changeset} = user_fixture(%{password: nil, password_confirmation: nil})
      assert !changeset.valid?
    end

    test "create_user/1 fails to create the user when the password and
      the password_confirmation don't match" do
      {:error, changeset} = user_fixture(%{password: "test",
      password_confirmation: "fail"})
      assert !changeset.valid?
    end

    test "get_user_by_username/1 returns desired user or nothing" do
      user = user_fixture(@valid_attrs)
      assert Accounts.get_user_by_username(user.username) == user
      assert Accounts.get_user_by_username("altro") == nil
    end

    test "create_user/1 fails to create the user when the username already exists" do
      _user1 = user_fixture()
      {:error, user2} = user_fixture()
      assert !user2.valid?
    end

    test "create_user/1 fails to create the user when the email is not an email format" do
      {:error, user} = user_fixture(%{email: "testtestcom"})
      assert !user.valid?
    end

  end
end
