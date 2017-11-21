# Set the Docker image you want to base your image off.
# I chose this one because it has Elixir preinstalled.
FROM trenpixster/elixir:1.4.0

# Setup Node - Phoenix uses the Node library `brunch` to compile assets.
# The official node instructions want you to pipe a script from the
# internet through sudo. There are alternatives:
# https://www.joyent.com/blog/installing-node-and-npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && apt-get install -y nodejs

# Install other stable dependencies that don't change often

# Compile app
RUN mkdir /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./
RUN MIX_ENV=prod mix local.rebar
RUN MIX_ENV=prod mix local.hex --force
RUN MIX_ENV=prod mix deps.get

# Install Node Deps
ADD package.json ./
RUN npm install

#Install and deal w/postgres (configure username/password to be like database)
#RUN sudo lsof -i :5432
#RUN sudo apt-get install -y postgresql postgresql-client
#RUN sudo service postgresql start
#RUN pg_lsclusters
#RUN pg_ctlcluster 9.3 main start
#RUN less /var/log/postgresql/postgresql-9.3-main.log
#linking here does not work
#RUN sudo ln -s /tmp/.s.PGSQL.5432 /var/run/postgresql/.s.PGSQL.5432
#RUN sudo rm /var/run/postgresql/.s.PGSQL.5432.lock
#RUN sudo service postgresql restart
#RUN sudo psql postgres -c "CREATE USER postgres;"
#RUN sudo psql postgres -c "ALTER USER postgres PASSWORD 'postgres';"
#RUN sudo /etc/init.d/postgresql restart


# Install app
ADD . .
RUN MIX_ENV=prod mix compile

# Compile assets
RUN NODE_ENV=prod node_modules/brunch/bin/brunch build --production
RUN MIX_ENV=prod mix phx.digest

# Exposes this port from the docker container to the host machine
EXPOSE 4000

# handle Ecto database (may not be needed)

#RUN MIX_ENV=prod mix ecto.drop
#RUN MIX_ENV=prod mix ecto.create
#RUN MIX_ENV=prod mix ecto.migrate


# The command to run when this image starts up
# CMD MIX_ENV=prod mix phx.server
CMD MIX_ENV=prod mix ecto.migrate && \
  MIX_ENV=prod mix phoenix.server
