#!/bin/sh

cd ..

ENV=./.env
if ! test -f "$ENV"; then
  echo "Copying environement variables ⚙️"
  cp .env.example .env
fi


echo "Installing Composer dependencies 🛠"
docker run --rm -v $(pwd):/var/www --env COMPOSER_MEMORY_LIMIT=-1 \
  bjmrq/laravel:php-7.4 composer install

echo "Updating Composer 🔨"
docker run --rm -v $(pwd):/var/www --env COMPOSER_MEMORY_LIMIT=-1 \
  bjmrq/laravel:php-7.4 composer update


echo "Building Docker Containers 🐳"
cd ..
docker-compose up --build -d


cd app/
DATABASE=./ContainersConfig/mysql/databases/database_snapshot.sql
if test -f "$DATABASE"; then
  echo "Importing database 📥"
  docker-compose exec -T db mysql -u user --password=password project_db < ./ContainersConfig/mysql/databases/database_snapshot.sql
fi

echo "Installation complete 🚀"