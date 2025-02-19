# shared

This is the shared docker container for infrastructure build with environment-specific configurations for development, staging, and production.

## Features
- Environment-specific configuration (dev, sandbox, prod)
- Dockerized setup

## How to Run

### Local Development

```bash

docker network create shared-network
docker-compose -f docker-compose-shared.dev.yml build --no-cache  
docker-compose -f docker-compose-shared.dev.yml up --remove-orphans
```
- To reload the container without rebuilding: 
```bash
docker-compose -f docker-compose.dev.yml restart app
```

**Database**
A mongodb container is launched as part of the docker set up.

To access database commands in IDE:

Run the following (in this example it is mongodb-container (replace with relevant name if needed))
```bash
docker exec -it mongodb-container mongosh -u admin -p adminpassword
```

- Identify database container name.
```bash
docker ps
```
