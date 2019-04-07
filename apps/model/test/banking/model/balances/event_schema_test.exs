defmodule Banking.Model.Balances.EventSchemaTest do
  @moduledoc """
  Tests validating the schema `t:Banking.Model.Balances.EventSchema.t/0` changeset
  """
  use Banking.Model.DataCase, async: true

  alias Banking.Model.Balances.EventSchema
  alias Banking.Model.Enums.BankOperationEnum.Type

  import Banking.Model.Factory

  describe("changeset/2") do
    test "valid changeset, sum the balance" do
      account = insert(:account)
      quantity_moved = 100
      params = %{quantity_moved: quantity_moved, account_id: account.id, type: Type.Deposit}

      %{changes: changes} = changeset = EventSchema.changeset(%EventSchema{}, params)

      assert changes.balance == Decimal.new(quantity_moved)
      assert changeset.valid? == true
      assert errors_on(changeset) == %{}
    end

    test "required field" do
      params = %{quantity_moved: 100}

      changeset = EventSchema.changeset(%EventSchema{}, params)

      expected = %{account_id: ["can't be blank"], type: ["can't be blank"]}

      assert changeset.valid? == false
      assert errors_on(changeset) == expected
    end

    test "balance with parent" do
      account = insert(:account)
      parent_qty = "50.0000"

      event =
        insert(:balances_event,
          account: account,
          account_id: account.id,
          quantity_moved: parent_qty,
          balance: parent_qty
        )

      event_qty = "10.0000"

      params = %{
        quantity_moved: event_qty,
        account_id: account.id,
        parent_id: event.id,
        type: Type.Deposit
      }

      %{changes: changes} = changeset = EventSchema.changeset(%EventSchema{}, params)

      assert changes.balance == Decimal.add(parent_qty, event_qty)
      assert changeset.valid? == true
      assert errors_on(changeset) == %{}
    end

    test "balance negative" do
      account = insert(:account)
      parent_qty = "50.0000"

      event =
        insert(:balances_event,
          account: account,
          account_id: account.id,
          quantity_moved: parent_qty,
          balance: parent_qty,
          type: Type.Deposit
        )

      event_qty = "100.0000"

      params = %{
        quantity_moved: event_qty,
        account_id: account.id,
        parent_id: event.id,
        type: Type.Withdrawal
      }

      changeset = EventSchema.changeset(%EventSchema{}, params)

      assert changeset.valid? == false

      assert errors_on(changeset) == %{balance: ["must be greater than or equal to 0"]}
    end
  end
end
