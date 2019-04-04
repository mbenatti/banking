defmodule Banking.APIWeb.AccountView do
  use Banking.APIWeb, :view

  def render("create.json", %{account: account}) do
    %{
      account_id: account.id
    }
  end
end
