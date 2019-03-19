defmodule Banking.AccountsTest do
  use ExUnit.Case
  doctest Banking.Accounts

  test "greets the world" do
    assert Banking.Accounts.hello() == :world
  end
end
