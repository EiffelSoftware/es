note
	description: "An ESCHER extension to ABEL. Adds a version attribute to inserted objects, and checks on this version during retrieval."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_ESCHER_INTEGRATION

inherit
	PS_BACKEND_STRATEGY
		redefine key_mapper end

create
	make

feature {NONE} -- Initialization

	make (real: PS_BACKEND_STRATEGY)
			-- Initialization for `Current'.
		local
			factory:PS_METADATA_FACTORY
		do
			real_backend:= real
			create factory.make
			integer_metadata:=factory.create_metadata_from_type ({INTEGER})
		end

	real_backend:PS_BACKEND_STRATEGY

	integer_metadata: PS_TYPE_METADATA

--	schema_evolution_handlers_table: DS_HASH_TABLE[SCHEMA_EVOLUTION_HANDLER,STRING]


feature {PS_EIFFELSTORE_EXPORT}-- Supported collection operations

	is_objectoriented_collection_store_supported:BOOLEAN
			-- Can the current backend handle relational collections?
		do
			Result:= real_backend.is_objectoriented_collection_store_supported
		end

	is_relational_collection_store_supported:BOOLEAN
			-- Can the current backend handle relational collections?
		do
			Result:= real_backend.is_relational_collection_store_supported
		end

feature {PS_EIFFELSTORE_EXPORT} -- Status report

	can_handle_type (type: PS_TYPE_METADATA) : BOOLEAN
			-- Can the current backend handle objects of type `type'?
		do
			Result:= real_backend.can_handle_type (type)
		end

	can_handle_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA): BOOLEAN
			-- Can the current backend handle the relational collection between the two classes `owner_type' and `collection_type'?
		do
			Result:= real_backend.can_handle_relational_collection (owner_type, collection_item_type)
		end

	can_handle_objectoriented_collection (collection_type: PS_TYPE_METADATA): BOOLEAN
			-- Can the current backend handle an objectoriented collection of type `collection_type'?
		do
			Result:= real_backend.can_handle_objectoriented_collection (collection_type)
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object retrieval operations


	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		-- Retrieves all objects of class `type' (direct instance - not inherited from) that match the criteria in `criteria' within transaction `transaction'.
		-- If `attributes' is not empty, it will only retrieve the attributes listed there.
		-- If an attribute was `Void' during an insert, or it doesn't exist in the database because of a version mismatch, the attribute value during retrieval will be an empty string and its class name `NONE'.

		-- If `type' has a generic parameter, the retrieve function will return objects of all generic instances of the generating class.
		-- You can find out about the actual generic parameter by comparing the class name associated to a foreign key value.
		local
			result_list:LINKED_LIST[PS_RETRIEVED_OBJECT]
			reflection: INTERNAL
			type_instance:ANY
			current_version, stored_version:INTEGER
			error: PS_VERSION_MISMATCH
		do
			create reflection
			type_instance:= reflection.new_instance_of (type.type.type_id)

			if  attached {VERSIONED_CLASS} type_instance as versioned_object then

				current_version:= versioned_object.version
				check version_positive: current_version > 0 end

				-- Collect the results
				from
					create result_list.make
					if attributes.is_empty then
						attributes.append (type.attributes)
					end
					attributes.extend ("version")
					Result:= real_backend.retrieve (type, criteria, attributes, transaction)
				until
					Result.after
				loop
					result_list.extend (Result.item)
					Result.forth
				end

				-- Check for each result if the version matchs
				across result_list as cursor loop

					stored_version:= cursor.item.attribute_value ("version").value.to_integer

					if stored_version /= current_version then
						create error
						transaction.set_error (error)
						error.raise
					end
					-- Remove version attribute, as it is in theory not an object attribute
					cursor.item.remove_attribute ("version")
				end

				Result:= result_list.new_cursor

				-- Required because of postcondition...
				attributes.compare_objects
				attributes.prune ("version")

			else
				Result:= real_backend.retrieve (type, criteria, attributes, transaction)
			end
		end



	retrieve_from_keys (type: PS_TYPE_METADATA; primary_keys: LIST[INTEGER]; transaction:PS_TRANSACTION) : LINKED_LIST[PS_RETRIEVED_OBJECT]
		-- Retrieve all objects of type `type' and with primary key in `primary_keys'.
		local
			reflection: INTERNAL
			type_instance:ANY
			res_cursor: ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		do
			create reflection
			type_instance:= reflection.new_instance_of (type.type.type_id)

			if  attached {VERSIONED_CLASS} type_instance as versioned_object then

				-- Use the retrieve function for checking
				from
					create Result.make
					res_cursor:= real_backend.retrieve (type, create {PS_EMPTY_CRITERION}, create {LINKED_LIST[STRING]}.make, transaction)
				until
					res_cursor.after
				loop
					if primary_keys.has (res_cursor.item.primary_key) then
						Result.extend (res_cursor.item)
					end
					res_cursor.forth
				end
			else
				Result:= real_backend.retrieve_from_keys (type, primary_keys, transaction)
			end
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object write operations

	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		local
			stored_version:INTEGER
			version_attribute: PS_BASIC_ATTRIBUTE_PART
		do
			if attached {VERSIONED_CLASS} an_object.represented_object as versioned_object then
				stored_version:= versioned_object.version
				if simulate_version_mismatch then
					stored_version:= stored_version - 1
				end
				create version_attribute.make (stored_version, integer_metadata, an_object.root)
				an_object.add_attribute ("version", version_attribute)

				real_backend.insert (an_object, a_transaction)

				an_object.attributes.prune ("version") -- to satisfy postcondition
				an_object.attribute_values.remove ("version")
			else
				real_backend.insert (an_object, a_transaction)
			end

		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		do
			real_backend.update (an_object, a_transaction)
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		do
			real_backend.delete (an_object, a_transaction)
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object-oriented collection operations

	retrieve_all_collections (collection_type: PS_TYPE_METADATA; transaction:PS_TRANSACTION): ITERATION_CURSOR[PS_RETRIEVED_OBJECT_COLLECTION]
			-- Retrieves all collections of type `collection_type'.
	 	do
	 		Result:= real_backend.retrieve_all_collections (collection_type, transaction)
	 	end


	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_RETRIEVED_OBJECT_COLLECTION
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
	 	do
	 		Result:= real_backend.retrieve_objectoriented_collection (collection_type, collection_primary_key, transaction)
	 	end

	insert_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database. If the order is not conflicting with the items already in the database, it will try to preserve order.
		do
			real_backend.insert_objectoriented_collection (a_collection, a_transaction)
		end

	delete_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		do
			real_backend.delete_objectoriented_collection (a_collection, a_transaction)
		end

feature {PS_EIFFELSTORE_EXPORT}-- Relational collection operations


	retrieve_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA; owner_key: INTEGER; owner_attribute_name: STRING; transaction: PS_TRANSACTION) : PS_RETRIEVED_RELATIONAL_COLLECTION
			-- Retrieves the relational collection between class `owner_type' and `collection_item_type', where the owner has primary key `owner_key' and the attribute name of the collection inside the owner object is called `owner_attribute_name'
		do
			Result:= real_backend.retrieve_relational_collection (owner_type, collection_item_type, owner_key, owner_attribute_name, transaction)
		end


	insert_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		do
			real_backend.insert_relational_collection (a_collection, a_transaction)
		end


	delete_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		do
			real_backend.delete_relational_collection (a_collection, a_transaction)
		end


feature {PS_EIFFELSTORE_EXPORT} -- Transaction handling

	commit (a_transaction: PS_TRANSACTION)
		-- Tries to commit `a_transaction'. As with every other error, a failed commit will result in a new exception and the error will be placed inside `a_transaction'
		do
			real_backend.commit (a_transaction)
		end

	rollback (a_transaction: PS_TRANSACTION)
		-- Aborts `a_transaction' and undoes all changes in the database
		do
			real_backend.rollback (a_transaction)
		end


	transaction_isolation_level: PS_TRANSACTION_ISOLATION_LEVEL
		-- The currently active transaction isolation level
		do
			Result:= real_backend.transaction_isolation_level
		end

	set_transaction_isolation_level (a_level: PS_TRANSACTION_ISOLATION_LEVEL)
		-- Set the transaction isolation level `a_level' for all future transactions
		do
			real_backend.set_transaction_isolation_level (a_level)
		end

feature {PS_EIFFELSTORE_EXPORT} -- Mapping

	key_mapper: PS_KEY_POID_TABLE
		-- Maps POIDs to primary keys as used by this backend
		do
			Result:= real_backend.key_mapper
		end

feature -- Testing

	set_simulation (switch:BOOLEAN)
		-- Enable or disable the testing simulation
		do
			simulate_version_mismatch:= switch
		end

	simulate_version_mismatch:BOOLEAN
		-- Insert a wrong version on purpose for testing

end
