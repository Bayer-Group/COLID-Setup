# Easy setup of the whole environment

The Setup is part of the Corporate Linked Data Catalog - short: COLID - application.
[Here](https://bayer-group.github.io/COLID-Documentation/#/?id=introduction) you can find an introduction to the application.
A description of all its functions is [here](https://bayer-group.github.io/COLID-Documentation/#/functional-specification).

The complete guide can be found at the following [link](https://bayer-group.github.io/COLID-Documentation/#/).

This repository helps settings up a local environment based on Docker Compose.

## Installation instructions

1. Install Docker Desktop for Windows from [Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-windows/) (latest test with Docker Desktop 4.21.1)
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
    MINIO_ACCESS_KEY=minio
    MINIO_SECRET_KEY=minio123
    MINIO_BUCKET_NAME=colid-files
    SMTP_USERNAME=any
    SMTP_PASSWORD=any
    ```
5. Run `docker-compose up` to download and build all Docker images and startup the environment
6. Wait for docker-compose to start up
7. Open the COLID Data Marketplace frontend (see URL below). Go to the profile menu in the upper right corner and click on "Administration". Open the Metadata Graph Configuration sub-menu page and click the "Start reindex" button in the upper right corner.


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
| KGE-Editor-Frontend                                      | http://localhost:4400/          | http://localhost:4400/          | -        | -        |
| KGE-Web-Service                                          | http://localhost:8080/          | http://localhost:8080/          | -        | -        |
| Resource Relationship Manager-Service                    | http://localhost:51830/         | http://localhost:51831/         | -        | -        |
| Resource Relationship Manager-Frontend                   | http://localhost:7000/          | http://localhost:7000/          | -        | -        |
| COLID API Carrot2 Service                                | http://localhost:4305/          | http://localhost:4305/          | -        | -        |
| Opensearch Dashboard                                     | http://localhost:5601/          | -                               | admin    | admin    |
| Minio Browser                                            | http://localhost:9001/          | -                               | minio    | minio123 |
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

### Opensearch & Kibana

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
## App-wide customization for URL Domain (Optional)
On the Semantic Web, URIs identify not just Web documents, but also real-world objects like people and cars, and even abstract ideas and non-existing things like a mythical unicorn. We call these real-world objects or things.
COLID uses the native *bayer.com* as default domain in each of its URI as the project was conceived for Bayer Ag. For example - https://pid.bayer.com/kos/19050/hasLabel

However you can also configure the custom domain in the URI if needed. In order to do that before building the docker containers, all the triples in the triplestore as well as the references to the URIs should be updated to use the custom domain. 
Multiple files references across the projects need to be changed from *bayer.com* to any custom specific domain - https://pid.orange.com/kos/19050/hasLabel
Details are mentioned below.<br>
| **File** 	| **Project** 	| **Variable** 	| **Comments** 	|
|---	|---	|---	|---	|
| [loader.sh](https://github.com/Bayer-Group/COLID-Setup/blob/master/fuseki-staging/loader.sh) 	| fuseki-staging 	| baseUrl 	| change baseUrl (example.com) as per your need in the shellscript before uploading triples 	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-AppData-Service/blob/54499e78b79a8e3e73155e5cc06f1d84b6970d1a/src/COLID.AppDataService.WebApi/appsettings.json) 	| AppData Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-Indexing-Crawler-Service/blob/974fc06f644c2526377252ee1d34430afe51dbaa/COLID.IndexingCrawlerService.WebApi/appsettings.json) 	| Indexing Crawler Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-Registration-Service/blob/3d33924b836b1d96453deeb622414513a3eaf664/src/COLID.RegistrationService.WebApi/appsettings.json) 	| Registration Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-Reporting-Service/blob/f21d73f6b6c28b2d5762fa196141c237e267c6f7/src/COLID.ReportingService.WebApi/appsettings.json) 	| Reporting Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-Search-Service/blob/4403a9c442f9d0b7d5db895513fd3286d4b63a6e/COLID.SearchService.WebApi/appsettings.json) 	| Search Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-Scheduler-Service/blob/1ccff502deff6925a9a90a26966de41597311496/src/COLID.Scheduler.Web/appsettings.json) 	| Scheduler Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [appsettings.json](https://github.com/Bayer-Group/COLID-ResourceRelationshipManager-Backend/blob/a8d590c0f87aeb9179619165ad3c9d634285f566/src/COLID.ResourceRelationshipManager/appsettings.json) 	| Resource Relationship Manager Backend Service 	| ServiceUrl,<br> HttpServiceUrl 	| change both variables as per your custom domain. <br> "ServiceUrl": "https://pid.example.com/",<br> "HttpServiceUrl": "http://pid.example.com/"	|
| [environment.ts](https://github.com/Bayer-Group/COLID-Editor-Frontend/blob/2ffad4bf96d8dc683ddc05ebebdc0ab4b1bf0b13/src/environments/environment.ts), [environment.docker.ts](https://github.com/Bayer-Group/COLID-Editor-Frontend/blob/2ffad4bf96d8dc683ddc05ebebdc0ab4b1bf0b13/src/environments/environment.docker.ts) 	| Editor Frontend | baseUrl, PidUriTemplate.baseUrl	| change baseUrl (example.com) in both sections as per your custom domain 	|
| [environment.ts](https://github.com/Bayer-Group/COLID-Data-Marketplace-Frontend/blob/f2ee9f3a66c13a7063b1fc78e7592d77b6314c61/src/environments/environment.ts), [environment.docker.ts](https://github.com/Bayer-Group/COLID-Data-Marketplace-Frontend/blob/f2ee9f3a66c13a7063b1fc78e7592d77b6314c61/src/environments/environment.docker.ts) 	| Data Marketplace Frontend | baseUrl	| change baseUrl (example.com) as per your custom domain 	|
| [environment.ts](https://github.com/Bayer-Group/COLID-ResourceRelationshipManager-Frontend/blob/master/projects/frontend/src/environments/environment.ts), [environment.docker.ts](https://github.com/Bayer-Group/COLID-ResourceRelationshipManager-Frontend/blob/master/projects/frontend/src/environments/environment.docker.ts) 	| Resource Relationship Manager Frontend | baseUrl	| change baseUrl (example.com) as per your custom domain 	|

### COLID: Carrot2 clustering service
Carrot2 clustering service is an opensource for clustering text. It can automatically discover groups of related documents and label them with short key terms or phrases. Please publish few resources in your local COLID Setup and then you can view the clusters in the Data Marketplace.
Refer link below for more details

### Minio and S3
The repository contains a local S3 bucket image for minio. If you want to use certain features such as 
exporting and importing excel. Please follow below steps
 - Make sure minio image is running
 - Browse to http://localhost:9001
 - Create Bucket 'colid-files'
 - Now you can use the Export and Import functionalities in Data Marketplace

### Links

- [Git Submodules](https://www.vogella.com/tutorials/GitSubmodules/article.html)
- [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [Apache Jena Fuseki tdbloader example](https://www.csee.umbc.edu/courses/graduate/691/spring14/01/examples/jena/README.txt)
- [wait-for-it Script](https://github.com/vishnubob/wait-for-it)
- [Carrot2](https://github.com/carrot2/carrot2)