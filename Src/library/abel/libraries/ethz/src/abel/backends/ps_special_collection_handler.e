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
			Result:= reflection.is_special_type (a_type.type_id)
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



	add_information (object_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]])
		do
			check attached{SPECIAL[detachable ANY]} object_collection.represented_object as actual_collection then
				object_collection.add_information ("count", actual_collection.capacity.out)
			end
		end


feature -- Object assembly

	build_collection (type_id: PS_TYPE_METADATA; objects: LIST[detachable ANY]; additional_information: PS_RETRIEVED_OBJECT_COLLECTION):SPECIAL[detachable ANY]
		-- Dynamic type id of the collection
		local
			reflection: INTERNAL
			count, i:INTEGER
		do
			create reflection

--			fixme ("TODO: the following line:-)")
--			count:=10
			count:= additional_information.get_information("count").to_integer
			--print (additional_information.out + count.out)

			if reflection.is_special_any_type (type_id.type.type_id) then
				Result:= reflection.new_special_any_instance (type_id.type.type_id, count)
			else
			fixme ("TODO: all other basic types")
				if type_id.actual_generic_parameter (1).type.out.is_equal ("BOOLEAN") then
					create {SPECIAL[BOOLEAN]} Result.make_empty (count)
				else
					create {SPECIAL[INTEGER]} Result.make_empty (count)
				end
			end
			--print (Result.count)

			across objects as obj_cursor from i:=0 loop
				Result.extend (obj_cursor.item)
				i:=i+1
			end

--			print (Result)
		end

	build_relational_collection (type_id: PS_TYPE_METADATA; objects: LIST[detachable ANY]):SPECIAL[detachable ANY]
		do
			fixme ("TODO")
			create Result.make_empty (10)
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
