defmodule Banking.UtilsTest do
  @moduledoc false
  use ExUnit.Case

  alias Banking.Accounts.Utils
  doctest Utils

  @money "1.000.000,00"
  @d_money "1000000.00"

  test "success" do
    {:ok, decimal} = Utils.parse_to_decimal(@money)

    assert decimal == Decimal.new(@d_money)
  end
end
