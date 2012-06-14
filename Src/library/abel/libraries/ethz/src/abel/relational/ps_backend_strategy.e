note
	description: "Abstraction of the actual DB backend and schema"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_BACKEND_STRATEGY

inherit
	PS_EIFFELSTORE_EXPORT


feature {PS_EIFFELSTORE_EXPORT}-- Supported collection operations

	is_objectoriented_collection_store_supported:BOOLEAN
			-- Can the current backend handle relational collections?
		deferred
		end

	is_relational_collection_store_supported:BOOLEAN
			-- Can the current backend handle relational collections?
		deferred
		end

feature {PS_EIFFELSTORE_EXPORT} -- Status report

	can_handle_type (type: PS_TYPE_METADATA) : BOOLEAN
			-- Can the current backend handle objects of type `type'?
		deferred
		end

	can_handle_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA): BOOLEAN
			-- Can the current backend handle the relational collection between the two classes `owner_type' and `collection_type'?
		deferred
		end

	can_handle_objectoriented_collection (collection_type: PS_TYPE_METADATA): BOOLEAN
			-- Can the current backend handle an objectoriented collection of type `collection_type'?
		deferred
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object retrieval operations


	retrieve (type: PS_TYPE_METADATA; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_RETRIEVED_OBJECT]
		-- Retrieves all objects of class `type' (direct instance - not inherited from) that match the criteria in `criteria' within transaction `transaction'.
		-- If `attributes' is not empty, it will only retrieve the attributes listed there.
		-- If an attribute was `Void' during an insert, or it doesn't exist in the database because of a version mismatch, the attribute value during retrieval will be an empty string and its class name `NONE'.

		-- If `type' has a generic parameter, the retrieve function will return objects of all generic instances of the generating class.
		-- You can find out about the actual generic parameter by comparing the class name associated to a foreign key value.
		require
			most_general_type: across type.supertypes as supertype all not (supertype.item.class_of_type.name.is_equal (type.class_of_type.name) and type.is_subtype_of (supertype.item)) end
			all_attributes_exist: across attributes as attr all type.attributes.has (attr.item) end

		deferred
			-- TODO: to have lazy loading support, we need to have a special ITERATION_CURSOR and a function next in this class to load the next item of this customized cursor
		ensure
			attributes_loaded: not Result.after implies check_attributes_loaded (type, attributes, Result.item)
			class_metadata_set: not Result.after implies Result.item.class_metadata.name.is_equal (type.class_of_type.name)
		end




	retrieve_from_keys (type: PS_TYPE_METADATA; primary_keys: LIST[INTEGER]; transaction:PS_TRANSACTION) : LINKED_LIST[PS_RETRIEVED_OBJECT]
		-- Retrieve all objects of type `type' and with primary key in `primary_keys'.
		require
			keys_exist: TRUE --TODO across primary_keys as cursor all key_mapper.has_objects_of (cursor.item, type) end
		deferred
		ensure
		--	primary_keys.count = Result.count
			across Result as res all res.item.class_metadata.name = type.class_of_type.name end
		end




feature {PS_EIFFELSTORE_EXPORT} -- Object write operations

	insert (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Inserts the object into the database
		require
			mode_is_insert: an_object.write_mode = an_object.write_mode.insert
			not_yet_known: not key_mapper.has_primary_key_of (an_object.object_id, a_transaction)
			backend_can_handle_object: can_handle_type (an_object.object_id.metadata)
			dependencies_known: check_dependencies_have_primary (an_object, a_transaction)
		deferred
		ensure
			object_known: key_mapper.has_primary_key_of (an_object.object_id, a_transaction)
			check_successful_write (an_object, a_transaction)
		end

	update (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Updates an_object
		require
			mode_is_update: an_object.write_mode = an_object.write_mode.update
			object_known: key_mapper.has_primary_key_of (an_object.object_id, a_transaction)
			backend_can_handle_object: can_handle_type (an_object.object_id.metadata)
		deferred
		ensure
			object_still_known: key_mapper.has_primary_key_of (an_object.object_id, a_transaction)
			check_successful_write (an_object, a_transaction)
		end

	delete (an_object:PS_SINGLE_OBJECT_PART; a_transaction:PS_TRANSACTION)
		-- Deletes an_object from the database
		require
			mode_is_delete: an_object.write_mode = an_object.write_mode.delete
			object_known: key_mapper.has_primary_key_of (an_object.object_id, a_transaction)
			backend_can_handle_object: can_handle_type (an_object.object_id.metadata)
		deferred
		ensure
			not_known_anymore: not key_mapper.has_primary_key_of (an_object.object_id, a_transaction)
		end



feature {PS_EIFFELSTORE_EXPORT} -- Object-oriented collection operations


	retrieve_objectoriented_collection (collection_type: PS_TYPE_METADATA; collection_primary_key: INTEGER; transaction: PS_TRANSACTION): PS_RETRIEVED_OBJECT_COLLECTION
			-- Retrieves the object-oriented collection of type `object_type' and with primary key `object_primary_key'.
	 	require
	 		objectoriented_collection_operation_supported: is_objectoriented_collection_store_supported
	 		backend_can_handle_collection: can_handle_objectoriented_collection (collection_type)
	 	deferred
	 	end

	insert_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database. If the order is not conflicting with the items already in the database, it will try to preserve order.
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
			objectoriented_mode: not a_collection.handler.is_in_relational_storage_mode (a_collection)
			not_yet_known: not key_mapper.has_primary_key_of (a_collection.object_id, a_transaction)
	 		objectoriented_collection_operation_supported: is_objectoriented_collection_store_supported
	 		backend_can_handle_collection: can_handle_objectoriented_collection (a_collection.object_id.metadata)
		deferred
		ensure
--			collection_known: key_mapper.has_primary_key_of (a_collection.object_id)
		end

	delete_objectoriented_collection (a_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
			objectoriented_mode: not a_collection.handler.is_in_relational_storage_mode (a_collection)
			collection_known: key_mapper.has_primary_key_of (a_collection.object_id, a_transaction)
	 		objectoriented_collection_operation_supported: is_objectoriented_collection_store_supported
	 		backend_can_handle_collection: can_handle_objectoriented_collection (a_collection.object_id.metadata)
		deferred
		ensure
			not_known_anymore: not key_mapper.has_primary_key_of (a_collection.object_id, a_transaction)
		end

feature {PS_EIFFELSTORE_EXPORT}-- Relational collection operations


	retrieve_relational_collection (owner_type, collection_item_type: PS_TYPE_METADATA; owner_key: INTEGER; owner_attribute_name: STRING; transaction: PS_TRANSACTION) : PS_RETRIEVED_RELATIONAL_COLLECTION
			-- Retrieves the relational collection between class `owner_type' and `collection_item_type', where the owner has primary key `owner_key' and the attribute name of the collection inside the owner object is called `owner_attribute_name'
		require
			relational_collection_operation_supported: is_relational_collection_store_supported
			backend_can_handle_collection: can_handle_relational_collection (owner_type, collection_item_type)
		deferred
		end


	insert_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
			is_relational: a_collection.is_in_relational_storage_mode
			relational_collection_operation_supported: is_relational_collection_store_supported
--			backend_can_handle_collection: can_handle_relational_collection (a_collection.reference_owner, a_collection.values.first.)
--			TODO: add a mechanism in all PS_OBJECT_GRAPH_PARTs to get metadata
		deferred
		end


	delete_relational_collection (a_collection: PS_RELATIONAL_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
			is_relational: a_collection.is_in_relational_storage_mode
			relational_collection_operation_supported: is_relational_collection_store_supported
--			backend_can_handle_collection: can_handle_relational_collection (a_collection.reference_owner, a_collection.values.first.)
--			TODO: add a mechanism in all PS_OBJECT_GRAPH_PARTs to get metadata
		deferred
		end


feature {PS_EIFFELSTORE_EXPORT} -- Transaction handling

	commit (a_transaction: PS_TRANSACTION)
		-- Tries to commit `a_transaction'. As with every other error, a failed commit will result in a new exception and the error will be placed inside `a_transaction'
		deferred
		end

	rollback (a_transaction: PS_TRANSACTION)
		-- Aborts `a_transaction' and undoes all changes in the database
		deferred
		end

feature {PS_EIFFELSTORE_EXPORT} -- Mapping

	key_mapper: PS_KEY_POID_TABLE
		-- Maps POIDs to primary keys as used by this backend


feature {PS_EIFFELSTORE_EXPORT} -- Precondition checks

	check_dependencies_have_primary (an_object:PS_SINGLE_OBJECT_PART; transaction: PS_TRANSACTION):BOOLEAN
		do
			Result:= across an_object.attribute_values as val all attached {PS_COMPLEX_ATTRIBUTE_PART} val as comp implies key_mapper.has_primary_key_of (comp.object_id, transaction) end
		end


feature{NONE} -- Correctness checks


	check_attributes_loaded (type:PS_TYPE_METADATA; attributes:LIST[STRING]; obj:PS_RETRIEVED_OBJECT):BOOLEAN
		-- Check that there is a value for every attribute in `attributes' (or `type.attributes', if `attributes' is empty)
		do
			if attributes.is_empty then
				Result:= across type.attributes as cursor all obj.has_attribute (cursor.item) end
			else
				Result:= across attributes as cursor all obj.has_attribute (cursor.item) end
			end
		end

	check_successful_write (an_object: PS_SINGLE_OBJECT_PART; transaction:PS_TRANSACTION):BOOLEAN
		-- Checks if a write to an object returns the correct result
		local
			retrieved_object: PS_RETRIEVED_OBJECT
			retrieved_obj_list: LIST[PS_RETRIEVED_OBJECT]
			keys: LINKED_LIST[INTEGER]
			current_item: PS_OBJECT_GRAPH_PART
		do
			Result:= True
			create keys.make
			keys.extend (key_mapper.primary_key_of (an_object.object_id, transaction).first)
--			print (keys.count)
			retrieved_obj_list := retrieve_from_keys (an_object.object_id.metadata, keys, transaction)

			across an_object.object_id.metadata.attributes as attr
			loop
				if an_object.attributes.has (attr.item) then
					retrieved_object:= retrieved_obj_list.first
					current_item:= attach (an_object.attribute_values[attr.item])
					Result:= Result and current_item.storable_tuple (key_mapper.quick_translate (current_item.object_identifier, transaction)).first.is_equal (retrieved_object.attribute_value (attr.item).first)
					Result:= Result and current_item.storable_tuple (key_mapper.quick_translate (current_item.object_identifier, transaction)).second.is_equal (retrieved_object.attribute_value (attr.item).second)
				end
			end
		end

end
