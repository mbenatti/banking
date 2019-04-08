defmodule Banking.Model.Balances.EventQueries do
  @moduledoc """
  The queries for the Balance Event context.
  """

  alias Banking.Model.Balances.EventSchema

  import Ecto.Query

  @doc """
  Return a query for a select all
  """
  @spec all() :: EventSchema.t()
  def all, do: EventSchema

  @doc """
  Return the query to get last balance event by account id

  ## Examples

      iex> EventQueries.get_last_by_account_id(2)
      #Ecto.Query<from e0 in Banking.Model.Balances.EventSchema,
      where: e0.account_id == ^2, order_by: [desc: e0.id], limit: 1>

  """
  @spec get_last_by_account_id(Integer.t()) :: Query.t()
  def get_last_by_account_id(account_id) do
    all()
    |> where([a], a.account_id == ^account_id)
    |> last()
  end
end
