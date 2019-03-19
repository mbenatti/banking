defmodule Banking.ModelTest do
  use ExUnit.Case
  doctest Banking.Model

  test "greets the world" do
    assert Banking.Model.hello() == :world
  end
end
