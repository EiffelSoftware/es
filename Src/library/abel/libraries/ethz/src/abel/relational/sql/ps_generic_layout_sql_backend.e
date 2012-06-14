note
	description: "Summary description for {PS_GENERIC_LAYOUT_SQL_BACKEND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_GENERIC_LAYOUT_SQL_BACKEND
inherit
	PS_BACKEND_STRATEGY
	PS_GENERIC_LAYOUT_SQL_STRINGS

create make

feature {PS_EIFFELSTORE_EXPORT}-- Supported collection operations

	is_objectoriented_collection_store_supported:BOOLEAN = False
			-- Can the current backend handle relational collections?

	is_relational_collection_store_supported:BOOLEAN = False
			-- Can the current backend handle relational collections?

feature {PS_EIFFELSTORE_EXPORT} -- Status report

	can_handle_type (type: PS_TYPE_METADATA) : BOOLEAN
			-- Can the current backend handle objects of type `type'?
		do
			Result:= True
		end

	can_handle_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA): BOOLEAN
			-- Can the current backend handle the relational collection between the two classes `owner_type' and `collection_type'?
		do
			Result:= False
		end

	can_handle_objectoriented_collection (collection_type: PS_TYPE_METADATA): BOOLEAN
			-- Can the current backend handle an objectoriented collection of type `collection_type'?
		do
			Result:= False
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object retrieval operations


	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		-- Retrieves all objects of class `type' (direct instance - not inherited from) that match the criteria in `criteria' within transaction `transaction'.
		-- If `attributes' is not empty, it will only retrieve the attributes listed there.
		-- If an attribute was `Void' during an insert, or it doesn't exist in the database because of a version mismatch, the attribute value during retrieval will be an empty string and its class name `NONE'.

		-- If `type' has a generic parameter, the retrieve function will return objects of all generic instances of the generating class.
		-- You can find out about the actual generic parameter by comparing the class name associated to a foreign key value.
		local
			connection:PS_SQL_CONNECTION_ABSTRACTION
			current_obj: PS_RETRIEVED_OBJECT
			result_list: LINKED_LIST[PS_RETRIEVED_OBJECT]
			row_cursor: ITERATION_CURSOR[PS_SQL_ROW_ABSTRACTION]
			sql_string: STRING
		do
--			print ("retrieving " + type.class_of_type.name + "%N")
			connection:= get_connection (transaction)

			create result_list.make

			sql_string:= Current.query_values_from_class (db_metadata_manager.key_of_class (type.class_of_type.name, connection))
			if not transaction.is_readonly then
				sql_string.append (" FOR UPDATE")
			end
			connection.execute_sql (sql_string)
			from row_cursor:= connection.last_result
			until row_cursor.after
			loop
				-- create new object
				create current_obj.make (row_cursor.item.get_value ("objectid").to_integer, type.class_of_type)
--				print (current_obj.class_metadata.name + current_obj.primary_key.out + "%N")
				-- fill all attributes - The result is ordered by the object id, therefore the attributes of a single object are grouped together.
				from
				until
					row_cursor.after or else row_cursor.item.get_value ("objectid").to_integer /= current_obj.primary_key
				loop
					--print (current_obj.class_metadata.name + ": " + db_metadata_manager.attribute_name_of_key (row_cursor.item.get_value ("attributeid").to_integer) + "%N")
					current_obj.add_attribute (
						db_metadata_manager.attribute_name_of_key (row_cursor.item.get_value ("attributeid").to_integer), -- attribute_name
						row_cursor.item.get_value ("value"), -- value
						db_metadata_manager.class_name_of_key (row_cursor.item.get_value ("runtimetype").to_integer)) -- class_name_of_value
					row_cursor.forth
				end
				-- fill in Void attributes
				across type.attributes as attr loop
					if not current_obj.has_attribute (attr.item) then
						current_obj.add_attribute (attr.item, "", "NONE")
					end
				end


				result_list.extend (current_obj)
				-- do NOT go forth - we are already pointing to the next item, otherwise the inner loop would not have stopped.
			end
--			connection.commit
--			database.release_connection (connection)
			Result:= result_list.new_cursor
		end





	retrieve_from_keys (type: PS_TYPE_METADATA; primary_keys: LIST[INTEGER]; transaction:PS_TRANSACTION) : LINKED_LIST[PS_RETRIEVED_OBJECT]
		-- Retrieve all objects of type `type' and with primary key in `primary_keys'.
		local
			all_items: ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		do
			create Result.make
			-- Cheating a little ;-)
			all_items:= retrieve (type, create {PS_EMPTY_CRITERION}, create {LINKED_LIST [STRING]}.make, transaction)
			from
			until all_items.after
			loop
				if primary_keys.has (all_items.item.primary_key) then
					Result.extend (all_items.item)
				end
				all_items.forth
			end
		end




feature {PS_EIFFELSTORE_EXPORT} -- Object write operations

	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		local
			connection:PS_SQL_CONNECTION_ABSTRACTION
			new_primary_key: INTEGER
			none_class: INTEGER
			stub_attribute:INTEGER
		do
			-- Generate a new primary key in the database by inserting a stub attribute
--			connection:= database.acquire_connection
--			print ("insert " + an_object.object_id.metadata.class_of_type.name)
			connection:= get_connection (a_transaction)
			none_class:= db_metadata_manager.key_of_class ("NONE", connection)
			stub_attribute := db_metadata_manager.key_of_attribute ("stub", none_class, connection)
			connection.execute_sql ("INSERT INTO ps_value (attributeid, runtimetype, value) VALUES (" + stub_attribute.out+ ", " + none_class.out + ", 'STUB')")
			connection.execute_sql ("SELECT objectid FROM ps_value WHERE attributeid = " + stub_attribute.out + "  AND value = 'STUB'")
			new_primary_key:=connection.last_result.item.get_value_by_index (1).to_integer

			-- Insert the primary key to the key manager
			key_mapper.add_entry (an_object.object_id, new_primary_key, a_transaction)

			-- Write all attributes
			write_attributes (an_object, connection, a_transaction)

			-- Delete the stub argument
			connection.execute_sql ("DELETE FROM ps_value WHERE attributeid = " + stub_attribute.out + "  AND value = 'STUB'")
--			connection.commit
--			database.release_connection (connection)
		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		local
			connection:PS_SQL_CONNECTION_ABSTRACTION
		do
--			connection:= database.acquire_connection
			connection:= get_connection (a_transaction)
			write_attributes (an_object, connection, a_transaction)
--			connection.commit
--			database.release_connection (connection)
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		local
			connection:PS_SQL_CONNECTION_ABSTRACTION
			primary:INTEGER
		do
--			connection:= database.acquire_connection
			connection:= get_connection (a_transaction)
			primary:= key_mapper.primary_key_of (an_object.object_id, a_transaction).first
			key_mapper.remove_primary_key (primary, an_object.object_id.metadata, a_transaction)
			connection.execute_sql ("DELETE FROM ps_value WHERE objectid = " + primary.out)
--			connection.commit
--			database.release_connection (connection)
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object-oriented collection operations


	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_RETRIEVED_OBJECT_COLLECTION
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
		do
			check not_implemented: False end
			create Result.make (collection_primary_key, collection_type.class_of_type)
	 	end

	insert_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database. If the order is not conflicting with the items already in the database, it will try to preserve order.
		do
			check not_implemented: False end
		end

	delete_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		do
			check not_implemented: False end
		end


feature {PS_EIFFELSTORE_EXPORT}-- Relational collection operations


	retrieve_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA; owner_key: INTEGER; owner_attribute_name: STRING; transaction: PS_TRANSACTION) : PS_RETRIEVED_RELATIONAL_COLLECTION
			-- Retrieves the relational collection between class `owner_type' and `collection_item_type', where the owner has primary key `owner_key' and the attribute name of the collection inside the owner object is called `owner_attribute_name'
		do
			check not_implemented: False end
			create Result.make (owner_key, owner_type.class_of_type, owner_attribute_name)
		end


	insert_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		do
			check not_implemented: False end
		end


	delete_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		do
			check not_implemented: False end
		end

feature {PS_EIFFELSTORE_EXPORT} -- Transaction handling

	commit (a_transaction: PS_TRANSACTION)
		-- Tries to commit `a_transaction'. As with every other error, a failed commit will result in a new exception and the error will be placed inside `a_transaction'
		local
			connection: PS_SQL_CONNECTION_ABSTRACTION
		do
			connection:= get_connection (a_transaction)
			connection.commit
			database.release_connection (connection)
			release_connection (a_transaction)
			key_mapper.commit (a_transaction)
		end

	rollback (a_transaction: PS_TRANSACTION)
		-- Aborts `a_transaction' and undoes all changes in the database
		local
			connection: PS_SQL_CONNECTION_ABSTRACTION
		do
			connection:= get_connection (a_transaction)
			connection.rollback
			release_connection (a_transaction)
			key_mapper.rollback (a_transaction)
		end


feature {PS_EIFFELSTORE_EXPORT} -- Testing helpers

	wipe_out_data
		-- Wipe out all object data, but keep the metadata
		local
			connection:PS_SQL_CONNECTION_ABSTRACTION
		do
--			connection:= database.acquire_connection
			create key_mapper.make
			management_connection.execute_sql ("DELETE FROM ps_value")
--			connection.commit
--			database.release_connection (connection)
		end

	wipe_out_all
		-- Wipe out everything and initialize new.
		local
			connection:PS_SQL_CONNECTION_ABSTRACTION
		do
			from active_connections.start
			until active_connections.after
			loop
				active_connections.item.first.commit
				database.release_connection (active_connections.item.first)
				active_connections.remove
				print ("error: found active transaction")
			end
			connection:= management_connection -- database.acquire_connection
			connection.execute_sql ("DROP TABLE ps_value")
			connection.execute_sql ("DROP TABLE ps_attribute")
			connection.execute_sql ("DROP TABLE ps_class")


--			connection.commit
			database.release_connection (connection)
			make (database)
		end



feature {NONE} -- Implementation


	write_attributes (object: PS_SINGLE_OBJECT_PART; a_connection: PS_SQL_CONNECTION_ABSTRACTION; transaction: PS_TRANSACTION)
		local
			primary: INTEGER
			already_present_attributes: LINKED_LIST[INTEGER]
			runtime_type: INTEGER
			attribute_id:INTEGER
			value: STRING
			referenced_part: PS_OBJECT_GRAPH_PART
			collected_insert_statements: STRING
		do
			primary:= key_mapper.primary_key_of (object.object_id, transaction).first

			create already_present_attributes.make
			a_connection.execute_sql ("SELECT attributeid FROM ps_value WHERE objectid = " + primary.out)
			across a_connection as cursor loop
				already_present_attributes.extend (cursor.item.get_value_by_index (1).to_integer)
			end

			collected_insert_statements:= ""

			across object.attributes as current_attribute loop
				-- get the needed information
				referenced_part:= object.get_value (current_attribute.item)
				value:= referenced_part.storable_tuple (key_mapper.quick_translate (referenced_part.object_identifier, transaction)).first
				attribute_id:= db_metadata_manager.key_of_attribute (current_attribute.item, db_metadata_manager.key_of_class (object.object_id.metadata.class_of_type.name, a_connection), a_connection)
				runtime_type:= db_metadata_manager.key_of_class (referenced_part.storable_tuple (key_mapper.quick_translate (referenced_part.object_identifier, transaction)).second, a_connection)

				-- Perform update or insert, depending on the presence in the database
				if already_present_attributes.has (attribute_id) then
					-- Update
--					a_connection.execute_sql ("UPDATE ps_value SET runtimetype = " + runtime_type.out + ", value = '" + value + "' WHERE objectid = " + primary.out + " AND attributeid = "+ attribute_id.out)
					collected_insert_statements:= collected_insert_statements + "UPDATE ps_value SET runtimetype = " + runtime_type.out + ", value = '" + value + "' WHERE objectid = " + primary.out + " AND attributeid = "+ attribute_id.out + "; "
				else
					-- Insert
--					a_connection.execute_sql ("INSERT INTO ps_value (objectid, attributeid, runtimetype, value) VALUES ( " + primary.out + ", " + attribute_id.out + ", " + runtime_type.out + ", '" + value + "')")
					collected_insert_statements:= collected_insert_statements + "INSERT INTO ps_value (objectid, attributeid, runtimetype, value) VALUES ( " + primary.out + ", " + attribute_id.out + ", " + runtime_type.out + ", '" + value + "'); "
				end
			end
			if not collected_insert_statements.is_empty then
				a_connection.execute_sql (collected_insert_statements)
			end
		end


feature {NONE} -- Implementation - Connection and Transaction handling

	get_connection (transaction: PS_TRANSACTION): PS_SQL_CONNECTION_ABSTRACTION
		local
			new_connection: PS_PAIR[PS_SQL_CONNECTION_ABSTRACTION, PS_TRANSACTION]
			the_actual_result_as_detachable_because_of_stupid_void_safety_rule: detachable PS_SQL_CONNECTION_ABSTRACTION
		do
			if transaction.is_readonly then
				Result:= management_connection
			else
				across active_connections as cursor loop
					if cursor.item.second.is_equal (transaction) then
						the_actual_result_as_detachable_because_of_stupid_void_safety_rule:= cursor.item.first
	--					print ("found existing%N")
					end
				end

				if not attached the_actual_result_as_detachable_because_of_stupid_void_safety_rule then
					the_actual_result_as_detachable_because_of_stupid_void_safety_rule := database.acquire_connection
					create new_connection.make (the_actual_result_as_detachable_because_of_stupid_void_safety_rule, transaction)
					active_connections.extend (new_connection)
	--					print ("created new%N")
				end
				Result:= attach (the_actual_result_as_detachable_because_of_stupid_void_safety_rule)
			end
		end

	release_connection (transaction: PS_TRANSACTION)
		do
			from active_connections.start
			until active_connections.after
			loop
				if active_connections.item.second.is_equal (transaction) then
					database.release_connection (active_connections.item.first)
					active_connections.remove
--					print (i.out + "removed%N")
--					i:= i+1
				else
					active_connections.forth
				end
			end
		end
--	i:INTEGER

	active_connections: LINKED_LIST[PS_PAIR[PS_SQL_CONNECTION_ABSTRACTION, PS_TRANSACTION]]
		-- These are the normal connections attached to a transactions.
		-- They do not have auto-commit and they are closed once the transaction is finished.
		-- They only write to the ps_value table.

	management_connection: PS_SQL_CONNECTION_ABSTRACTION
		-- This is a special connection used for management and read-only transactions.
		-- It has isolation level `read-uncommited', uses auto-commit, and is always open.
		-- The connection can only write to ps_attribute and ps_class


feature{NONE} -- Initialization

	make (a_database: PS_SQL_DATABASE_ABSTRACTION)
		local
			initialization_connection: PS_SQL_CONNECTION_ABSTRACTION
		do
			database:= a_database
--			connection:= database.acquire_connection
			create key_mapper.make
			management_connection:=a_database.acquire_connection
			management_connection.execute_sql ("SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED")
			management_connection.execute_sql ("SET AUTOCOMMIT = 1")
			create db_metadata_manager.make (management_connection)
			--initialization_connection.commit
			--a_database.release_connection (initialization_connection)
			create active_connections.make
		end

	database: PS_SQL_DATABASE_ABSTRACTION

	db_metadata_manager: PS_GENERIC_LAYOUT_KEY_MANAGER

--	connection: PS_SQL_CONNECTION_ABSTRACTION

end

