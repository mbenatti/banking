defmodule Banking.Model.Accounts.AccountQueries do
  @moduledoc """
  The queries for the account context.
  """

  alias Banking.Model.Accounts.AccountSchema

  import Ecto.Query

  @doc """
  Return a query for a select all
  """
  @spec all() :: AccountSchema.t()
  def all, do: AccountSchema

  @doc """
  Return the query to get an account by email

  ## Examples

      iex> AccountQueries.get_by_email("marcos@email.com")
      #Ecto.Query<from a0 in Banking.Model.Accounts.AccountSchema,
       where: a0.email == ^"marcos@email.com">

  """
  @spec get_by_email(String.t()) :: Query.t()
  def get_by_email(email) do
    from(q in all(), where: q.email == ^email)
  end
end
