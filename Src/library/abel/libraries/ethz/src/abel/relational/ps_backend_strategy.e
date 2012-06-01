note
	description: "Abstraction of the actual DB backend and schema"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_BACKEND_STRATEGY

inherit
	PS_EIFFELSTORE_EXPORT

feature


	retrieve (class_name:STRING; criteria:PS_CRITERION; attributes:LIST[STRING]; transaction:PS_TRANSACTION) : ITERATION_CURSOR[PS_PAIR [INTEGER, HASH_TABLE[STRING, STRING]]]
		-- Retrieves all objects of class `class_name' that match the criteria in `criteria' within transaction `transaction'.
		-- If `atributes' is not empty, it will only retrieve the attributes listed there.
		deferred
			-- TODO: to have lazy loading support, we need to have a special ITERATION_CURSOR and a function next in this class to load the next item of this customized cursor

			-- TODO: Add a criteria that supports filtering by a list of primary keys
			-- That way we can later reduce the number or round trip times by collecting all the foreign keys of the same type
		end


	retrieve_collection (parent_key, parent_type, child_type: INTEGER; parent_attr_name: STRING):
		PS_PAIR [
					LIST[INTEGER], -- The foreign keys in correct order
					TUPLE ] -- Any additional information required to create the actual collection
		local
			reflection:INTERNAL
		do
			create reflection
			create Result.make (create{LINKED_LIST[INTEGER]}.make, create {TUPLE})
			across collection_handlers as handler_cursor loop
				if handler_cursor.item.can_handle_type (reflection.type_of_type (child_type)) then
					Result:= handler_cursor.item.retrieve (parent_key, parent_type, child_type, parent_attr_name)
				end
			end
		end



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



	insert_collection (a_collection: PS_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
		do
			a_collection.handler.insert (a_collection)
		end

	update_collection (a_collection: PS_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Update a_collection (replace with any pre-existing collection)
		require
			mode_is_update: a_collection.write_mode = a_collection.write_mode.update
		do
			-- Delete this - Updates are handled earlier by creating a delete and then an insert statement
			check false end

		end

	delete_collection (a_collection: PS_COLLECTION_PART[ITERABLE[detachable ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
		do
			a_collection.handler.delete (a_collection)
		end


	collection_handlers: LINKED_LIST[PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]]

	add_handler (a_handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]])
		do
			collection_handlers.extend (a_handler)
		end


end
