note
	description: "Collects object identifiers."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_IDENTIFIER_SET

inherit
	PS_EIFFELSTORE_EXPORT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create current_items.make
			create deleted_objects.make
		end

feature {PS_EIFFELSTORE_EXPORT} -- Access

	identifier (object:ANY): INTEGER
			-- Get the identifier for `object'
		require
			identified: is_identified (object)
		do

		end

	current_items: LINKED_LIST [TUPLE [object: ANY; identifier: INTEGER]]
			-- All objects and their identifiers in the set.

	deleted_objects: LINKED_LIST[ANY]
			-- All object identifiers that have been deleted


feature {PS_EIFFELSTORE_EXPORT} -- Status report

	is_identified (object: ANY): BOOLEAN
			--Does `Current' have an identifier for `object'?
		do

		end

	is_deleted (object:ANY): BOOLEAN
			-- Has the identifier for `object' been deleted?
		do

		end


feature {PS_EIFFELSTORE_EXPORT} -- Element change

	add_identifier (object:ANY; new_identifier:INTEGER)
			-- Add `object' with identifier `new_identifier' to the set
		do

		ensure
			identified: is_identified (object)
			correct: identifier (object) = new_identifier
		end

	delete_identifier (object:ANY)
			-- Delete the idenifier for `object'
		do

		ensure
			not_identified: not is_identified (object)
			deleted: is_deleted (object)
		end


feature {PS_EIFFELSTORE_EXPORT} -- Set operations

	merge (other: PS_IDENTIFIER_SET)
			-- Merge `Current' with `other'
		require
			equal_objects_have_equal_identifier: across other.current_items as cursor all Current.is_identified (cursor.item.object) implies cursor.item.identifier = identifier (cursor.item.object) end
			deleted_objects_exist: across other.deleted_objects as cursor all is_identified (cursor.item) end
		do

		ensure
			all_added: across other.current_items as cursor all is_identified (cursor.item.object) end
			correctly_deleted: across other.deleted_objects as cursor all not is_identified (cursor.item) end
		end

feature {NONE} -- Invariant checking

	are_objects_identified_twice: BOOLEAN
			-- Is there an object in the set that has been identified twice?
		do
			Result:=
			across current_items as cursor
			all
				across current_items as inner_cursor
				all
					cursor.item.object = inner_cursor.item.object implies cursor.item.identifier = inner_cursor.item.identifier
				end
			end
		end

invariant
	no_object_twice_in_set: not are_objects_identified_twice

end
