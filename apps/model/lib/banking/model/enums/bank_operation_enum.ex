defmodule Banking.Model.Enums.BankOperationEnum do
  @moduledoc """
  The Enum as String representing the type of Bank Operation

  Valid values are: `Type.Deposit`, `Type.Withdrawal` `Type.TransferIssued` `Type.TransferReceived`
  """

  use EnumType

  @typedoc """
  Bank Operations

  Valid values are: `Type.Deposit`, `Type.Withdrawal` `Type.TransferIssued` `Type.TransferReceived`
  or "DEPOSIT", "WITHDRAWAL", "TRANSFER_ISSUED", "TRANSFER_RECEIVED"
  """
  @type t :: String.t()

  defenum Type do
    value(Deposit, "DEPOSIT")
    value(Withdrawal, "WITHDRAWAL")
    value(TransferIssued, "TRANSFER_ISSUED")
    value(TransferReceived, "TRANSFER_RECEIVED")
  end
end
