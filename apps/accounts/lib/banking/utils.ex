defmodule Banking.Accounts.Utils do
  @moduledoc """
  Utilities for dealing with params on account operations
  """

  @doc """
  Parse giving string to decimal representing the money

  Valid`s inputs: ´1.000,00´, ´1000´, ´1000,00´
  Invalid`s: ´R$1000`, ´1000.00´

  ## Examples

      iex> Banking.Accounts.Utils.parse_to_decimal("100,000,00")
      {:error, "Please use valid money format! Examples: '1000,00' or '1.000.000,00'"}

  """
  @spec parse_to_decimal(String.t()) :: {:ok, Decimal.t()} | {:error, String.t()}
  def parse_to_decimal(money) do
    with money <- String.replace(money, ".", ""),
         money <- String.replace(money, ",", ".") do
      try do
        decimal = Decimal.new(money)
        {:ok, decimal}
      rescue
        _err -> {:error, "Please use valid money format! Examples: '1000,00' or '1.000.000,00'"}
      end
    end
  end
end
