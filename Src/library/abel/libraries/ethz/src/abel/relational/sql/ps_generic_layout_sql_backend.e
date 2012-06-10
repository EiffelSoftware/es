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
			Result:= False
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
		do
			connection:= database.acquire_connection
			create result_list.make

			connection.execute_sql (Current.query_values_from_class (db_metadata_manager.key_of_class (type.class_of_type.name, connection)))
			from row_cursor:= connection.last_result
			until row_cursor.after
			loop
				-- create new object
				create current_obj.make (row_cursor.item.get_value ("objectid").to_integer, type.class_of_type)

				-- fill all attributes - The result is ordered by the object id, therefore the attributes of a single object are grouped together.
				from
				until
					row_cursor.after or else row_cursor.item.get_value ("objectid").to_integer /= current_obj.primary_key
				loop
					current_obj.add_attribute (
						db_metadata_manager.attribute_name_of_key (row_cursor.item.get_value ("attributeid").to_integer), -- attribute_name
						row_cursor.item.get_value ("value"), -- value
						db_metadata_manager.class_name_of_key (row_cursor.item.get_value ("runtimetype").to_integer)) -- class_name_of_value

					row_cursor.forth
				end

				result_list.extend (current_obj)
				-- do NOT go forth - we are already pointing to the next item, otherwise the inner loop would not have stopped.
			end
			database.release_connection (connection)
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
		do
			check not_implemented: False end
		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		do
			check not_implemented: False end
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		do
			check not_implemented: False end
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

feature{NONE} -- Initialization

	make (a_database: PS_SQL_DATABASE_ABSTRACTION)
		local
			initialization_connection: PS_SQL_CONNECTION_ABSTRACTION
		do
			database:= a_database
			create key_mapper.make
			initialization_connection:=a_database.acquire_connection
			create db_metadata_manager.make (initialization_connection)
			a_database.release_connection (initialization_connection)
		end

	database: PS_SQL_DATABASE_ABSTRACTION

	db_metadata_manager: PS_GENERIC_LAYOUT_KEY_MANAGER

end

