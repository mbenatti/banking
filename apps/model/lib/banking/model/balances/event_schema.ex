defmodule Banking.Model.Balances.EventSchema do
  @moduledoc """
  The Balances of an bank account

  This schema control every fund added or removed of an account, the final balance
  is represented by `balance` field

  Each event have the previous event `t:t/0` as a parent represented as `parent`

  The `type` is an Enum `t:Banking.Model.Enums.BankOperationEnum.t/0` corresponding about Bank Account operation,
  the values accepted are "DEPOSIT", "TRANSFER_ISSUED", "TRANSFER_RECEIVED" and "WITHDRAWAL"
  """

  use Ecto.Schema

  alias Banking.Model.Accounts.AccountSchema
  alias Banking.Model.Enums.BankOperationEnum.Type
  alias Banking.Model.Repo

  import Ecto.Changeset

  @typedoc """
  The `Banking.Model.Balances.EventSchema` struct.
  """
  @type t :: %__MODULE__{}

  schema "balances_event" do
    field(:balance, :decimal)
    field(:quantity_moved, :decimal)
    field(:type, Type)

    belongs_to(:account, AccountSchema)
    belongs_to(:parent, __MODULE__)

    timestamps()
  end

  @required [:quantity_moved, :account_id, :type]
  @optional [:parent_id]

  @doc """
  The changeset for `t:t/0`

  Responsible also to set the sign of `quantity_moved` by  `t:Banking.Model.Enums.BankOperationEnum.t/0`

  Do not accept the `balance` as params the balance is calculate by the `changeset/2` using the previous `t:t/0`(`:parent`)
  using the `balance` of `parent` and the current `quantity_moved`

  ## Examples

      iex> EventSchema.changeset %EventSchema{}, %{type: Type.Deposit, quantity_moved: 10, account_id: account.id}
      #Ecto.Changeset<
      action: nil,
      changes: %{
        account_id: 2,
        balance: #Decimal<10>,
        quantity_moved: #Decimal<10>,
        type: Banking.Model.Enums.BankOperationEnum.Type.Deposit
      },
      errors: [],
      data: #Banking.Model.Balances.EventSchema<>,
      valid?: true
      >

  """
  @spec changeset(t(), Map.t()) :: Changeset.t()
  def changeset(event \\ __MODULE__, params \\ %{}) do
    event
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_number(:quantity_moved, greater_than_or_equal_to: 0)
    |> do_changeset
  end

  defp do_changeset(%{valid?: false} = changeset) do
    changeset
  end

  defp do_changeset(changeset) do
    parent =
      changeset
      |> get_field(:parent_id)
      |> get_parent()

    type = get_field(changeset, :type)

    {changeset, quantity_moved} =
      changeset
      |> cast_quantity_moved(type)

    changeset
    |> cast_balance(parent, quantity_moved)
    |> validate_number(:balance, greater_than_or_equal_to: 0)
  end

  defp get_parent(nil), do: nil
  defp get_parent(id), do: Repo.get(__MODULE__, id)

  defp get_parent_balance(%__MODULE__{balance: balance}), do: balance
  defp get_parent_balance(_), do: 0

  defp cast_quantity_moved(changeset, type) when type in [Type.Withdrawal, Type.TransferIssued] do
    quantity_moved = get_field(changeset, :quantity_moved)
    quantity_moved = %Decimal{Decimal.new(quantity_moved) | sign: -1}

    {put_change(changeset, :quantity_moved, quantity_moved), quantity_moved}
  end

  defp cast_quantity_moved(changeset, type) when type in [Type.Deposit, Type.TransferReceived] do
    {changeset, get_field(changeset, :quantity_moved)}
  end

  defp cast_balance(changeset, parent, quantity_moved) do
    new_balance =
      parent
      |> get_parent_balance
      |> Decimal.add(quantity_moved)

    put_change(changeset, :balance, new_balance)
  end
end
