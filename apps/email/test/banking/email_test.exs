defmodule Banking.EmailTest do
  use ExUnit.Case
  doctest Banking.Email

  test "greets the world" do
    assert Banking.Email.hello() == :world
  end
end
