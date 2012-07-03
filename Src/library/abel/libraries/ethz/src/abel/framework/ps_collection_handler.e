note
	description: "This is a partially implemented class that adds support for collections in ABEL."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_HANDLER [COLLECTION_TYPE -> ITERABLE[detachable ANY]]

inherit PS_EIFFELSTORE_EXPORT
inherit{NONE} REFACTORING_HELPER

feature -- Status report

	can_handle (a_collection:ANY):BOOLEAN
		-- Can `Current' handle the collection `a_collection'?
		do
			Result:= attached {COLLECTION_TYPE} a_collection
		end


	can_handle_type (a_type: TYPE[detachable ANY]):BOOLEAN
		-- Can `Current' handle the collection type `a_type'?
		local
			reflection: INTERNAL
		do
			create reflection
			Result:= reflection.type_conforms_to (a_type.type_id, Current.generating_type.generic_parameter_type (1).type_id)
			fixme ("TODO: check this attached/detachable type problem here..")
		end

feature {PS_EIFFELSTORE_EXPORT}-- Disassemble functions

	create_part (collection:ANY; metadata:PS_TYPE_METADATA; persistent:BOOLEAN; owner:PS_OBJECT_GRAPH_PART):PS_OBJECT_GRAPH_PART
		do
			if is_relational_1toN_collection (collection) then
				check attached {PS_SINGLE_OBJECT_PART} owner as good_owner then
					create {PS_RELATIONAL_COLLECTION_PART[COLLECTION_TYPE]} Result.make_new (collection, metadata, good_owner, Current, owner.root)
				end
			else
				create {PS_OBJECT_COLLECTION_PART[COLLECTION_TYPE]}  Result.make_new (collection, metadata, persistent, Current, owner.root)
			end
		end


	add_information (object_collection: PS_OBJECT_COLLECTION_PART[ITERABLE[detachable ANY]])
		deferred

		end


feature -- Layout information


	is_in_relational_storage_mode (a_collection: PS_COLLECTION_PART[COLLECTION_TYPE]):BOOLEAN
		-- Is `a_collection' stored in relational mode?
		deferred
		end

	is_1_to_n_mapped (a_collection:PS_COLLECTION_PART[COLLECTION_TYPE]): BOOLEAN
		-- Is `a_collection' stored relationally in a 1:N mapping, meaning that the primary key of the parent is stored as a foreign key in the child's table?
		deferred
		ensure
			false_if_not_relational: not is_in_relational_storage_mode (a_collection) implies Result = False
		end


	is_in_relational_mode_by_type (a_collection: TYPE[detachable ANY]): BOOLEAN
		do
			Result:= false
			fixme ("Implement this - also look if feature signature is sufficient like that")
		end

	is_relational_collection (a_collection:ANY):BOOLEAN
		require
			can_handle (a_collection)
		do
			fixme ("implement")
			Result:= False
		end

	is_relational_1toN_collection (a_collection:ANY):BOOLEAN
		do
			fixme ("implement")
			Result:= False
		end

feature -- Utilities


	is_of_basic_type (obj:ANY): BOOLEAN
		do
			Result:=attached{NUMERIC} obj or attached{BOOLEAN} obj or attached{CHARACTER_8} obj or attached{CHARACTER_32} obj or attached{READABLE_STRING_GENERAL} obj
			fixme ("Some common ancestor for all these types of functions would be nice")
		end



feature -- Object assembly

	build_collection (type_id: PS_TYPE_METADATA; objects: LIST[detachable ANY]; additional_information: PS_RETRIEVED_OBJECT_COLLECTION): COLLECTION_TYPE
		-- Dynamic type id of the collection
		deferred
		end

	build_relational_collection (type_id: PS_TYPE_METADATA; objects: LIST[detachable ANY]): COLLECTION_TYPE
		-- Dynamic type id of the collection
		deferred
		end


end
