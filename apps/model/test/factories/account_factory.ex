defmodule Banking.Model.AccountFactory do
  @moduledoc """
  Factory to create a new account.

    import Banking.Model.Factory

    account = insert(:account)
  """

  alias Banking.Model.Accounts.AccountSchema

  defmacro __using__(_opts) do
    quote do
      def account_factory do
        %AccountSchema{
          name: Faker.Name.PtBr.name(),
          email: Faker.Internet.email(),
          password: Argon2.hash_pwd_salt(Faker.UUID.v4())
        }
      end
    end
  end
end
