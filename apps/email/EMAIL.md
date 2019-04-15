# Email

The APP `email` feature email integration provided by `bamboo`

## Bamboo

- Adapter based so it can be used with Mandrill, SMTP, Sendgrid whatever else you want. Comes with a Mandrill adapter out of the box.
- Deliver emails in the background. Most of the time you don’t want or need to wait for the email to send. Bamboo makes it easy with Mailer.deliver_later

## Email App

With bamboo we can easily send email's, the current implemented email is the withdrawal email
look at `Banking.Email.WithdrawalEmail`

see [Bamboo](https://hexdocs.pm/bamboo/readme.html)