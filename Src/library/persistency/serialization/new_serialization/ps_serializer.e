note
	description: "[
		{PS_SERIALIZER}'s descendant objects allow persisting and retrieving objects using serialization. 
		They can use different formats like binary, or different textual flavors, and different media like file, memory or both.
		Feature make_default can be redefined by each descendant to provide the desired medium and format. 
		Alternatively, use make_for_custom_serialization to create a {PS_SERIALIZER} descendant using a custom media and format combination.
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_SERIALIZER

inherit {NONE}

	REFACTORING_HELPER

feature -- Initialization

	make (a_medium: IO_MEDIUM)
			-- Provide a medium for current serializer.
		do
		end

feature -- Access

	format: PS_FORMAT
			-- The format used for serialization.

	medium: IO_MEDIUM
			-- The medium used for serialization.

	retrieved_items: ARRAYED_LIST [detachable ANY]
			-- Object(s) retrieved.

	objects_stored_count: INTEGER
			-- Number of objects stored in the same file.

	last_store_successful: BOOLEAN
			-- Was last store operation successful?

	last_retrieval_information: STRING
			-- Information on last retrieval.

feature -- Status setting

feature -- Basic operations

	store (an_object: ANY)
			--	Serialize an_object. Replace it if invoked twice on the same medium.
		require
			object_exists: an_object /= Void
			a_medium_exist: medium /= Void
			a_medium_is_writable: medium.is_writable and medium.is_open_write
		deferred
		ensure
			object_stored_correctly: last_store_successful
		end

	multi_store (an_object: ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.
		require
			object_exists: an_object /= Void
			a_medium_exist: medium /= Void
			a_medium_is_writable: medium.is_writable and medium.is_open_write
		deferred
		ensure
			object_stored_correctly: last_store_successful
		end

	retrieve
			-- Retrieve an object. Update `retrieved_items'.
		require
			a_medium_exists: medium /= Void
			a_medium_readable: medium.is_readable and medium.is_open_read
		deferred
		ensure
			retrieved_items_exists: retrieved_items /= Void
			retrieved_items_has_item: retrieved_items.count > 0
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		require
			a_medium_exists: medium /= Void
			a_medium_readable: medium.is_readable and medium.is_open_read
		deferred
		ensure
			retrieved_items_exists: retrieved_items /= Void
			retrieved_items_has_item: retrieved_items.count > 0
		end

feature {NONE} -- Implementation

	encode_object (an_object: ANY)
		require
			an_object_not_void: an_object /= Void
			a_medium_is_set: medium /= Void
			a_medium_is_writable: medium.is_writable and medium.is_open_write
		do
				-- write header for encoded object
			format.write_header (medium)
				-- encode object
			format.visited_objects.wipe_out
			format.l_int.lock_marking
			format.encode_object (an_object, -1, medium)
			format.unmark_all
			format.l_int.unlock_marking
			from
				format.visited_objects.start
			until
				true --format.visited_objects.off
			loop
				print (format.l_int.type_name (format.visited_objects.item) + " with value: " + format.visited_objects.item.out + "%N")
				format.visited_objects.forth
			end
		end

	decode_object
		require
			a_medium_exist: medium /= Void
			a_medium_is_readable: medium.is_readable and medium.is_open_read
		local
			retrieved_object: ANY
		do
				-- read header
			if format.correct_header (medium) then
				retrieved_object := format.extract_object (medium)
				if retrieved_object /= Void then
					retrieved_items.extend (retrieved_object)
					from
						format.rebuilt_objects.start
					until
						true --format.rebuilt_objects.off
					loop
						print (format.l_int.type_name (format.rebuilt_objects.item) + " with value: " + format.rebuilt_objects.item.out + "%N")
						format.rebuilt_objects.forth
					end
				else
					last_retrieval_information := "error in extracting object"
				end
			else
				last_retrieval_information := "invalid header"
			end
		end

end
