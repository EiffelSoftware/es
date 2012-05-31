note
	description: "This is a partially implemented class that adds support for collections in ABEL."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_HANDLER [COLLECTION_TYPE -> ITERABLE[ANY]]

inherit PS_EIFFELSTORE_EXPORT
inherit{NONE} REFACTORING_HELPER

feature -- Status report

	can_handle (a_collection:ANY):BOOLEAN
		-- Can `Current' handle the collection `a_collection'?
		do
			Result:= attached {COLLECTION_TYPE} a_collection
		end


	can_handle_type (a_type: TYPE[ANY]):BOOLEAN
		-- Can `Current' handle the collection type `a_type'?
		local
			reflection: INTERNAL
		do
			create reflection
			Result:= reflection.type_conforms_to (a_type.type_id, Current.generating_type.generic_parameter_type (1).type_id)
			fixme ("TODO: check this attached/detachable type problem here..")
		end

feature -- Disassemble functions

	create_object_graph_part (obj: PS_OBJECT_IDENTIFIER_WRAPPER ref_owner:PS_OBJECT_GRAPH_PART; attr_name: STRING ; mode:PS_WRITE_OPERATION) : PS_COLLECTION_PART [COLLECTION_TYPE]
		require
		--	no_multidimensional_collections_in_relational_mode: is_in_relational_storage_mode implies not attached {PS_COLLECTION_PART [ITERABLE[ANY]]} ref_owner
		do
			create Result.make (obj, ref_owner, attr_name, mode, Current)
			--Result.set_capacity (evaluate_capacity (obj))
		end


	disassemble_collection (collection: PS_OBJECT_IDENTIFIER_WRAPPER; depth: INTEGER; mode:PS_WRITE_OPERATION; a_disassembler:PS_OBJECT_DISASSEMBLER; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING):	PS_COLLECTION_PART [COLLECTION_TYPE]
		-- disassemble the collection
		require
			can_handle_collection: can_handle (collection)
		do

			Result := create_object_graph_part (collection, reference_owner, ref_attribute_name, mode)
			a_disassembler.register_operation (Result, collection.object_identifier)

			-- do actual business code, use agent to disassemble all referenced objects
			do_disassemble (Result, agent a_disassembler.disassemble (?, depth, mode, Result, ""))

		end

	do_disassemble (collection:PS_COLLECTION_PART [COLLECTION_TYPE]; disassemble_function:FUNCTION[ANY, TUPLE[ANY], PS_OBJECT_GRAPH_PART])
		local
			cursor:ITERATION_CURSOR[ANY]
		do
			check attached{COLLECTION_TYPE} collection.object_id.item as actual_collection then

				cursor:= actual_collection.new_cursor
				from
				until cursor.after
				loop
					if is_of_basic_type (cursor.item) then
						collection.add_value (create {PS_BASIC_ATTRIBUTE_PART}.make (cursor.item))
					else
						collection.add_value (disassemble_function.item ([cursor.item]))
					end
					cursor.forth
				end
--				the following line produces a reproducible bug in EiffelStudio, even when doing a clean compile...
--				across actual_collection as cursor loop disassemble_function.call ([cursor.item])  end

			end
		end


feature -- Layout information


	is_in_relational_storage_mode (a_collection: PS_COLLECTION_PART[ITERABLE[ANY]]):BOOLEAN
		-- Is `a_collection' stored in relational mode?
		deferred
		end

	is_1_to_n_mapped (a_collection:PS_COLLECTION_PART[ITERABLE[ANY]]): BOOLEAN
		-- Is `a_collection' stored relationally in a 1:N mapping, meaning that the primary key of the parent is stored as a foreign key in the child's table?
		deferred
		ensure
			false_if_not_relational: not is_in_relational_storage_mode (a_collection) implies Result = False
		end



feature -- Utilities


	is_of_basic_type (obj:ANY): BOOLEAN
		do
			Result:=attached{NUMERIC} obj or attached{BOOLEAN} obj or attached{CHARACTER_8} obj or attached{CHARACTER_32} obj or attached{READABLE_STRING_GENERAL} obj
			fixme ("Some common ancestor for all these types of functions would be nice")
		end

end
