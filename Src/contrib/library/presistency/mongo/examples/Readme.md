# mongo-eiffel-driver

Status: under development.

# Installing the MongoDB C Driver

http://mongoc.org/libmongoc/current/installing.html

# Installing MongoDB

Tutorial: 
  * Windows: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/

  * Linux:   http://mongoc.org/libmongoc/current/installing.html#building-from-a-release-tarball

	
## Setting Up MongoDB with Docker Compose

This project uses Docker Compose to set up a MongoDB server and a Mongo Express client for easy database management. Follow the steps below to get started:

### Prerequisites

- Ensure you have Docker and Docker Compose installed on your machine. You can download them from [Docker's official website](https://www.docker.com/products/docker-desktop).


1. **Start the Services**

   Use Docker Compose to start the MongoDB server and Mongo Express client:

   ```bash
   docker-compose up -d
   ```

   The `-d` flag runs the containers in detached mode, allowing you to continue using your terminal.

2. **Access Mongo Express**

   Once the services are up and running, you can access the Mongo Express client in your web browser at:

   ```
   http://localhost:8081
   ```

   This interface allows you to manage your MongoDB databases easily.
   Credentials(admin, pass)

4. **Stop the Services**

   To stop the running services, use the following command:

   ```bash
   docker-compose down
   ```

   This will stop and remove the containers, but your data will persist in the `mongodb_data` volume.

### Configuration

- **MongoDB Server**: The MongoDB server is exposed on port `27017`.
- **Mongo Express**: The Mongo Express client is accessible on port `8081`.

### Volumes and Networks

- **Volumes**: The `mongodb_data` volume is used to persist MongoDB data.
- **Networks**: The `mongodb_network` is used to facilitate communication between the MongoDB server and the Mongo Express client.

For more information on Docker Compose, refer to the [official documentation](https://docs.docker.com/compose/).




