defmodule Banking.Model.Balances.EventLoaderTest do
  @moduledoc """
  Tests for read operations on balances event
  """
  use Banking.Model.DataCase

  alias Banking.Model.Balances.{EventLoader, EventSchema}

  import Banking.Model.Factory

  describe("get event") do
    test "by id" do
      %EventSchema{id: id_inserted, balance: balance_inserted} =
        insert(:balances_event, balance: "10.0000")

      %EventSchema{id: id, balance: balance} = EventLoader.get(id_inserted)

      assert id_inserted == id
      assert balance_inserted == balance
    end

    test "last by client id" do
      %EventSchema{id: id_inserted, balance: balance_inserted, account_id: account_id} =
        insert(:balances_event, balance: "10.0000")

      %EventSchema{id: id, balance: balance} = EventLoader.get_last_event_by_account(account_id)

      assert id_inserted == id
      assert balance_inserted == balance
    end
  end
end
