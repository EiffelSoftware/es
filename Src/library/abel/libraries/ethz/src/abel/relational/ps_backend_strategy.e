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


feature {PS_EIFFELSTORE_EXPORT} -- Object retrieval operations


	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		-- Retrieves all objects of class `type' (direct instance - not inherited from) that match the criteria in `criteria' within transaction `transaction'.
		-- If `attributes' is not empty, it will only retrieve the attributes listed there.
		require
			most_general_type: across type.supertypes as supertype all not (supertype.item.class_of_type.name.is_equal (type.class_of_type.name) and type.is_subtype_of (supertype.item)) end
			all_attributes_exist: across attributes as attr all type.attributes.has (attr.item) end
		deferred
			-- TODO: to have lazy loading support, we need to have a special ITERATION_CURSOR and a function next in this class to load the next item of this customized cursor
		ensure
--			all_attributes_loaded: attributes.is_empty implies across type.attributes as cursor all Result.item.has_attribute (cursor.item) end -- TODO: except if version mismatch or Void references...
--			custom_attributes_loaded:not attributes.is_empty implies across attributes as cursor all Result.item.has_attribute (cursor.item) end-- TODO: except if version mismatch or Void references...
		end


	retrieve_from_keys (type: PS_TYPE_METADATA; primary_keys: LIST[INTEGER]; transaction:PS_TRANSACTION) : LINKED_LIST[PS_RETRIEVED_OBJECT]
		-- Retrieve all objects of type `type' and with primary key in `primary_keys'.
		deferred
		ensure
			primary_keys.count = Result.count
			across Result as res all res.item.class_metadata.name = type.class_of_type.name end
		end




feature {PS_EIFFELSTORE_EXPORT} -- Object write operations

	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		require
			mode_is_insert: an_object.write_mode = an_object.write_mode.insert
			not_yet_known: not key_mapper.has_primary_key_of (an_object.object_id)
		deferred
		ensure
			object_known: key_mapper.has_primary_key_of (an_object.object_id)
		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		require
			mode_is_update: an_object.write_mode = an_object.write_mode.update
			object_known: key_mapper.has_primary_key_of (an_object.object_id)
		deferred
		ensure
			object_still_known: key_mapper.has_primary_key_of (an_object.object_id)
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		require
			mode_is_delete: an_object.write_mode = an_object.write_mode.delete
			object_known: key_mapper.has_primary_key_of (an_object.object_id)
		deferred
		ensure
			not_known_anymore: not key_mapper.has_primary_key_of (an_object.object_id)
		end


feature {PS_EIFFELSTORE_EXPORT}-- Relational collection operations


	retrieve_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA; owner_key: INTEGER; owner_attribute_name: STRING; transaction: PS_TRANSACTION) : PS_RETRIEVED_RELATIONAL_COLLECTION
			-- Retrieves the relational collection between class `owner_type' and `collection_item_type', where the owner has primary key `owner_key' and the attribute name of the collection inside the owner object is called `owner_attribute_name'
		do
			-- Note that the collection may be of a basic type - If the backend is not able to handle this, indicate it in the can_handle_relational_collection feature
			create Result.make (owner_key, owner_type.class_of_type, owner_attribute_name)
		end


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




feature {PS_EIFFELSTORE_EXPORT} -- Object-oriented collection operations


	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_RETRIEVED_OBJECT_COLLECTION
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
	 	deferred
			-- Note that the collection may be of a basic type - If the backend is not able to handle this, indicate it in the can_handle_relational_collection feature
	 	end

	insert_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database. If the order is not conflicting with the items already in the database, it will try to preserve order.
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
			objectoriented_mode: not a_collection.handler.is_in_relational_storage_mode (a_collection)
			not_yet_known: not key_mapper.has_primary_key_of (a_collection.object_id)
		deferred
		ensure
--			collection_known: key_mapper.has_primary_key_of (a_collection.object_id)
		end

	delete_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
			objectoriented_mode: not a_collection.handler.is_in_relational_storage_mode (a_collection)
			collection_known: key_mapper.has_primary_key_of (a_collection.object_id)
		deferred
		ensure
			not_known_anymore: not key_mapper.has_primary_key_of (a_collection.object_id)
		end



feature

	key_mapper: PS_KEY_POID_TABLE

end
