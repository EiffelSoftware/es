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

	PS_LIB_UTILS

feature -- Initialization

	make (a_medium: IO_MEDIUM)
			-- Provide a medium for current serializer.
		do
			t_make
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

	store (an_object: detachable ANY)
			--	Serialize an_object. Replace it if invoked twice on the same medium.
		require
			object_exists: an_object /= Void
		deferred
		ensure
			object_stored_correctly: last_store_successful
		end

	multi_store (an_object: detachable ANY)
			--	Serialize an_object. Allow storing more than one object on the same medium.
		require
			object_exists: an_object /= Void
		deferred
		ensure
			object_stored_correctly: last_store_successful
		end

	retrieve
			-- Retrieve an object. Update `retrieved_items'.
		deferred
		ensure
			retrieved_items_exists: retrieved_items /= Void
		end

	multi_retrieve
			-- Retrieve object(s) in a multi-object scenario. Update `retrieved_items'.
		deferred
		ensure
			retrieved_items_exists: retrieved_items /= Void
		end

feature {PS_SERIALIZER} -- Implementation

	traverse_and_compute (an_object: ANY)
			-- While traversing `an_object' object structure,
			-- compute `an_object' representation using `format' and
			-- build the final representation to be stored.
		require
			an_object_attached: an_object /= Void
		do
			to_implement ("This is the template method pattern: a template algorithm with some feature calls to be implemented by descendants.")
			to_implement ("Traversing will be the same for all serializers")
			to_implement ("The template will invoke `format.compute_representation' which will vary depending on the format.")
			to_implement ("The construction process of the final serializable form should also stay the same across serializers.")
		end
			-- - - - - - Object Traversing features, should be better organized in separate classes - - - - - - - - - - - - - -

feature

	t_make
		do
			create serialized.make (0)
		end

feature -- Access

	enable_messages: BOOLEAN = FALSE

	serialized: detachable ARRAYED_LIST [ANY]

feature -- Status

	print_serialized
		do
			print ("%N")
			print ("Serialized object (length:" + serialized.count.out + ")%N")
			from
				serialized.start
			until
				serialized.off
			loop
					--print ("[" + serialized.index.out + "] -> " + serialized.item.out + "%N")
				print (serialized.item.out + "%N")
				serialized.forth
			end
			print ("%N")
		end

feature {ANY} -- Implementation

	traverse (an_object: ANY)
		require
			an_object_not_void: an_object /= Void
		local
			--l_object_traversor: AD_OBJECT_TRAVERSABLE
		do
--			create l_object_traversor
--			l_object_traversor.set_root_object (an_object)
--			l_object_traversor.traverse
--			serialized := l_object_traversor.visited_objects
		end

	build_from_serialized
		require
			serialized_not_void: serialized /= Void
		local
			l_current_field: ANY
			l_object: detachable ANY
			l_int: INTERNAL
			--l_trav: AD_OBJECT_TRAVERSABLE
		do
			from
				serialized.start
				create l_int
				--create l_trav
			until
				serialized.off
			loop
				l_current_field := serialized.item
				serialized.forth
			end
		end

	message (s: STRING)
		do
			if enable_messages then
				print (s)
			end
		end

end
