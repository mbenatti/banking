defmodule Banking.Model.Trades.TradeSchema do
  @moduledoc """
  Represent a Trade

  The trade is each Trade event, like Deposit, Withdrawal, Transfer received and issued
  and is backed on `t:Banking.Model.Balances.EventSchema.t/0`.

  The fields `type`, `balance`, `quantity` are virtual's field, necessary to build the reports, loaded from `balance_event`
  """

  use Ecto.Schema

  alias Banking.Model.Accounts.AccountSchema
  alias Banking.Model.Balances.EventSchema
  alias Banking.Model.Enums.BankOperationEnum.Type

  import Ecto.Changeset

  @typedoc """
  The `Banking.Model.Trades.TradeSchema` struct.
  """
  @type t :: %__MODULE__{}

  schema "trades" do
    field(:type, :string, virtual: true)
    field(:quantity, :decimal, virtual: true)
    field(:balance, :decimal, virtual: true)

    belongs_to(:account, AccountSchema)
    belongs_to(:transfer_account, AccountSchema)
    belongs_to(:balance_event, EventSchema)

    timestamps()
  end

  @required [:account_id, :balance_event_id]
  @optional [:transfer_account_id]

  @doc """
  The changeset for `t:t/0`

  The values are created based on Balance Event, the `event_type` param is the `:type` on `t:Banking.Model.Balances.EventSchema.t/0`
  and is used to support the `transfer_account_id` validation (that may be required or not, depending of the type of transaction)

  ## Examples

      iex> TradeSchema.changeset(%TradeSchema{}, %{}, type: "DEPOSIT")
      #Ecto.Changeset<
      action: nil,
      changes: %{type: Banking.Model.Enums.BankOperationEnum.Type.Deposit},
      errors: [
        account_id: {"can't be blank", [validation: :required]},
        balance_event_id: {"can't be blank", [validation: :required]}
      ],
      data: #Banking.Model.Trades.TradeSchema<>,
      valid?: false
      >

  """
  @spec changeset(t(), Map.t(), String.t()) :: Changeset.t()
  def changeset(event \\ __MODULE__, params \\ %{}, event_type) do
    event
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_transfer_account_id(event_type)
  end

  defp validate_transfer_account_id(changeset, event_type) do
    case event_type do
      type when type in [Type.Deposit, Type.Withdrawal] ->
        if is_nil(get_field(changeset, :transfer_account_id)),
          do: changeset,
          else:
            add_error(
              changeset,
              :transfer_account_id,
              "Deposit or Withdrawal do not have Transfer account."
            )

      type when type in [Type.TransferIssued, Type.TransferReceived] ->
        if is_nil(get_field(changeset, :transfer_account_id)),
          do:
            add_error(changeset, :transfer_account_id, "Transfers must have a Transfer account."),
          else: changeset
    end
  end
end
