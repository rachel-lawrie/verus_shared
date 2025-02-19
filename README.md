# shared


This is the shared docker container for infrastructure build with environment-specific configurations for development, staging, and production.

## Features
- Environment-specific configuration (dev, sandbox, prod)
- Dockerized setup
- Makefile for easier development

## How to Run

### Local Development

The following enables local development changes without having to rebuild Docker, while continuing to use the Docker MongoDB instance.

1. First build Docker containers

```bash
docker network create shared-network
docker-compose -f docker-compose-shared.dev.yml build --no-cache 
docker-compose -f docker-compose-shared.dev.yml up --remove-orphans
```
2. Go into Docker and stop running the app container.

3. Change host name in dev.yaml file to "localhost" 
```
host: localhost
```
 
### Development on Docker
```bash

docker network create shared-network
docker-compose -f docker-compose-shared.dev.yml build --no-cache  
docker-compose -f docker-compose-shared.dev.yml up --remove-orphans
```
- To reload the container without rebuilding: 
```bash
docker-compose -f docker-compose.dev.yml restart app
```

- **Database**
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

- To test that correct data was loaded, ensure data in the following:
```bash
use dev_db
db.client_secrets_table.find().pretty()
```

- If the data does not show, the script may not be executable. Run the following and then rebuild. 
```bash
chmod +x scripts/mongo-init-dev.sh
```

- To export updates to database
```bash
docker exec mongodb-container mongodump \
  --username admin \
  --password adminpassword \
  --authenticationDatabase admin \
  --out /data/dump
```

```bash
docker cp mongodb-container:/data/dump ./dump
```

This saves the data in the dump folder. Then save your code and commmit to git. When someone else creates a docker container, the compose file updates database instance with latest data from dump folder.

### Sandbox
Live instance running on an AWS server. Subdomain set up through porkbun to redirect api.staging.verus.inc to the server IP. Endpoints are in format: https://api.staging.verus.inc/api/v1/.

To update code, merge code to Github. A secret key is required to ssh into server. Populate one in the AWS portal and store it as ~/.ssh.sandbox-server-key.pem To connect to the server run:
```
ssh -i ~/.ssh/sandbox-server-key.pem ubuntu@34.229.138.192
```

Go into relevant folder on server. Pull code: 
```
GIT_SSH_COMMAND="ssh -i /home/ubuntu/.ssh/github_sandbox_key" git pull origin main
```

Then run:
```
docker compose -f docker-compose.sandbox.yml down
docker system prune -f
docker compose -f docker-compose-shared.sandbox.yml build --no-cache
docker compose -f docker-compose-shared.sandbox.yml up --remove-orphans
```

- **Database**
Hosted MongoDB Atlas, connected to the app through URI.

- **Changes**
Code is automatically updated when a change to the Main Github branch is made. To make code changes, merge code into Main and the docker containers will rebuild with the latest code. A repository secret holds the key to access the server as the ubuntu user.

To make server changes - a secret key is required. Populate one in the AWS portal and store it as ~/.ssh.sandbox-server-key.pem To connect to the server run: ssh -i ~/.ssh/sandbox-server-key.pem ubuntu@34.229.138.192.

- **Monitoring**
Access grafana using: https://api.sandbox.verus.inc/grafana. 


 ## Metrics
MongoDB Exporter Metrics [http://localhost:9216/metrics](http://localhost:9216/metrics)  

### Prometheus
Query: [http://localhost:9090/query](http://localhost:9090/query)
Rules: [http://localhost:9090/rules](http://localhost:9090/rules)
Alerts: [http://localhost:9090/alerts](http://localhost:9090/alerts)

### Grafana

Grafana: [http://localhost:3000](http://localhost:3000)  
**Username:** `admin`  
**Password:** `admin`

If you would like to update the Docker environment with any changes to dashboards:  

1. Download the JSON file of the dashboard you changed.  
2. Add it as a file in `docker/dashboards/<table_name.json>`.

