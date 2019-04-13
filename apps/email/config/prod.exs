use Mix.Config

config :email, Banking.Email.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: Map.fetch!(System.get_env(), "SENDGRID_API_KEY")

config :email,
  email_from: Map.fetch!(System.get_env(), "BANKING_EMAIL_FROM")
