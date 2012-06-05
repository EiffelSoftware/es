note
	description: "Abstraction of the actual DB backend and schema"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_BACKEND_STRATEGY

inherit
	PS_EIFFELSTORE_EXPORT


feature -- Status report

	can_handle_type (type: PS_TYPE_METADATA) : BOOLEAN
			-- Can the current backend handle objects of type `type'?
		do

		end

	can_handle_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA; owner_key: INTEGER; owner_attribute_name: STRING): BOOLEAN
			-- Can the current backend handle the relational collection denoted by the arguments?
		do
			Result:= is_relational_collection_store_supported and can_handle_type (owner_type) and can_handle_type (collection_item_type)
		end


	is_relational_collection_store_supported:BOOLEAN
			-- Can the current backend handle relational collections in a generic way?
		do

		end



	can_handle_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER): BOOLEAN
			-- Can the current backend handle the objectoriented collection denoted by the arguments?
		do
			Result:= is_objectoriented_collection_store_supported
		end


	is_objectoriented_collection_store_supported:BOOLEAN
			-- Can the current backend handle relational collections in a generic way?
		do

		end


feature -- Single object retrieval


	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
		-- Retrieves all objects of class `class_name' that match the criteria in `criteria' within transaction `transaction'.
		-- If `attributes' is not empty, it will only retrieve the attributes listed there.
		deferred
			-- TODO: to have lazy loading support, we need to have a special ITERATION_CURSOR and a function next in this class to load the next item of this customized cursor
		end


	retrieve_from_keys (type: PS_TYPE_METADATA; primary_keys: LIST[INTEGER]; transaction:PS_TRANSACTION) : LINKED_LIST[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
		-- Retrieve all objects of type `type' and with primary key in `primary_keys'.
		do
			create Result.make
		ensure
			primary_keys.count = Result.count
		end

feature -- Collection retrieval


	retrieve_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA; owner_key: INTEGER; owner_attribute_name: STRING; transaction: PS_TRANSACTION) : LIST[STRING]
			-- Retrieves the relational collection between class `owner_type' and `collection_item_type', where the owner has primary key `owner_key' and the attribute name of the collection inside the owner object is called `owner_attribute_name'
		do
			-- Note that the collection may be of a basic type - If the backend is not able to handle this, indicate it in the can_handle_relational_collection feature
			create {LINKED_LIST[STRING]}Result.make
		end

	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_PAIR [LIST[STRING],HASH_TABLE[STRING, STRING]]
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
			-- The result is a list of values in correct order, with string representation of either foreign keys  or just basic types - depending on the generic argument of the collection.
			-- The hash table in the result pair is the additional information required by the handler, as given by a previous insert function.
	 	deferred
			-- Note that the collection may be of a basic type - If the backend is not able to handle this, indicate it in the can_handle_relational_collection feature
	 	end


feature -- Single object write

	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		require
			mode_is_insert: an_object.write_mode = an_object.write_mode.insert
		deferred
		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		require
			mode_is_update: an_object.write_mode = an_object.write_mode.update
		deferred
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		require
			mode_is_delete: an_object.write_mode = an_object.write_mode.delete
		deferred
		end


feature -- Collection write


	insert_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
			is_relational: a_collection.handler.is_in_relational_storage_mode (a_collection)
		do
			a_collection.handler.insert (a_collection)
		end


	delete_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
			is_relational: a_collection.handler.is_in_relational_storage_mode (a_collection)
		do
			a_collection.handler.delete (a_collection)
		end


	insert_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
			objectoriented_mode: not a_collection.handler.is_in_relational_storage_mode (a_collection)
		deferred
		end

	delete_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
			objectoriented_mode: not a_collection.handler.is_in_relational_storage_mode (a_collection)
		deferred
		end



--	collection_handlers: LINKED_LIST[PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]]

	add_handler (a_handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]])
		do
--			collection_handlers.extend (a_handler)
		end


end
