defmodule Banking.Accounts.Auth do
  @moduledoc """
  Responsible for authentications operation's
  """

  alias Banking.Model.Accounts.{AccountLoader, AccountSchema}

  @doc """
  Authenticate the user by email and password
  """
  @spec authenticate(String.t(), String.t()) ::
          {:ok, AccountSchema.t()} | {:error, :not_found} | {:error, :unauthorized}
  def authenticate(email, password) do
    with client when not is_nil(client) <- AccountLoader.get_by_email(email),
         true <- Argon2.verify_pass(password, client.password) do
      {:ok, client}
    else
      nil -> {:error, :not_found}
      false -> {:error, :unauthorized}
    end
  end
end
