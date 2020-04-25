#!/bin/sh

cd ..

ENV=./.env
if ! test -f "$ENV"; then
  echo "Copying environement variables.."
  cp .env.example .env
fi

echo "Installing Composer dependencies.."
docker run --rm -v $(pwd):/app composer install

echo "Building Containers.."
docker-compose up --build -d

DATABASE=./ContainersConfig/mysql/databases/database_snapshot.sql
if test -f "$DATABASE"; then
  echo "Importing database.."
  docker-compose exec -T db mysql -u user --password=password project_db < ./ContainersConfig/mysql/databases/database_snapshot.sql
fi

echo "Installation complete"