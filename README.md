# Easy setup of the whole environment

The Setup is part of the Corporate Linked Data Catalog - short: COLID - application.
[Here](https://colid.pages.gitlab.bayer.com/docs/tech/#/?id=introduction) you can find an introduction to the application.
A description of all its functions is [here](https://colid.pages.gitlab.bayer.com/docs/tech/#/functional-specification).

The complete guide can be found at the following [link](https://bayer-group.github.io/colid-documentation).

This repository helps settings up a local environment based on Docker Compose.

## Installation instructions

1. Install Docker Desktop for Windows from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/) (latest test with Docker Desktop v2.2.0.3)
2. Clone this repository locally
    ```console
    git clone --recursive [URL to this Git repo]
    ```
3. Pull all changes in all submodules
    ```console
    git pull --recurse-submodules
    ```
4. Create a file `.env` in parallel to the file `docker-compose.yml` and insert the following variables (example values are shown):
    ```
    MESSAGEQUEUE_COOKIE=SWQOKODSQALRPCLNMEQG
    MESSAGEQUEUE_USERNAME=guest
    MESSAGEQUEUE_PASSWORD=guest
    GRAPHDATABASE_USERNAME=admin
    GRAPHDATABASE_PASSWORD=admin
    RELATIONAL_DATABASE_ROOT_PASSWORD=dbadminpass
    RELATIONAL_DATABASE_USERNAME=dbuser
    RELATIONAL_DATABASE_PASSWORD=dbpass
    SMTP_USERNAME=any
    SMTP_PASSWORD=any
    ```
5. Run `docker-compose up` to download and build all Docker images and startup the environment
6. Load the given Turtle files (*.ttl) to the Apache Jena Fuseki database via its webinterface (see table at the end of this document)

### Known problems

- While building the frontend the following error could occur. In the Dockerfiles of the frontend applications node is used with an increased heap size while building the applications `node --max_old_space_size=8000`. Try to increase this, if the error occurs.
    ```
    FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
    ```
- After starting the application a second time, the fuseki database could throw exceptions. Delete the Docker container of the fuseki database with `docker container rm fuseki`. ATTENTION: This will remove all your created data and reload the database with the initial data.

- fuseki-loader/loader.sh could contain `Carriage Return` characters, remove them.

## Application URLs

| Component                                                | URL for Docker environment      | URL for local environment       | Username | Password |
| -------------------------------------------------------- | ------------------------------- | ------------------------------- |--------- | -------- |
| COLID frontend                                           | http://localhost:4200/          | http://localhost:4201/          | -        | -        |
| Data Marketplace frontend                                | http://localhost:4300/          | http://localhost:4301/          | -        | -        |
| COLID API Swagger documentation                          | http://localhost:51770/swagger  | http://localhost:51771/swagger  | -        | -        |
| COLID Indexing Crawler Service API Swagger documentation | http://localhost:51780/swagger  | http://localhost:51781/swagger  | -        | -        |
| COLID Search Service API Swagger documentation           | http://localhost:51800/swagger  | http://localhost:51801/swagger  | -        | -        |
| COLID AppData Service API Swagger documentation          | http://localhost:51810/swagger  | http://localhost:51811/swagger  | -        | -        |
| COLID Scheduler Service Hangfire                         | http://localhost:51820/hangfire | http://localhost:51821/hangfire | -        | -        |
| COLID Reporting Service API Swagger documentation        | http://localhost:51910/swagger  | http://localhost:51911/swagger  | -        | -        |
| Apache Jena Fuseki Database Webinterface                 | http://localhost:3030/          | -                               | admin    | admin    |
| RabbitMQ Webinterface                                    | http://localhost:15672/         | -                               | guest    | guest    |

## Quick Tips

Some quick tips and advices to work faster.

### Docker

To purge all unused or dangling images, containers, volumes, and networks run the following command:
```console
docker system prune -a
```

To remove all containers:
```console
docker container rm $(docker container ls -aq)
```

### Elasticsearch & Kibana

- After starting the first time, some indices and aliases need to be created
- Open http://localhost:5601, go to the Dev Tools in the left panel, enter and run the following commands
    ```
    PUT dmp-resource-1970-01-01_00.00.00

    PUT dmp-metadata-1970-01-01_00.00.00
    {
        "mappings": {
            "enabled": false 
        }
    }

    POST /_aliases
    {
        "actions" : [
            { "add" : { "index" : "dmp-resource-1970-01-01_00.00.00", "aliases" : ["dmp-search-resource", "dmp-update-resource"] } },
            { "add" : { "index" : "dmp-metadata-1970-01-01_00.00.00", "aliases" : ["dmp-search-metadata", "dmp-update-metadata"] } }
        ]
    }
    ```

### Links

- [Git Submodules](https://www.vogella.com/tutorials/GitSubmodules/article.html)
- [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [Apache Jena Fuseki tdbloader example](https://www.csee.umbc.edu/courses/graduate/691/spring14/01/examples/jena/README.txt)
- [wait-for-it Script](https://github.com/vishnubob/wait-for-it)
