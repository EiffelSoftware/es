note
	description: "Maps primary keys to POID and vice-versa. An object can be loaded several times, therefore the object_of feature returns a list of objects"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_KEY_POID_TABLE

inherit
	PS_EIFFELSTORE_EXPORT

create make

feature

	has_primary_key_of(obj: PS_OBJECT_IDENTIFIER_WRAPPER): BOOLEAN
		do
			Result:= obj_to_key_hash.has (obj.object_identifier)
		end

	has_objects_of (primary_key: INTEGER; type: PS_TYPE_METADATA) : BOOLEAN
		do
			-- probably not the fastest implementation...
			Result:= not objects_of (primary_key, type).is_empty
		end

	primary_key_of (obj: PS_OBJECT_IDENTIFIER_WRAPPER): PS_PAIR[INTEGER, PS_CLASS_METADATA]
		-- Returns the primary key of object `obj' as stored in the backend.
		do
			Result:= attach (obj_to_key_hash[obj.object_identifier])
		end

	quick_translate (a_poid:INTEGER):INTEGER
		-- Returns the primary key of a_poid, or 0 if a_poid doesn't have a primary key
		do
			if obj_to_key_hash.has (a_poid) then
				Result:= attach (obj_to_key_hash[a_poid]).first
			end
		end


	objects_of (primary_key: INTEGER; type: PS_TYPE_METADATA) : LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER]
		-- Returns all objects that are associated to the primary key `primary_key' in the database.
		local
			type_hash: HASH_TABLE[LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER], INTEGER]
		do
			create Result.make

			if key_to_obj_hash.has (type.type.type_id) then
				type_hash:= attach (key_to_obj_hash[type.type.type_id])

				if type_hash.has (primary_key) then
					Result.append (attach (type_hash[primary_key]))
				end

			end
		end


	add_entry (obj: PS_OBJECT_IDENTIFIER_WRAPPER; primary_key: INTEGER)
		-- Add a new table entry
		local
			type_hash: HASH_TABLE[LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER], INTEGER]
			local_list: LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER]
		do
			obj_to_key_hash.extend (create {PS_PAIR[INTEGER, PS_CLASS_METADATA]}.make (primary_key, obj.metadata.class_of_type), obj.object_identifier)
			if not key_to_obj_hash.has (obj.metadata.type.type_id) then
				create type_hash.make (default_size)
				key_to_obj_hash.extend (type_hash, obj.metadata.type.type_id)
			else
				type_hash := attach (key_to_obj_hash[obj.metadata.type.type_id])
			end

			if not type_hash.has (primary_key) then
				create local_list.make
				type_hash.extend (local_list, primary_key)
			else
				local_list := attach (type_hash[primary_key])
			end

			local_list.extend (obj)
		end


	remove_object (obj: PS_OBJECT_IDENTIFIER_WRAPPER)
		-- Remove `obj' from the table, but keep any other object associated to the same primary key if possible.
		local
			primary_key: INTEGER
			local_list: LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER]
		do
			if obj_to_key_hash.has (obj.object_identifier) then

				primary_key := attach (obj_to_key_hash[obj.object_identifier]).first
				obj_to_key_hash.remove (obj.object_identifier)

				-- also remove from linked list

				local_list:= attach (attach (key_to_obj_hash[obj.metadata.type.type_id]).item (primary_key))

				from local_list.start
				until local_list.after
				loop
					if local_list.item.object_identifier = obj.object_identifier then
						local_list.remove
					else
						local_list.forth
					end
				end
			end
		end


	remove_primary_key (primary_key: INTEGER; type:PS_TYPE_METADATA)
		-- Remove the primary key `primary_key' from the table, alongside all objects associated to it
		local
			local_list: LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER]
		do
			if key_to_obj_hash.has (type.type.type_id) and then attach (key_to_obj_hash[type.type.type_id]).has (primary_key) then

				local_list:= attach (attach (key_to_obj_hash[type.type.type_id]).item (primary_key))
				attach (key_to_obj_hash[type.type.type_id]).remove (primary_key)

				across local_list as cursor loop
					obj_to_key_hash.remove (cursor.item.object_identifier)
				end
			end
		end


feature {NONE} -- Implementation

	key_to_obj_hash: HASH_TABLE [
							HASH_TABLE [
								LINKED_LIST[PS_OBJECT_IDENTIFIER_WRAPPER], -- the objects
								INTEGER ] , -- the primary key
							INTEGER] -- the type

	obj_to_key_hash: HASH_TABLE [PS_PAIR[INTEGER, PS_CLASS_METADATA], -- the primary key and class
							INTEGER] -- the object_id


	default_size: INTEGER = 100

	make
		do
			create key_to_obj_hash.make (100)
			create obj_to_key_hash.make (100)
		end


	check_present_in_both_tables:BOOLEAN
		do
			Result:= True
			across key_to_obj_hash as nested_hash loop
				across nested_hash.item as nested_list loop
					across nested_list.item as wrapper_cursor loop
							Result:= Result and obj_to_key_hash.has (wrapper_cursor.item.object_identifier)
					end
				end
			end
		end

invariant
	objects_in_both_hashtables: check_present_in_both_tables
end
