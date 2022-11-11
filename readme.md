# Goal
I've created with image to be easier for developers run unit/integration tests on your themes and plugins.

This image is based on WordPress 5.8

# How to use

https://hub.docker.com/repository/docker/emanuelxpt/wordpress-test
Configure on Docker-compose file

```yml
version: '3.4'
services:
  db:
    image: mysql
    environment:
      MYSQL_ROOT_PASSWORD: testdrive
      MYSQL_DATABASE: wordpress
      MYSQL_USER: user
      MYSQL_PASSWORD: password
  wordpresstests:
    image: emanuelxpt/wordpress-test
    environment:
      e__DB__host: db:3306
      e__DB__username: user
      e__DB__password: password
      e__DB__name: wordpress
    volumes:
    - ./theme:/theme
```


Execute docker compose
docker-compose up -d


enter inside the wordpress container using bash

# example
Run your tests using composer

```bash
 composer phpunit-tests
```

If you like or need more info please send email to dev@emanuellopes.pt
# wordpress-tests
