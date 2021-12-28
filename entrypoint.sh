#!/bin/bash

echo "Installing Hex and Rebar"
mix local.hex --force
mix local.rebar --force

echo "Installing dependencies"
mix deps.get
mix compile

echo "Trying to create database"
mix ecto.create

echo "Running migrations"
mix ecto.migrate

echo "Starting server"
exec mix phx.server