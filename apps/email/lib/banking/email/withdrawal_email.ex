defmodule Banking.Email.WithdrawalEmail do
  @moduledoc """
  Contains specific functions to build and deliver a email for Withdrawal operation

  use `Bamboo` library to perform the email Feature

  see `email/2`
  """

  import Bamboo.Email

  alias Banking.Email.Mailer

  require Logger

  @doc """
  Build an email and delivery

  The email will be "delivered later" and do not block the current process

  ## Examples

      iex> Banking.Email.WithdrawalEmail.email("marcos@gmail.com","1000")
      {:ok,
      %Bamboo.Email{
       assigns: %{},
       attachments: [],
       bcc: [],
       cc: [],
       from: {nil, "no-reply@banking-dev.com"},
       headers: %{},
       html_body: "<strong>Your withdrawal of 1000 are being processed.\n</strong>",
       private: %{},
       subject: "Withdrawal Request.",
       text_body: "Your withdrawal of 1000 are being processed.\n",
       to: [nil: "marcos@gmail.com"]
      }}

      
  """
  @spec email(String.t(), Decimal.t() | String.t()) :: {:ok, Bamboo.Email.t()}
  def email(email_to, amount) do
    email_to
    |> build(amount)
    |> send_later()
  end

  defp build(email_to, amount) do
    new_email(
      to: email_to,
      from: get_email_from(),
      subject: "Withdrawal Request.",
      html_body: "<strong>" <> get_body(amount) <> "</strong>",
      text_body: get_body(amount)
    )
  end

  defp get_body(amount) do
    """
    Your withdrawal of #{amount} are being processed.
    """
  end

  defp send_later(email) do
    log_send(email.to, email.text_body)

    email = Mailer.deliver_later(email)

    {:ok, email}
  end

  defp log_send(to, content) do
    Logger.info("Sending Withdrawal email to #{to}, content: #{content}")
  end

  defp get_email_from() do
    Application.get_env(:email, :email_from)
  end
end
