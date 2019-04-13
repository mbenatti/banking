defmodule Banking.Email.WithdrawalEmailTest do
  @moduledoc false

  use ExUnit.Case

  alias Banking.Email.WithdrawalEmail

  describe "email/2" do
    test "success send email" do
      {:ok, email} = WithdrawalEmail.email("email@test.com", "1000.00")

      assert email.to == [nil: "email@test.com"]
      assert email.subject =~ "Withdrawal Request"
      assert email.html_body =~ "Your withdrawal of"
    end
  end
end
