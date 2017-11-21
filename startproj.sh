#!/bin/bash
docker-compose build web
docker-compose run web mix deps.get
docker-compose run web mix ecto.create
docker-compose run web mix ecto.migrate
docker-compose run web npm install
docker-compose up
