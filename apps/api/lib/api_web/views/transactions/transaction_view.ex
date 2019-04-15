defmodule Banking.APIWeb.TransactionView do
  @moduledoc false
  use Banking.APIWeb, :view

  alias Banking.Model.Enums.BankOperationEnum.Type

  def render("show.json", %{message: msg}) do
    %{
      message: msg
    }
  end

  def render("show.json", %{statement: statement}) do
    statement =
      Enum.map(statement, fn %{
                               balance: balance,
                               type: type,
                               trade: trade,
                               quantity: quantity,
                               date: date
                             } ->
        %{
          date: to_string(date),
          description: build_description(trade.account, trade.transfer_account, type, quantity),
          amount: to_string(quantity),
          balance: to_string(balance),
          type: type.value
        }
      end)

    %{statement: statement}
  end

  defp build_description(acc, _, type, amount) when type == Type.Deposit,
    do: "Deposit of #{amount} on #{acc}"

  defp build_description(acc, _, type, amount) when type == Type.Withdrawal,
    do: "Withdrawal of #{amount} on #{acc}"

  defp build_description(acc, transfer_acc, type, amount) when type == Type.TransferIssued,
    do: "Transference issued of #{amount} from #{acc} to #{transfer_acc}"

  defp build_description(acc, transfer_acc, type, amount) when type == Type.TransferReceived,
    do: "Transference received of #{amount} from #{transfer_acc} to #{acc}"
end
