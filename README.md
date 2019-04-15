# Banking Overview

[![CircleCI](https://circleci.com/gh/mbenatti/banking/tree/master.svg?style=svg)](https://circleci.com/gh/mbenatti/banking/tree/master)

Banking is a project that was built to test my skills, and a opportunity to use and test the latest dependencies(or packages) 
on Elixir ecosystem.

The project consists of a Banking Account service, accept the creation of accounts, deposit, withdrawal among other features 
as described on `Features` section.

The project was created under a Elixir Umbrella application, using [Postgres](https://www.postgresql.org/) to store the balance events, accounts and transactions,
with [Phoenix](https://phoenixframework.org/) providing the Rest API structure and [Docker](https://www.docker.com/) as a container that can be used on development.

## Features

* Authentication 
* Account Operations
		* Account Creation
		* Deposit, Withdrawal and Transference between accounts
		* Statement and Balance
* Back Office Operations
		* Daily, Monthly, Yearly and Total report (for Back Office)
* Email service integration
* Error and Logging service integration
* Continuous Integration
* Docker image for development

## Requirements

* Erlang/OTP 21 [erts-10.3]+
* Elixir 1.8.1+ (compiled with OTP 21)
* PostgreSQL 10.7+

(not tested on OTP 20 or others versions of elixir, but should work fine using the latest versions)

## Main Dependencies

- `Guardian` (for accounts) and `BasicAuth` (for backoffice) authentication
- `Phoenix` for the `api` `api.md` `api.html`
- `Timber` for error and logging service
- `Ecto` for database wrapper
- `Bamboo` for email service
- [Circle CI](https://circleci.com) for continuous integration

## Project Structure

The project was created using umbrella and consist into 5 apps with distinct's functions

* Model

	Contains the database operations like read and write, the schema definitions, database migrations, changeset 
	with validations and logic for change of the balance

* Accounts

	Logic segregation of bank account and their operations,
	serves as a bridge between the API and Model
	
* Backoffice

	Logic segregation of Back office and their operations,
	serves as a bridge between the API and Model
	
* Email

	Email Service Integration and email implementation

* API

	The Rest API, it calls functions from Accounts and Backoffice apps and not deal directly with Model or Email
	
## Unit Tests

The test's are made using [Ex_Unit](https://hexdocs.pm/ex_unit/ExUnit.html), also useful libraries like `Faker` and `ExMachina`

## Development tips / Setup

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

## Setup (Containerized with Docker)

1. Move into banking directory

2. Run docker-compose

```shell
$ docker-compose build
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

### Generating Docs Locally

1. Move into banking directory

2. Run 

```shell
$ mix docs
```

3. Html docs on `doc` folder

### Testing the routes

see `API` Page
