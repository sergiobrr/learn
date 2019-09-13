defmodule Learn.Votes.Option do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Learn.Votes.Option
  alias Learn.Votes.Poll

  schema "options" do
    field :title, :string
    field :votes, :integer, default: 0
    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(%Option{}=option, attrs) do
    option
    |> cast(attrs, [:title, :votes, :poll_id])
    |> validate_required([:title, :votes, :poll_id])
  end
end
