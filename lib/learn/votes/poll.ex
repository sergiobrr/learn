defmodule Learn.Votes.Poll do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Learn.Votes.Poll
  alias Learn.Votes.Option

  schema "polls" do
    field :title, :string
    has_many :options, Option
    timestamps()
  end

  def changeset(%Poll{}=poll, attrs) do
    poll
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
