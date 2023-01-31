# Elixir + Phoenix

FROM elixir:1.14.0

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install hex phx_new

# Install node
RUN apt-get remove --auto-remove nodejs-legacy
RUN apt-get -y purge libnode72
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install --yes nodejs

WORKDIR /app
EXPOSE 4000
