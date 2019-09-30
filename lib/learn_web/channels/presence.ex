defmodule LearnWeb.Presence do
  @moduledoc """
  This is the hand made user presence module
"""

  use Phoenix.Presence,
    otp_app: :learn,
    pubsub_server: Learn.PubSub

end
