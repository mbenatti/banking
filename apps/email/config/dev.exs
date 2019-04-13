use Mix.Config

config :email, Banking.Email.Mailer, adapter: Bamboo.LocalAdapter

config :email,
  email_from: "no-reply@banking-dev.com"
