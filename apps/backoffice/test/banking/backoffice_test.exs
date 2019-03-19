defmodule Banking.BackofficeTest do
  use ExUnit.Case
  doctest Banking.Backoffice

  test "greets the world" do
    assert Banking.Backoffice.hello() == :world
  end
end
