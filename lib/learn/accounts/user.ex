defmodule Learn.Accounts.User do
  @moduledoc """
  This schema represents the user data structure
  for the user management
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Learn.Accounts.User
  alias Learn.Votes.Poll

  schema "users" do
    field :username, :string
    field :email, :string
    field :active, :boolean, default: true
    field :encrypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :polls, Poll

    timestamps()
  end

  def changeset(%User{}=user, attrs) do
    user
    |> cast(attrs, [:username, :email, :active, :password, :password_confirmation])
    |> validate_confirmation(:password, message: "Passwords don't match")
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> encrypt_password()
    |> validate_required([:username, :email, :active, :encrypted_password])
  end

  def encrypt_password(changeset) do
    with password when not is_nil(password) <- get_change(changeset, :password) do
      put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))
    else
      _ -> changeset
    end
  end

end
