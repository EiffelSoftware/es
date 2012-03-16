note
	description: "Summary description for {PS_SQL_TRANSACTION_UNIT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SQL_TRANSACTION_UNIT

inherit

	PS_TRANSACTION_UNIT
	redefine
			query
	end

inherit {NONE}

	PS_LIB_UTILS

create
	make_with_sql_query

feature {NONE} -- Initialization

	make_with_sql_query (q: PS_SQL_QUERY)
			-- Initialization for `Current'.
		do
			query := q
			create {ARRAYED_LIST [ANY]} created_objects.make (Default_dimension)
			create {ARRAYED_LIST [ANY]} modified_objects.make (Default_dimension)
			create {ARRAYED_LIST [ANY]} removed_objects.make (Default_dimension)
			create identity_map.make (Default_dimension)
		ensure
			query_set: query = q
		end

feature -- Access

	query: PS_QUERY [ANY]
			-- The query `Current' is wrapping
			--	created_objects: LIST [ANY]
			-- List of newly created objects.
			--	modified_objects: LIST [ANY]
			-- List of modified (dirty) objects.
			--	removed_objects: LIST [ANY]
			-- List of deleted objects.
			--	identity_map: HASH_TABLE [ANY, HASHABLE]
			-- identity map, necessary to avoid loading the same object twice.

feature -- Basic operations
			--	commit
			-- Commit changes.
			--		do
			-- Open a transaction
			-- Check concurrency issues using pessimistic or optimistic offline locking
			-- Write changes to db using the correct mapping:
			--			insert_new_objects
			--			update_modified_objects
			--			delete_removed_objects
			--		end
			--	register_as_new (obj: ANY)
			-- Register `obj' as newly created.
			--		require
			--			object_in_modified_list: modified_objects.has (obj)
			--			object_in_removed_list: removed_objects.has (obj)
			--			object_in_created_list_already: created_objects.has (obj)
			--		do
			--			created_objects.extend (obj)
			-- Register `obj' on the identity map.
			--		end
			--	register_as_modified (obj: ANY)
			-- Register `obj' as modified.
			--		require
			--			object_in_created_list: created_objects.has (obj)
			--			object_in_removed_list: removed_objects.has (obj)
			--			object_in_modified_list_already: modified_objects.has (obj)
			--		do
			--			modified_objects.extend (obj)
			--		end
			--	register_as_removed (obj: ANY)
			-- Register `obj' as deleted.
			--		require
			--			object_in_created_list: created_objects.has (obj)
			--			object_in_modified_list: modified_objects.has (obj)
			--			object_in_removed_list_already: removed_objects.has (obj)
			--		do
			--			removed_objects.extend (obj)
			-- Remove  a deleted `obj' from the identity map.
			--		end
			--	register_as_clean (obj: ANY)
			-- Register `obj' on the identity map.
			--		do
			--	identity_map.extend (obj, obj.)
			-- we have to extract the key from the object
			--		end
			--	insert_new_objects
			-- Insert newly created objects.
			--		do
			-- TODO.
			--		end
			--	update_modified_objects
			-- Update previously modified objects.
			--		do
			--			
			-- TODO.
			--		end
			--	delete_removed_objects
			-- Update previously modified objects.
			--		do
			-- TODO.
			--		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
