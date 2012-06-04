note
	description: "Colletion handler for SPECIAL for use in the relational memory backend."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_SPECIAL_COLLECTION_HANDLER

inherit
	PS_COLLECTION_HANDLER [SPECIAL [detachable ANY]]
	redefine can_handle_type end

create make

feature
	can_handle_type (a_type: TYPE[detachable ANY]):BOOLEAN
		-- Can `Current' handle the collection type `a_type'?
		local
			reflection: INTERNAL
		do
			create reflection
			Result:= reflection.is_special_any_type (a_type.type_id)
			fixme ("TODO: check this attached/detachable type problem here..")
		end


feature -- Layout information


	is_in_relational_storage_mode (a_collection: PS_COLLECTION_PART[SPECIAL[detachable ANY]]):BOOLEAN
		-- Is `a_collection' stored in relational mode?
		do
			Result:= False
		end

	is_1_to_n_mapped (a_collection:PS_COLLECTION_PART[SPECIAL[detachable ANY]]): BOOLEAN
		-- Is `a_collection' stored relationally in a 1:N mapping, meaning that the primary key of the parent is stored as a foreign key in the child's table?
		do
			Result:= False
		end


feature -- Low-level operations

	insert (a_collection: PS_COLLECTION_PART[SPECIAL[detachable ANY]])
		local
			current_collection: LINKED_LIST[INTEGER]
		do
			if collections.has (a_collection.object_id.object_identifier) then
				current_collection:= attach (collections[a_collection.object_id.object_identifier])
			else
				create current_collection.make
				collections.extend (current_collection, a_collection.object_id.object_identifier)
				--print (a_collection.object_id.object_identifier)
			end

			-- fill the "foreign key table"
			across a_collection.values as object_cursor loop
				fixme ("handle basic types")
				if attached{PS_COMPLEX_ATTRIBUTE_PART} object_cursor.item as obj then
					current_collection.extend (obj.object_id.object_identifier)
				elseif attached{PS_NULL_REFERENCE_PART} object_cursor.item as null_ref then
					current_collection.extend (0)

				end
			end

			-- add the 'count' variable

			check attached{SPECIAL[detachable ANY]} a_collection.object_id.item as actual_collection then
				collection_counts.extend (actual_collection.capacity, a_collection.object_id.object_identifier)
				--print (actual_collection.capacity.out + "%N")
			end

		end


	delete (a_collection: PS_COLLECTION_PART[SPECIAL[detachable ANY]])
		do
			collections.remove (a_collection.object_id.object_identifier)
			collection_counts.remove (a_collection.object_id.object_identifier)

		end


	retrieve (parent_key, parent_type, child_type: INTEGER; parent_attr_name: STRING):
		PS_PAIR [
					LIST[INTEGER], -- The foreign keys in correct order
					TUPLE ] -- Any additional information required to create the actual collection
		local
			count_tuple: TUPLE[INTEGER]
		do
			--print (parent_key.out + collection_counts[parent_key].out)
			create count_tuple.default_create
			count_tuple.put_integer (collection_counts[parent_key], 1)
			create Result.make (attach (collections[parent_key]), count_tuple)
		end


feature -- Object assembly

	build_collection (type_id: INTEGER; objects: LIST[detachable ANY]; additional_information: TUPLE):SPECIAL[detachable ANY]
		-- Dynamic type id of the collection
		local
			reflection: INTERNAL
			count, i:INTEGER
		do
			create reflection
			fixme ("TODO: handle case where SPECIAL doesn't have a reference type")
			count:= additional_information.integer_32_item (1)
			--print (additional_information.out + count.out)

			Result:= reflection.new_special_any_instance (type_id, count)
			--print (Result.count)

			across objects as obj_cursor from i:=0 loop
				Result.extend (obj_cursor.item)
				i:=i+1
			end

		end

feature {NONE}-- Implementation

	collections: HASH_TABLE[LINKED_LIST[INTEGER],INTEGER]
		-- Internal store of collection objects

	collection_counts: HASH_TABLE[INTEGER, INTEGER]
		-- The capacity of individual SPECIAL objects

	make
		do
			create collections.make (100)
			create collection_counts.make (100)
		end

end
