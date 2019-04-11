defmodule Banking.APIWeb.BackofficeController do
  @moduledoc """
  The controller containing the Backoffice operations

  The operation`s are executed by a logged user/pass using basic_auth.

  There are four types of reports

  - Daily Report (see `daily_report/2`)
  - Monthly Report (see `monthly_report/2`)
  - Yearly Report (see `yearly_report/2`)
  - Total Report (see `total_report/2`)
  """

  use Banking.APIWeb, :controller

  alias Banking.Backoffice.Reports

  action_fallback(Banking.APIWeb.FallbackController)

  @doc """
  Get Daily reports

  The report will be generated as json with a list of withdrawal`s, deposit`s and transference`s
  issued and received, grouped by Day, and the date representing the day.

  see `Banking.Backoffice.Reports.daily/0`
  """
  @spec daily_report(Conn.t(), Map.t()) :: Plug.Conn.t()
  def daily_report(conn, _) do
    with daily_report <- Reports.daily() do
      json(conn, daily_report)
    end
  end

  @doc """
  Get Monthly reports

  The report will be generated as json with a list of withdrawal`s, deposit`s and transference`s
  issued and received, grouped by Month, and the date representing the Month.

  see `Banking.Backoffice.Reports.monthly/0`
  """
  @spec monthly_report(Conn.t(), Map.t()) :: Plug.Conn.t()
  def monthly_report(conn, _) do
    with daily_report <- Reports.monthly() do
      json(conn, daily_report)
    end
  end

  @doc """
  Get Yearly reports

  The report will be generated as json with a list of withdrawal`s, deposit`s and transference`s
  issued and received, grouped by Year, and the date representing the year.

  see `Banking.Backoffice.Reports.yearly/0`
  """
  @spec yearly_report(Conn.t(), Map.t()) :: Plug.Conn.t()
  def yearly_report(conn, _) do
    with daily_report <- Reports.yearly() do
      json(conn, daily_report)
    end
  end

  @doc """
  Get Total Report

  The report will be generated as json with withdrawal`s, deposit`s and transference`s
  issued and received, the total sum of these operations.

  see `Banking.Backoffice.Reports.total/0`
  """
  @spec total_report(Conn.t(), Map.t()) :: Plug.Conn.t()
  def total_report(conn, _) do
    with daily_report <- Reports.total() do
      json(conn, daily_report)
    end
  end
end
