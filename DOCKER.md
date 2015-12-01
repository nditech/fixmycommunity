# Docker Compose for Fix My Street

## Prerequisites
* Docker Engine [Ubuntu](https://docs.docker.com/installation/ubuntulinux/),[Mac OS X](https://docs.docker.com/installation/mac) or [Windows](https://docs.docker.com/installation/windows)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Overview
In preparation for deployment of [Fix My Street](http://fixmystreet.org), we decided it would be a great idea to standardize the production environment. To ease this process, we ended up using Docker and Docker Compose.

* Docker is "an open-source project that automates the deployment of applications inside software containers." Essentially, Docker runs a processes from within a container that includes all dependencies the process needs to run. This allows containers to run almost anywhere. For example, you may have a container for running PostgreSQL.

Note: Unfortunately, [you can't run Docker natively in OS X](https://docs.docker.com/installation/mac/), as explained in the Docker documentation

* Docker Compose "allows you to define an application’s components – their containers, configuration, links and volumes – in a single file. Then a single command will set everything up and start your application running." For example, you may use Docker Compose to bundle a web server container and a PostgreSQL container

## Customizing FixMyStreet

Customizing FixMyStreet configuration settings you specify in the `app/general.yml` file prior to a build of the docker image. You can read the documentation on [Customizing FixMyStreet](http://fixmystreet.org/customising/).

## Configure Nginx

Configure Nginx listen for your domain name in the `nginx/sites-enables/fixmystreet` file. Change the `server_name` to your domain name.

## Configure Database

The `db.env` are the environment variables for the database. Update the environment variable with `DB_USER`, `DB_PASS` and `DB_NAME`. Changes made here must correspond with the `app/general.yml` file for lines 17-21.

* Note: Changes made to Nginx and App (FixMyStreet) configuration or customization files will require a rebuild of the docker image using `docker-compose build`

## Usage

### Start Docker Compose
```
docker-compose up -d
```

There are two Dockerfiles `app` and `nginx` which are built using the `docker-compose build` command. Each Dockerfile can be built individually. The Dockerfiles are built initially when the `docker-compose up -d` command was executed. The Dockerfiles must be rebuilt when changes are made to the files within each of their directory paths.
```
docker-compose build
```

To build a specific Dockerfile use the following
```
docker-compose build <name>
```

Example
```
docker-compose build app
```

The Docker microservices has database container `dalekurt/postgres`. To pull the Docker images

```
docker-compose pull
```

## Import Database Schema
Your docker container are now running, let's impose the database schema to the docker container running the Postgres database. Using the container ID run the following command

`docker exec -it <CID> /tmp/install-database.sh`

You should see the result of the database schema.

Now open your browser to your URL



