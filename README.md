[![CircleCI](https://circleci.com/gh/mbenatti/banking/tree/master.svg?style=svg)](https://circleci.com/gh/mbenatti/banking/tree/master)


## Requirements

* Erlang/OTP 21 [erts-10.3]+
* Elixir 1.8.1+ (compiled with OTP 21)
* PostgreSQL 10.7+

(not tested on OTP 20 or others versions of elixir, but should work fine using the latest versions)

## Setup

1. Install dependencies

```shell
$ mix deps.get
```

2. Setup database (creation & migrations)

```shell
$ mix ecto.create
$ mix ecto.migrate
```

3. Run application

```shell
$ mix phx.server
```

4. Application are running on localhost:4000

## Setup (With Docker)

1. Move into banking directory

2. Run docker-compose

```shell
$ docker-compose up
```

3. Application are running on localhost:4000

## Tests

1. Create database

```shell
$ MIX_ENV=test mix ecto.create
$ MIX_ENV=test mix ecto.migrate
```

2. Execute the test

```shell
$ mix test
```

### Static analysis tool

[Dialyzer](http://erlang.org/doc/man/dialyzer.html) Dialyzer is a static analysis tool that identifies software discrepancies
[Dialyxir](https://github.com/jeremyjh/dialyxir)

```Shell
$ mix dialyzer
```

### Static code analysis

[Credo](https://github.com/rrrene/credo) Credo is a static code analysis tool for the Elixir language with a focus on teaching and code consistency.                                         

```Shell
$ mix credo
```

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