defmodule Learn.Votes.Message do
  @moduledoc """
  Schema in charge of managing Message
"""
  use Ecto.Schema
  import Ecto.Changeset

  alias Learn.Votes.Message
  alias Learn.Votes.Poll

  schema "messages" do
    field :message, :string
    field :author, :string

    belongs_to :poll, Poll

    timestamps()
  end

  def changeset(%Message{}=message, attrs) do
    message
    |> cast(attrs, [:message, :author, :poll_id])
    |> validate_required([:message, :author])
  end

end
