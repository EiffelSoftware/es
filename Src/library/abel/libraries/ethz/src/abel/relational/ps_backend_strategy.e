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



	insert_collection (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]; a_transaction:PS_TRANSACTION)
		-- Add all entries in a_collection to the database
		require
			mode_is_insert: a_collection.write_mode = a_collection.write_mode.insert
		deferred
		end

	update_collection (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]; a_transaction:PS_TRANSACTION)
		-- Update a_collection (replace with any pre-existing collection)
		require
			mode_is_update: a_collection.write_mode = a_collection.write_mode.update
		deferred
		end

	delete_collection (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]; a_transaction:PS_TRANSACTION)
		-- Delete a_collection from the database
		require
			mode_is_delete: a_collection.write_mode = a_collection.write_mode.delete
		deferred
		end



end
