use Mix.Config

config :email, Banking.Email.Mailer, adapter: Bamboo.TestAdapter

config :email,
  email_from: "no-reply@banking-dev.com"
