defmodule Learn.Accounts do
  @moduledoc """
  This is the context to use as interface towards
  the user schema
  """

  import Ecto.Query, warn: false
  alias Learn.Repo
  alias Learn.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def new_user() do
    User.changeset(%User{}, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

end
