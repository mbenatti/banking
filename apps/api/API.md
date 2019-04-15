# API

The API was built using the `Phoenix` Framework and is a place to receive request's and 
expose routes for our service.

The `API` app does not contains any logic about operations, all logic is delegated to `accounts` or `backoffice` project,
it has one purpose to expose routes, handle request/resposes/errors and authentication

# Main Features

- `Guardian` for bank account authentication `BasicAuth` for backoffice Authentication
- `Plug` for build composable modules for authentication and others, used on Routes
- All Errors are centralized on a `Banking.APIWeb.FallbackController` module, using `Phoenix.Controller.action_fallback/1` feature

## Resources

* [Guardian](https://github.com/ueberauth/guardian) is a token based authentication library for use with Elixir applications.
* [Plug](https://github.com/elixir-plug/plug) is a specification and conveniences for composable modules between web applications

### Accounts auth

The account authentication is powered by `Guardian`. 

In any case the user send their ID to handle their own operations, 
all operations use the current assigned `id` on the `Plug.Connection` provided 
by features implemented on this project:

* A `Plug` to ensure authentication on the `API`, ref: `Banking.APIWeb.Pipeline.Auth`
* A `Plug` to load and assign the current client to the `Plug.Connection`, ref: `Banking.APIWeb.Plugs.CurrentClient`

### Backoffice auth

The backoffice authentication is powered by `BasicAuth` the default user/password is:

	admin/admin.p4ss

## Avaliable routes

			account_path  POST  /api/registration          Banking.APIWeb.AccountController :create
				 auth_path  POST  /api/auth                  Banking.APIWeb.AuthController :create
	transaction_path  POST  /api/priv/deposit          Banking.APIWeb.TransactionController :deposit
	transaction_path  POST  /api/priv/withdrawal       Banking.APIWeb.TransactionController :withdrawal
	transaction_path  POST  /api/priv/transfer         Banking.APIWeb.TransactionController :transfer
	transaction_path  GET   /api/priv/balance          Banking.APIWeb.TransactionController :balance
	transaction_path  GET   /api/priv/statement        Banking.APIWeb.TransactionController :statement
	 backoffice_path  GET   /api/admin/report/daily    Banking.APIWeb.BackofficeController :daily_report
	 backoffice_path  GET   /api/admin/report/monthly  Banking.APIWeb.BackofficeController :monthly_report
	 backoffice_path  GET   /api/admin/report/yearly   Banking.APIWeb.BackofficeController :yearly_report
	 backoffice_path  GET   /api/admin/report/total    Banking.APIWeb.BackofficeController :total_report
	 
		 
### Tips/Examples for testing routes with command line

- For these examples I used `httpie`
 see <https://httpie.org/>

#### User Bank Account

1. Show the routes

```shell
$ mix phx.routes Banking.APIWeb.Router
```

2. Creating an user

```shell

$ http post localhost:4000/api/registration name=Marcos email=marcos@email.com password=12345678
```

3. Auth (get a token for the others operations)

```shell
$ http post localhost:4000/api/auth username=marcos@email.com password=12345678             
```

4. Deposit 

```shell
$ http post localhost:4000/api/priv/deposit amount=1.000.000 'Authorization:Bearer <YOUR-TOKEN-HERE>'
```

5. Withdrawal

```shell
$ http post localhost:4000/api/priv/withdrawal amount=200.000,00 'Authorization:Bearer <YOUR-TOKEN-HERE>'
```

6. Transfer (account for transference must be created first)

```shell
$ http post localhost:4000/api/priv/transfer amount=300.000,00 username=marcos2@email.com 'Authorization:Bearer <YOUR-TOKEN-HERE>'
```

7. Balance

```shell
$ http get localhost:4000/api/priv/balance  'Authorization:Bearer <YOUR-TOKEN-HERE>'
```

8. Statement

```shell
$ http get localhost:4000/api/priv/statement  'Authorization:Bearer <YOUR-TOKEN-HERE>'
```

#### Admin Reports

1. Daily report

```shell
$ http  get admin:admin.p4ss@localhost:4000/api/admin/report/daily
```

2. Monthly report

```shell
$ http  get admin:admin.p4ss@localhost:4000/api/admin/report/monthly
```

3. Yearly report

```shell
$ http  get admin:admin.p4ss@localhost:4000/api/admin/report/yearly
```

4. Total report

```shell
$ http  get admin:admin.p4ss@localhost:4000/api/admin/report/total
```