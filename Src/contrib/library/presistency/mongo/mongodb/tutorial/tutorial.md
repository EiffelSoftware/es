# Getting Started with MongoDB and Eiffel

This tutorial will show you how to use MongoDB with Eiffel, using our MongoDB and BSON wrappers around the MongoDB C Driver. We'll cover basic CRUD operations and demonstrate how to interact with MongoDB databases.

## Prerequisites

1. MongoDB 
2. The MongoDB C Driver installed on your system
   2.1 Cmake is required to build the driver from source.
3. The Eiffel MongoDB and BSON wrappers
4. EiffelStudio

# Installing MongoDB

## Installing the MongoDB C Driver

 https://www.mongodb.com/docs/languages/c/c-driver/current/get-started/download-and-install/

# Installing MongoDB

Tutorial: 
  * Windows: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/

  * Linux:   http://mongoc.org/libmongoc/current/installing.html#building-from-a-release-tarball

On Windows, we provide a pre-built MongoDB C driver for you. The driver is located in the `C\driver` folder of the MongoDB Eiffel wrapper.
Be sure to add the bin folder to your PATH environment variable.

We also provide an script in case you need to build the driver from source. `build_driver.bat`
First, download the source code from the MongoDB C Driver website: https://github.com/mongodb/mongo-c-driver
copy the `build_driver.bat` script to the root of the MongoDB C Driver source code and run it.
Copy the generated resources to the `C\driver` folder of the MongoDB Eiffel wrapper.
	
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



## Setting Up Your Project

First, create a new Eiffel project with the following ECF configuration:

```xml:tutorial.ecf
<?xml version="1.0" encoding="ISO-8859-1"?>
<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-23-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-23-0 http://www.eiffel.com/developers/xml/configuration-1-23-0.xsd" name="tutorial">
    <target name="tutorial" abstract="true">
        <file_rule>
			<exclude>/.svn$</exclude>
			<exclude>/CVS$</exclude>
			<exclude>/EIFGENs$</exclude>
		</file_rule>

        <option warning="warning">
            <assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
        </option>
        <setting name="console_application" value="true"/>
        <library name="base" location="$ISE_LIBRARY\library\base\base.ecf"/>
        <library name="bson" location="path_to_bson\bson.ecf"/>
        <library name="mongodb" location="path_to_mongodb\mongodb.ecf"/>
    </target>
</system>
```

## Basic Connection Example
In the folder where you created the tutorial.ecf file, create a new folder called `connection`.
Add the following files to the `connection` folder:
- application.e

Updated the tutorial.ecf file to include the `connection` target:

```xml:tutorial.ecf
<target name="connection" extends="tutorial">
    <root class="APPLICATION" feature="make"/>
    <cluster name="connection" location=".\connection" recursive="true"/>
</target>
``` 

Let's start with a simple example that connects to MongoDB and pings the server:

```eiffel:application.e
class
    APPLICATION

create
    make

feature {NONE} -- Initialization

    make
        local
            client: MONGODB_CLIENT
            uri: MONGODB_URI
            command, reply: BSON
        do
                -- Initialize MongoDB client with your connection string
            create uri.make ("mongodb://localhost:27017/?appname=eiffel-example")
            create client.make_from_uri (uri)

                -- Set error API version
            client.set_error_api (2)

                -- Create ping command
            create command.make
            command.bson_append_integer_32 ("ping", 1)

                -- Execute command
            create reply.make
            client.command_simple ("admin", command, Void, reply)

            if not client.has_error then
                print ("Server pinged successfully!%N")
                print ("Reply: " + reply.bson_as_json + "%N")
            else
                print ("Error: " + client.error_string + "%N")
            end
        end

end
```

## CRUD Operations

### Inserting Documents

Here's how to insert a document into a collection:
So, now we need to create a new folder called `insert` similar to the `connection` folder.
Add the following files to the `insert` folder:
- application.e

Updated the tutorial.ecf file to include the `insert` target:

```xml:tutorial.ecf
<target name="insert" extends="tutorial">
    <root class="APPLICATION" feature="make"/>
    <cluster name="insert" location=".\insert" recursive="true"/>
</target>
```

```eiffel
feature -- Insert Example

   make
        local
            client: MONGODB_CLIENT
            collection: MONGODB_COLLECTION
            doc: BSON
            reply: BSON
        do
            create client.make ("mongodb://localhost:27017")
            collection := client.collection ("test", "test")

                -- Create document
            create doc.make
            doc.bson_append_utf8 ("name", "Test Document")
            doc.bson_append_integer_32 ("age", 42)

                -- Insert document
            create reply.make
            collection.insert_one (doc, Void, reply)
            if not collection.has_error then
                print ("Document inserted successfully %N" + reply.bson_as_canonical_extended_json)
            else
                print ("Error: " + collection.error_string + "%N")
            end
        end
```

### Finding Documents

To query documents from a collection:

So, now we need to create a new folder called `find` similar to the `connection` folder.
Add the following files to the `find` folder:
- application.e

Updated the tutorial.ecf file to include the `find` target:

```xml:tutorial.ecf
<target name="find" extends="tutorial">
    <root class="APPLICATION" feature="make"/>
    <cluster name="find" location=".\find" recursive="true"/>
</target>
```

```eiffel
feature -- Find Example

    make
        local
            client: MONGODB_CLIENT
            collection: MONGODB_COLLECTION
            query: BSON
            cursor: MONGODB_CURSOR
            doc: detachable BSON
        do
            create client.make ("mongodb://localhost:27017")
            collection := client.collection ("test", "test")
            
            -- Create query
            create query.make
            
            -- Find all documents
            cursor := collection.find_with_opts (query, Void, Void)
            
            -- Iterate results
            from
                doc := cursor.next
            until
                doc = Void
            loop
                print (doc.bson_as_json + "%N")
                doc := cursor.next
            end
        end
```

### Updating Documents

To update existing documents:

So, now we need to create a new folder called `update` similar to the `connection` folder.
Add the following files to the `update` folder:
- application.e

Updated the tutorial.ecf file to include the `update` target:

```xml:tutorial.ecf
<target name="update" extends="tutorial">
    <root class="APPLICATION" feature="make"/>
    <cluster name="update" location=".\update" recursive="true"/>
</target>
```

```eiffel
feature -- Update Example

	make
		local
			client: MONGODB_CLIENT
			collection: MONGODB_COLLECTION
			query, update, subdoc: BSON
			error: BSON_ERROR
			oid: BSON_OID
			l_reply: BSON
		do
				-- Initialize client and collection
			create client.make ("mongodb://localhost:27017/?appname=update-example")
			collection := client.collection ("test", "test")

				-- First create a document to update
			create oid.make (Void)
			create query.make
			query.bson_append_oid ("_id", oid)
			query.bson_append_utf8 ("name", "Original Document")

				-- Insert the document
			create l_reply.make
			collection.insert_one (query, Void, l_reply)
			if not collection.has_error then
				print ("Document inserted successfully%N" + l_reply.bson_as_canonical_extended_json)

					-- Prepare update operation
				create subdoc.make
				subdoc.bson_append_utf8 ("name", "Updated Document")
				subdoc.bson_append_boolean ("updated", True)

				create update.make
				update.bson_append_document ("$set", subdoc)

					-- Update document
				collection.update_one (query, update, Void, l_reply)
				if not collection.has_error then
					print ("%NDocument updated successfully%N" + l_reply.bson_as_canonical_extended_json)
				else
					print ("Update error: " + collection.error_string + "%N")
				end
			else
				print ("Insert error: " + collection.error_string + "%N")
			end
		end

```

### Deleting Documents

To delete documents from a collection:

So, now we need to create a new folder called `delete` similar to the `connection` folder.
Add the following files to the `delete` folder:
- application.e

Updated the tutorial.ecf file to include the `delete` target:

```xml:tutorial.ecf
<target name="delete" extends="tutorial">
    <root class="APPLICATION" feature="make"/>
    <cluster name="delete" location=".\delete" recursive="true"/>
</target>
``` 

```eiffel
feature -- Delete Example

 make
        local
            client: MONGODB_CLIENT
            collection: MONGODB_COLLECTION
            query: BSON
            l_reply: BSON
        do
            create client.make ("mongodb://localhost:27017")
            collection := client.collection ("test", "test")

            	-- Create query to find document to delete
            create query.make
            query.bson_append_utf8 ("name", "Test Document")

            	-- Delete document
            create l_reply.make
            collection.delete_one (query, Void, l_reply)
            if not collection.has_error then
                print ("Document deleted successfully%N" + l_reply.bson_as_canonical_extended_json)
            else
                print ("Error: " + collection.error_string+ "%N")
            end
        end
```

## Further Reading

- [MongoDB C Driver Documentation](http://mongoc.org/libmongoc/current/)
- [MongoDB Manual](https://www.mongodb.com/docs/manual/)
- [MongoDB CRUD Operations](https://www.mongodb.com/docs/manual/crud/)