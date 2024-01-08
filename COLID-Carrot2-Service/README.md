# COLID: Carrot2 clustering service
Carrot2 clustering service is an opensource for clustering text. It can automatically discover groups of related documents and label them with short key terms or phrases.
Reffer site for more details: https://github.com/carrot2/carrot2

## How to deploy in local Docker Desktop
# Step1
Clone this repository to the docker setup folder. 

This repoistory consits of two file
1) A zip file containing the Carrot2 application
2) Docker file which contains commands to unzip the above setup file and deploy the application 

# Step2
Copy this to dockercompose.yaml file
```yaml
colid-api-carrot2-service:
    container_name: colid-api-carrot2-service
    build:
      context: ./colid-api-carrot2-service
      dockerfile: Dockerfile
    volumes:
      - ./carrot2:/var/local/Config/
    ports:
      - 7000:8080
    networks:
      - backend
```

# Step3
Open command prompt, set your directory to the setup folder (containing the dockercompose.yaml and the colid-api-carrot2-service folder)
and run:
```yaml
docker-compose up --build colid-api-carrot2-service
```
![image](https://github.com/bayer-int/colid-api-carrot2-service/assets/125270530/9bfc8654-09f4-4fd7-adbe-253e3bb4d13e)

## Get Started
Now carrot 2 service will be available at
```yaml
http://localhost:7000/service/openapi/swagger/index.html
```

to use this service from inside the container (from another application deployed in the same network within DockerDesktop)
use url:
```yaml
http://colid-api-carrot2-service:8080/service
```
