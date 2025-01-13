note
	description: "[
		The example below establishes a connection to a standalone server on localhost, registers the client application as 'connect-example', and performs a simple command.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=MongoDB Tutorial", "src=http://mongoc.org/libmongoc/current/tutorial.html", "protocol=uri"

class
	MONGODB_TUTORIAL


feature -- Tutorial

	test_server_description
		local
			l_client: MONGODB_CLIENT
			l_servers: LIST [MONGODB_SERVER_DESCRIPTION]
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")

			l_servers := l_client.server_descriptions
			across l_servers as ic  loop
				print ("%Ndescription_id: " + ic.item.description_id.out)
				print ("%Ndescription_type: " + ic.item.description_type)
				print ("%Nis_master: " + ic.item.is_master.bson_as_relaxed_extended_json)
				print ("%Nround_trip_time: " + ic.item.round_trip_time.out)
			end

		end

	test_create_read_concern
		local
			l_read_concern: MONGODB_READ_CONCERN
		do
				-- create a default read concern
			create l_read_concern.make
			print ("%NIs Default: " + l_read_concern.is_default.out)
			if attached l_read_concern.level as l_level then
				print ("%N Level: " + l_level)
			end
				-- set level to local
			l_read_concern.set_level ({MONGODB_EXTERNALS}.mongoc_read_concern_level_local)
			if attached l_read_concern.level as l_level then
				print ("%N Level: " + l_level)
			end

				-- set level to linearizable
			l_read_concern.set_level ({MONGODB_EXTERNALS}.mongoc_read_concern_level_linearizable)
				-- now it's not default.
			print ("%NIs Default: " + l_read_concern.is_default.out)

		end

	test_read_prefernces
		local
			l_client: MONGODB_CLIENT
			l_read_preference: MONGODB_READ_PREFERENCE
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")

			l_read_preference := l_client.read_preferences
			print ("%NMode Value: " + l_read_preference.mode.value.out)
			print ("%NTags:" + l_read_preference.tags.bson_as_relaxed_extended_json)
		end


	test_read_concern
		local
			l_client: MONGODB_CLIENT
			l_read_concern: MONGODB_READ_CONCERN
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")

			l_read_concern := l_client.read_concern

			print ("%NIs Default: " + l_read_concern.is_default.out)
			if attached l_read_concern.level as l_level then
				print ("%N Level: " + l_level)
			end
		end

	tutorial_find_databases_with_opts
		local
			l_client: MONGODB_CLIENT
			l_db_cursor: MONGODB_CURSOR
			l_end: BOOLEAN
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")

			l_db_cursor := l_client.find_databases_with_opts (Void)
			from
			until
				l_end
			loop
				if attached l_db_cursor.next as l_db_item then
					print (l_db_item.bson_as_relaxed_extended_json)
					io.put_new_line
				else
					l_end := True
				end
			end
		end

	tutorial_all_collections_in_a_database
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
			l_collection: MONGODB_COLLECTION
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")
			l_database := l_client.database ("db_name")
			across l_database.collection_names (VOID) as ic loop print (ic.item + "%N")  end

				-- create a new collection USING MONGODB_DATABASE
			l_collection := l_database.create_collection ("my_new_collection", Void)
			across l_database.collection_names (VOID) as ic loop print (ic.item + "%N")  end
		end


	tutorial_all_databases
		local
			l_client: MONGODB_CLIENT
			l_database_names: LIST [STRING]
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")
			l_database_names := l_client.database_names (Void)
			across l_database_names as ic loop print (ic.item + "%N")  end
		end

	tutorial_api
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
			l_collection: MONGODB_COLLECTION
			l_command: BSON
			l_reply: BSON
			l_insert: BSON
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")

		     	-- Register the application name so we can track it in the profile logs
		     	-- on the server. This can also be done from the URI (see other examples).
		    l_client.set_appname ("connect_example")

		    	-- Get a handle on the database "db_name" and collection "coll_name"
			l_database := l_client.database ("db_name")
			l_collection := l_client.collection ("db_name", "coll_name")

				-- Do work. This example pings the database, prints the result as JSON and
				-- performs an insert

			create l_command.make
			l_command.bson_append_integer_32 ("ping", 1)
			create l_reply.make
			l_client.command_simple ("db_name", l_command, Void, l_reply)

			if l_client.has_error then
				print ("%NOperation: l_client.command_simple " + l_collection.error_string)
			else
				print ("%N bson output: " +l_reply.bson_as_canonical_extended_json)
			end

			create l_insert.make
			l_insert.bson_append_utf8 ("hello", "world")

			l_collection.insert_one (l_insert, Void, Void)
			if l_collection.has_error then
				print ("%NOperation l_collection.insert_one " + l_collection.error_string)
			end

		end

	tutorial_externals
			-- test how to make a connection.
		local
			l_uri: C_STRING
			l_client: POINTER
				-- mongoc_client_t *
			l_appname: C_STRING
			l_res: BOOLEAN
			l_database: POINTER
				-- mongoc_database_t *
			l_collection: POINTER
				-- mongoc_collection_t *
			l_dbname: C_STRING
			l_coll_name: C_STRING
			l_command: BSON
			l_retval: BOOLEAN
			l_admin: C_STRING
			l_reply: BSON
			l_error: BSON_ERROR
			l_insert: BSON
			l_opts: BSON
		do
				-- Initialize libmongodb.
			{MONGODB_EXTERNALS}.c_mongoc_init

				-- Create a new client instance.
			create l_uri.make ("mongodb://localhost:27017")
			l_client := {MONGODB_EXTERNALS}.c_mongoc_client_new (l_uri.item)

				--
				--	Register the application name so we can track it in the profile logs
				--	on the server. This can also be done from the URI (see other examples).
			create l_appname.make ("connect-example")
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_appname (l_client, l_appname.item)

				-- Get a handle on the database "db_name" and collection "coll_name"
			create l_dbname.make ("db_name")
			l_database := {MONGODB_EXTERNALS}.c_mongoc_client_get_database (l_client, l_dbname.item);
			create l_coll_name.make ("coll_name")
			l_collection := {MONGODB_EXTERNALS}.c_mongoc_client_get_collection (l_client, l_dbname.item, l_coll_name.item)
			check l_collection /= default_pointer end

				-- Do work. This example pings the database, prints the result as JSON and
				-- performs an insert
			create l_command.make
			l_command.bson_append_integer_32 ("ping", 1)

			create l_reply.make
			create l_admin.make ("admin")
			create l_error.make
			l_retval := {MONGODB_EXTERNALS}.c_mongoc_client_command_simple (l_client, l_admin.item, l_command.item, default_pointer, l_reply.item, l_error.item)

			if not l_retval then
				print ({STRING_32}"%N Failure: " + l_error.message)
			else
				print ("%N bson output: " +l_reply.bson_as_canonical_extended_json)
			end


			create l_insert.make
			l_insert.bson_append_utf8 ("hello", "world")
			create l_error.make
			create l_opts.make
			l_retval := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_one (l_collection, l_insert.item, l_opts.item, default_pointer, l_error.item)

			if not l_retval then
				print ({STRING_32}"%N Failure: " + l_error.message)
			end
		end


feature -- Crud

	insert_document
		note
			EIS: "name=Insert a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#basic-crud-operations", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
		do
			create l_client.make ("mongodb://localhost:27017/?appname=insert-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_doc.make
			create l_oid.make (Void)
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "new eiffel")

			l_collection.insert_one (l_doc, Void, Void)
			if l_collection.has_error then
				print ("Last Operation l_collection.insert_one: " + l_collection.error_string)
			end

		end

	find_documents
		note
			EIS: "name=Find a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#finding-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_client.make ("mongodb://localhost:27017/?appname=find-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_query.make
			l_cursor := l_collection.find_with_opts (l_query, Void, Void)

			from
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					print (l_bson.bson_as_canonical_extended_json)
					print ("%N")
				else
					l_after := True
				end

			end
		end


	find_specific_document
		note
			EIS: "name=Find a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#finding-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_client.make ("mongodb://localhost:27017/?appname=find-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_query.make
			l_query.bson_append_utf8 ("hello", "eiffel")
			l_cursor := l_collection.find_with_opts (l_query, Void, Void)

			from
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					print (l_bson.bson_as_canonical_extended_json)
					print ("%N")
				else
					l_after := True
				end

			end
		end

	update_document
		note
			EIS: "name=Updating a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#updating-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_update: BSON
			l_query: BSON
			l_oid: BSON_OID
			l_subdoc: BSON
		do
			create l_client.make ("mongodb://localhost:27017/?appname=update-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_oid.make (Void)
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("key", "old_value")

			l_collection.insert_one (l_doc,Void, Void)

			create l_query.make
			l_query.bson_append_oid ("_id", l_oid)

			create l_subdoc.make
			l_subdoc.bson_append_utf8 ("key", "new_value")
			l_subdoc.bson_append_boolean ("updated", True)
			create l_update.make
			l_update.bson_append_document ("$set", l_subdoc)


			l_collection.update_one (l_query, l_update, Void, Void)
			if l_collection.has_error then
				print ("Last Operation : l_collection.update_one: " + l_collection.error_string)
			end

		end


	delete_document
		note
			EIS: "name=Deleting a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#deleting-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
		do
			create l_client.make ("mongodb://localhost:27017/?appname=delete-example")
			l_collection := l_client.collection ("test", "test")
			create l_oid.make (Void)
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "world")

			l_collection.insert_one (l_doc, Void, Void)
			if l_collection.has_error then
				print ("Last Operation : l_collection.insert_one: " + l_collection.error_string)
			end



			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_collection.delete_one (l_doc, Void, Void)
			if l_collection.has_error then
				print ("Last Operation : l_collection.delete_one: " + l_collection.error_string)
			end


		end


	count_documents
		note
			EIS: "name=Counting documents", "src=http://mongoc.org/libmongoc/current/tutorial.html#counting-documents", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_doc: BSON
			l_collection: MONGODB_COLLECTION
			l_count: INTEGER_64
		do
			create l_client.make ("mongodb://localhost:27017/?appname=delete-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_doc.make
			l_doc.bson_append_utf8 ("hello", "world")

			l_count := l_collection.count ((create {MONGODB_QUERY_FLAG}).mongoc_query_none, l_doc, 0, 0, Void)
			if l_count < 0 then
				print ("Error message: " + l_collection.error_string)
			else
				print ("Number of documents:" + l_count.out)
			end
		end

end
