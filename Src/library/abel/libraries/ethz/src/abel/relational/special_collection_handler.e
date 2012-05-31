note
	description: "Colletion handler for SPECIAL for use in the relational memory backend."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	SPECIAL_COLLECTION_HANDLER

inherit
	PS_COLLECTION_HANDLER [SPECIAL [ANY]]


feature -- Layout information


	is_in_relational_storage_mode (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]):BOOLEAN
		-- Is `a_collection' stored in relational mode?
		do
			Result:= False
		end

	is_1_to_n_mapped (a_collection:PS_COLLECTION_PART[ITERABLE[ANY]]): BOOLEAN
		-- Is `a_collection' stored relationally in a 1:N mapping, meaning that the primary key of the parent is stored as a foreign key in the child's table?
		do
			Result:= False
		end


feature -- Low-level operations

	insert (a_collection: PS_COLLECTION_PART[SPECIAL[ANY]])
		do

		end


	delete (a_collection: PS_COLLECTION_PART[SPECIAL[ANY]])
		do

		end


	retrieve (parent_type, child_type: INTEGER; parent_attr_name: STRING): detachable
		PS_PAIR [
					LIST[INTEGER], -- The foreign keys in correct order
					TUPLE ] -- Any additional information required to create the actual collection
		do

		end


feature -- Object assembly

	build_collection (objects: LIST[ANY]; additional_information: TUPLE): detachable SPECIAL[ANY]
		do

		end
end
