FROM elixir:1.8.1

ENV DEBIAN_FRONTEND=noninteractive

# Install Deps
RUN apt-get update && \
  apt-get install -y build-essential inotify-tools libpq-dev

# Install Phoenix
RUN mix archive.install --force \
  https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# Installs hex locally
RUN mix local.hex --force

# Installs rebar locally
RUN mix local.rebar --force

RUN apt-get install -y -q inotify-tools

RUN mkdir -p /banking
ADD . /banking

WORKDIR /banking
RUN rm -rf ./deps

ENV MIX_ENV dev
ENV BANKING_DB_USER postgres
ENV BANKING_DB_PASS ""
ENV BANKING_DB_NAME banking_dev
ENV BANKING_DB_HOST postgres_db
#ENV BANKING_DB_POOL 10

RUN mix deps.get
RUN mix deps.compile

WORKDIR /banking
