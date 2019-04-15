defmodule Banking.APIWeb.TransactionController do
  @moduledoc """
  Routes implementation for Bank Account Transaction's

  All Operations are executed on a private/logged API, so the Account `id` are in the connection.
  Contains five operations, and two main groups of operation:

  Money input/output:
  - Deposit (see `deposit/2`)
  - Withdrawal (see `withdrawal/2`)
  - Transfer (see `transfer/2`)

  Bank Account statement's:
  - Bank Account Statement (see `statement/2`)
  - Bank Account Balance (see `balance/2`)

  Money format accepted in BRL format, examples: `1.000,00` or `1000` or `1000,00`

  Wrong way: Using dot as pennies `1000.00` Will be parsed as: `100.000,00`(Representing BRL format)

  """

  use Banking.APIWeb, :controller

  alias Banking.Accounts.Transactions.{Statement, Deposit, Withdrawal, Transfer}
  alias Banking.Accounts.Utils
  alias Plug.Conn

  action_fallback(Banking.APIWeb.FallbackController)

  @doc """
  Bank Account Deposit

  Parse the amount and create a Deposit.

  For more information see:
  `Banking.Accounts.Transactions.Deposit`
  `Banking.Accounts.Utils.parse_to_decimal/1`

  ## Parameters

      - conn: The connection
      - params: The params provided by user containing the `amount` to be deposited
  """
  @spec deposit(Conn.t(), Map.t()) :: Plug.Conn.t()
  def deposit(conn, %{"amount" => amount}) do
    with {:ok, decimal} <- Utils.parse_to_decimal(amount),
         account <- get_current_account(conn),
         {:ok, _} <- Deposit.create(account.id, decimal) do
      render(conn, "show.json", message: "Deposit created")
    end
  end

  def deposit(_conn, _) do
    {:error, :invalid_request}
  end

  @doc """
  Bank Account Withdrawal

  Parse the amount and create a Withdrawal.

  For more information see:
  `Banking.Accounts.Transactions.Withdrawal`
  `Banking.Accounts.Utils.parse_to_decimal/1`

  ## Parameters

      - conn: The connection
      - params: The params provided by user containing the `amount` to be withdrawal
  """
  @spec withdrawal(Conn.t(), Map.t()) :: Plug.Conn.t()
  def withdrawal(conn, %{"amount" => amount}) do
    with {:ok, decimal} <- Utils.parse_to_decimal(amount),
         account <- get_current_account(conn),
         {:ok, _} <- Withdrawal.create(account.id, decimal) do
      render(conn, "show.json", message: "Withdrawal created")
    end
  end

  def withdrawal(_conn, _) do
    {:error, :invalid_request}
  end

  @doc """
  Bank Account Transference

  Parse the amount and create a Transfer using the account provided as ´username´.

  For more information see:
  `Banking.Accounts.Transactions.Transfer`
  `Banking.Accounts.Utils.parse_to_decimal/1`

  ## Parameters

      - conn: The connection
      - params: The params provided by user containing the `amount` to be withdrawal
  """
  @spec transfer(Conn.t(), Map.t()) :: Plug.Conn.t()
  def transfer(conn, %{"username" => username, "amount" => amount}) do
    with {:ok, decimal} <- Utils.parse_to_decimal(amount),
         account <- get_current_account(conn),
         {:ok, _} <- Transfer.create(account.id, username, decimal) do
      render(conn, "show.json", message: "Transference successful")
    end
  end

  def transfer(_conn, _) do
    {:error, :invalid_request}
  end

  @doc """
  Get Bank Account Current Balance

  For more information see:
  `Banking.Accounts.Transactions.Statement.get_balance/1`

  ## Parameters

      - conn: The connection
      - params: empty
  """
  @spec balance(Conn.t(), Map.t()) :: Plug.Conn.t()
  def balance(conn, _) do
    with account <- get_current_account(conn),
         %{balance: balance} <- Statement.get_balance(account.id) do
      render(conn, "show.json", message: "Balance: #{balance}")
    end
  end

  @doc """
  Get Bank Account Statement

  For more information see:
  `Banking.Accounts.Transactions.Statement.get/1`

  The return are parsed on `Banking.APIWeb.TransactionView`

  ## Parameters

      - conn: The connection
      - params: empty
  """
  @spec statement(Conn.t(), Map.t()) :: Plug.Conn.t()
  def statement(conn, _) do
    with account <- get_current_account(conn),
         statement <- Statement.get(account.id) do
      render(conn, "show.json", statement: statement)
    end
  end

  defp get_current_account(%{assigns: %{current_client: account}}) do
    account
  end
end
