defmodule Learn.Votes.Poll do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Learn.Votes.Poll
  alias Learn.Votes.Option
  alias Learn.Votes.Image
  alias Learn.Votes.Message
  alias Learn.Accounts.User

  schema "polls" do
    field :title, :string
    has_many :options, Option
    belongs_to :user, User
    has_one :image, Image
    has_many :messages, Message
    timestamps()
  end

  def changeset(%Poll{}=poll, attrs) do
    poll
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
