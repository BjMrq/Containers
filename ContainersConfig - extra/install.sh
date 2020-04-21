#!/bin/sh

cd ..
cp .env.example .env
docker run --rm -v $(pwd):/app composer install
docker-compose up --build -d
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed