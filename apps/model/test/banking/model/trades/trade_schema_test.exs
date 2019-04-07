defmodule Banking.Model.Trades.TradeSchemaTest do
  @moduledoc """
  Tests validating the `t:Banking.Model.Trades.TradeSchema.t/0` changeset
  """
  use Banking.Model.DataCase, async: true

  alias Banking.Model.Trades.TradeSchema
  alias Banking.Model.Enums.BankOperationEnum.Type

  import Banking.Model.Factory

  describe("changeset/2") do
    test "valid changeset" do
      event = insert(:balances_event)

      params = %{
        quantity: event.quantity_moved,
        account_id: event.account_id,
        balance_event_id: event.id
      }

      changeset = TradeSchema.changeset(%TradeSchema{}, params, Type.Deposit)

      assert changeset.valid? == true
      assert errors_on(changeset) == %{}
    end

    test "required fields" do
      event = insert(:balances_event)

      params = %{
        balance_event_id: event.id
      }

      changeset = TradeSchema.changeset(%TradeSchema{}, params, Type.Deposit)

      assert changeset.valid? == false

      assert errors_on(changeset) == %{
               account_id: ["can't be blank"]
             }
    end

    test "success validate transfer_account_id " do
      event =
        insert(:balances_event,
          quantity_moved: 100,
          balance: 100
        )

      account_to_transfer = insert(:account)

      params = %{
        account_id: event.account_id,
        balance_event_id: event.id
      }

      params_transfer = %{
        account_id: event.account_id,
        transfer_account_id: account_to_transfer.id,
        balance_event_id: event.id
      }

      valid_deposit = TradeSchema.changeset(%TradeSchema{}, params, Type.Deposit)
      valid_withdrawal = TradeSchema.changeset(%TradeSchema{}, params, Type.Withdrawal)

      valid_transfer_issued =
        TradeSchema.changeset(%TradeSchema{}, params_transfer, Type.TransferIssued)

      valid_transfer_received =
        TradeSchema.changeset(%TradeSchema{}, params_transfer, Type.TransferReceived)

      assert valid_deposit.valid? == true
      assert valid_withdrawal.valid? == true
      assert valid_transfer_issued.valid? == true
      assert valid_transfer_received.valid? == true
    end

    test "fail validate transfer_account_id " do
      event =
        insert(:balances_event,
          quantity_moved: 100,
          balance: 100
        )

      account_to_transfer = insert(:account)

      params = %{
        account_id: event.account_id,
        balance_event_id: event.id
      }

      params_transfer = %{
        account_id: event.account_id,
        transfer_account_id: account_to_transfer.id,
        balance_event_id: event.id
      }

      invalid_deposit = TradeSchema.changeset(%TradeSchema{}, params_transfer, Type.Deposit)
      invalid_withdrawal = TradeSchema.changeset(%TradeSchema{}, params_transfer, Type.Withdrawal)
      invalid_transfer_issued = TradeSchema.changeset(%TradeSchema{}, params, Type.TransferIssued)

      invalid_transfer_received =
        TradeSchema.changeset(%TradeSchema{}, params, Type.TransferReceived)

      assert invalid_deposit.valid? == false
      assert invalid_withdrawal.valid? == false
      assert invalid_transfer_issued.valid? == false
      assert invalid_transfer_received.valid? == false

      assert errors_on(invalid_deposit) == %{
               transfer_account_id: ["Deposit or Withdrawal do not have Transfer account."]
             }

      assert errors_on(invalid_withdrawal) == %{
               transfer_account_id: ["Deposit or Withdrawal do not have Transfer account."]
             }

      assert errors_on(invalid_transfer_issued) == %{
               transfer_account_id: ["Transfers must have a Transfer account."]
             }

      assert errors_on(invalid_transfer_received) == %{
               transfer_account_id: ["Transfers must have a Transfer account."]
             }
    end
  end
end
