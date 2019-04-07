defmodule Banking.Model.Factory do
  @moduledoc """
  Add support to use factory with ex_machina
  """

  use ExMachina.Ecto, repo: Banking.Model.Repo

  use Banking.Model.AccountFactory
  use Banking.Model.BalanceEventFactory
end
