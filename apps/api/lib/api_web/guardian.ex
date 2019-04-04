defmodule Banking.APIWeb.Guardian do
  @moduledoc false
  use Guardian, otp_app: :api

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    {:ok, %{id: id}}
  end
end
