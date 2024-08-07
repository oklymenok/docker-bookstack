# Ubuntu Dockerfile for BookStack

Quickly written Dockerfile for BookStack ( similar to mediawiki ) framework. I've also added docker-compose to spin up dependencies like MySQL and split PHP fpm and Nginx into different containers.

# How to use

* Point example.com to 127.0.0.1 via local hosts file
* Build docker images:
```
docker-compose build php
docker-compose build nginx
```
* Start containers:
```
docker-compose up -d
```
* Shell into one of the containers and apply migrations to deploy DB:
```
docker exec -ti docker-bookstack_php_1 /bin/bash
cd /var/www/html/BookStack/
php artisan migrate
```
* Access web app by:
127.0.0.1:8080/

* Login with:
```
admin@admin.com
password
```

* Upload to AWS ECR repo
```
docker buildx build . --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/bookstack/prod/nginx:latest --push
docker buildx build . --platform linux/amd64 -t ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/bookstack/prod/php:latest --push
```
