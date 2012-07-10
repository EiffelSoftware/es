note
	description: "Maps object identifiers to [primary_key, type] tuples."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_KEY_POID_TABLE

inherit

	PS_EIFFELSTORE_EXPORT

create
	make

feature {PS_EIFFELSTORE_EXPORT} -- Status report

	has_primary_key_of (obj: PS_OBJECT_IDENTIFIER_WRAPPER; transaction: PS_TRANSACTION): BOOLEAN
			-- Has `obj' a primary key?		
		do
			Result := obj_to_key_hash.has (obj.object_identifier)
		end

feature {PS_EIFFELSTORE_EXPORT} -- Access

	primary_key_of (obj: PS_OBJECT_IDENTIFIER_WRAPPER; transaction: PS_TRANSACTION): PS_PAIR [INTEGER, PS_TYPE_METADATA]
			-- Returns the primary key of object `obj' as stored in the backend.
		do
			Result := attach (obj_to_key_hash [obj.object_identifier])
				-- TODO: first check transaction-local set, then global one
		end

	quick_translate (a_poid: INTEGER; transaction: PS_TRANSACTION): INTEGER
			-- Returns the primary key of a_poid, or 0 if a_poid doesn't have a primary key.
		do
			if obj_to_key_hash.has (a_poid) then
				Result := attach (obj_to_key_hash [a_poid]).first
			end
				-- TODO: first check transaction-local set, then global one
		end

feature {PS_EIFFELSTORE_EXPORT} -- Element change

	add_entry (obj: PS_OBJECT_IDENTIFIER_WRAPPER; primary_key: INTEGER; transaction: PS_TRANSACTION)
			-- Add a new table entry.
		local
			type_hash: HASH_TABLE [LINKED_LIST [PS_OBJECT_IDENTIFIER_WRAPPER], INTEGER]
			local_list: LINKED_LIST [PS_OBJECT_IDENTIFIER_WRAPPER]
		do
			obj_to_key_hash.extend (create {PS_PAIR [INTEGER, PS_TYPE_METADATA]}.make (primary_key, obj.metadata), obj.object_identifier)
				-- TODO: write to transaction-local write set, (and remove delete from transaction-local delete set if there is one)

				--			if not key_to_obj_hash.has (obj.metadata.type.type_id) then
				--				create type_hash.make (default_size)
				--				key_to_obj_hash.extend (type_hash, obj.metadata.type.type_id)
				--			else
				--				type_hash := attach (key_to_obj_hash[obj.metadata.type.type_id])
				--			end
				--			if not type_hash.has (primary_key) then
				--				create local_list.make
				--				type_hash.extend (local_list, primary_key)
				--			else
				--				local_list := attach (type_hash[primary_key])
				--			end
				--			local_list.extend (obj)
		end

	remove_primary_key (primary_key: INTEGER; type: PS_TYPE_METADATA; transaction: PS_TRANSACTION)
			-- Remove the primary key `primary_key' from the table, alongside all objects associated to it.
		local
			local_list: LINKED_LIST [PS_OBJECT_IDENTIFIER_WRAPPER]
			to_remove: LINKED_LIST [INTEGER]
		do
				--			if key_to_obj_hash.has (type.type.type_id) and then attach (key_to_obj_hash[type.type.type_id]).has (primary_key) then
				--				local_list:= attach (attach (key_to_obj_hash[type.type.type_id]).item (primary_key))
				--				attach (key_to_obj_hash[type.type.type_id]).remove (primary_key)
				--				across local_list as cursor loop
				--					obj_to_key_hash.remove (cursor.item.object_identifier)
				--				end
				--			end
			create to_remove.make
			across
				obj_to_key_hash as cursor
			loop
				if cursor.item.first = primary_key and cursor.item.second.type.type_id = type.type.type_id then
					to_remove.extend (cursor.key)
				end
			end
			across
				to_remove as cursor
			loop
				obj_to_key_hash.remove (cursor.item)
			end
				--TODO: delete from transaction-local write set, or collect deletes in transaction-local delete set - only delete at commit-time
		end

feature {PS_EIFFELSTORE_EXPORT} -- Transaction management

	commit (transaction: PS_TRANSACTION)
		do
		end

	rollback (transaction: PS_TRANSACTION)
		do
		end

feature {PS_EIFFELSTORE_EXPORT} -- Cleanup and Memory management

		-- TODO: reimplement this feature and add it as an agent to the object identification manager.

	--	remove_object (obj: PS_OBJECT_IDENTIFIER_WRAPPER)
		-- Remove `obj' from the table, but keep any other object associated to the same primary key if possible.
		--		local
		--			primary_key: INTEGER
		--			local_list: LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER]
		--		do
		--			if obj_to_key_hash.has (obj.object_identifier) then
		--				primary_key := attach (obj_to_key_hash[obj.object_identifier]).first
		--				obj_to_key_hash.remove (obj.object_identifier)
		-- also remove from linked list
		--				local_list:= attach (attach (key_to_obj_hash[obj.metadata.type.type_id]).item (primary_key))
		--				from local_list.start
		--				until local_list.after
		--				loop
		--					if local_list.item.object_identifier = obj.object_identifier then
		--						local_list.remove
		--					else
		--						local_list.forth
		--					end
		--				end
		--			end
		--		end

feature {PS_EIFFELSTORE_EXPORT} -- Primary key to object mapping functions

		-- TODO: the vice-versa part (primary key to object identifier) is currently not used.
		-- It was intended to deliver fast results in some cases where the object is already built by another query and is still in memory,
		-- but maybe caching at a lower level is better for that (easier, and less side effects)

	--	has_objects_of (primary_key: INTEGER; type: PS_TYPE_METADATA) : BOOLEAN
		--		do
		-- probably not the fastest implementation...
		--			Result:= not objects_of (primary_key, type).is_empty
		--		end
		--	objects_of (primary_key: INTEGER; type: PS_TYPE_METADATA) : LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER]
		-- Returns all objects that are associated to the primary key `primary_key' in the database.
		--		local
		--			type_hash: HASH_TABLE[LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER], INTEGER]
		--		do
		--			create Result.make
		--			if key_to_obj_hash.has (type.type.type_id) then
		--				type_hash:= attach (key_to_obj_hash[type.type.type_id])
		--				if type_hash.has (primary_key) then
		--					Result.append (attach (type_hash[primary_key]))
		--				end
		--			end
		--		end

feature {NONE} -- Implementation

		--	key_to_obj_hash: HASH_TABLE [
		--							HASH_TABLE [
		--								LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER], -- the objects
		--								INTEGER ] , -- the primary key
		--							INTEGER] -- the type

	obj_to_key_hash: HASH_TABLE [
							PS_PAIR [INTEGER, PS_TYPE_METADATA], -- the primary key and class
							INTEGER] -- the object_id

	default_size: INTEGER = 100

	make
			-- Initialization for `Current'.
		do
			--create key_to_obj_hash.make (100)
			create obj_to_key_hash.make (100)
		end

end
