defmodule Learn.Votes do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Learn.Repo
  alias Learn.Votes.Poll
  alias Learn.Votes.Option
  alias Learn.Votes.Image
  alias Learn.Votes.Message

  def list_polls do
    Repo.all(Poll) |> Repo.preload([:options, :image, :messages])
  end

  def list_options do
    Repo.all(Option) |> Repo.preload(:poll)
  end

  def new_poll do
    Poll.changeset(%Poll{}, %{})
  end

  def create_poll_with_options(poll_attrs, options, image_data) do
    Repo.transaction(fn ->
      with {:ok, poll} <- create_poll(poll_attrs),
        {:ok, _options} <- create_options(options, poll),
        {:ok, filename} <- upload_file(poll_attrs, poll),
        {:ok, _upload} <- save_upload(poll, image_data, filename)
        do
        poll |> Repo.preload(:options)
      else
        _ -> Repo.rollback("Failed to create poll")
      end
    end)
  end

  def create_poll(attrs) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  def create_options(options, poll) do
    results = Enum.map(options, fn option ->
      create_option(%{title: option, poll_id: poll.id})
    end)

    if Enum.any?(results, fn {status, _} -> status == :error end) do
      {:error, "Failed to create an option"}
    else
      {:ok, results}
    end
  end

  def create_option(attrs) do
    %Option{}
    |> Option.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_polls(user_id) do
    Repo.get_by(Poll, user_id: user_id)
  end

  def vote_on_option(option_id) do
    with option <- Repo.get!(Option, option_id),
      votes <- option.votes + 1
    do
      update_option(option, %{votes: votes})
    end
  end

  def update_option(option, attrs) do
    option
    |> Option.changeset(attrs)
    |> Repo.update()
  end

  def get_poll(poll_id) do
    Repo.get!(Poll, poll_id) |> Repo.preload([:options, :image, :messages])
  end

  defp upload_file(%{"image" => image, "user_id" => user_id}, poll) do
    extension = Path.extname(image.filename)
    filename = "#{user_id}-#{poll.id}-image#{extension}"
    File.cp(image.path, "./uploads/#{filename}")
    {:ok, filename}
  end

  defp upload_file(_, _), do: {:ok, nil}

  defp save_upload(_poll, _image_data, nil), do: {:ok, nil}
  defp save_upload(poll, %{"caption" => caption, "alt_text" => alt_text}, filename) do
    attrs = %{
      url: "/uploads/#{filename}",
      alt: alt_text,
      caption: caption,
      poll_id: poll.id,
      user_id: poll.user_id
    }
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def list_lobby_messages do
    Repo.all(
      from m in Message,
      where: is_nil(m.poll_id),
      order_by: [desc: :inserted_at],
      limit: 100
    )
  end

  def list_poll_messages(poll_id) do
    Repo.all(
      from m in Message,
      where: m.poll_id == ^poll_id,
      order_by: [desc: :inserted_at],
      limit: 100,
      preload: [:poll]
    )
  end

  def create_message(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

end
