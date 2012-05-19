note
	description: "Summary description for {PS_COLLECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_HANDLER [COLLECTION_TYPE -> ITERABLE[ANY]]

inherit PS_EIFFELSTORE_EXPORT
inherit{NONE} REFACTORING_HELPER

feature

	can_handle (a_collection:ANY):BOOLEAN
		-- Can `Current' handle the collection `a_collection'?
		do
			Result:= attached {COLLECTION_TYPE} a_collection
		end

	is_of_basic_type (an_obj:ANY): BOOLEAN
		deferred
			-- TODO!
		end

	disassemble_collection (collection: PS_OBJECT_IDENTIFIER_WRAPPER; depth: INTEGER; mode:PS_WRITE_OPERATION; a_disassembler:PS_OBJECT_DISASSEMBLER; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING):	PS_COLLECTION_PART [COLLECTION_TYPE]
		-- disassemble the collection
		require
			can_handle_collection: can_handle (collection)
		do

			Result := create_result (collection, reference_owner, ref_attribute_name, mode)
			a_disassembler.register_operation (Result, collection.object_identifier)

			-- do actual business code, use agent to disassemble all referenced objects

			do_disassemble (Result, agent a_disassembler.disassemble (?, depth, mode, Result, ""))

		end


	create_result (obj: PS_OBJECT_IDENTIFIER_WRAPPER ref_owner:PS_OBJECT_GRAPH_PART; attr_name: STRING ; mode:PS_WRITE_OPERATION) : PS_COLLECTION_PART [COLLECTION_TYPE]
		require
			no_multidimensional_collections_in_relational_mode: is_in_relational_storage_mode implies not attached {PS_COLLECTION_PART [ITERABLE[ANY]]} ref_owner
		do
			create Result.make (obj, ref_owner, attr_name, mode, is_in_relational_storage_mode)
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
						collection.values.extend (create {PS_BASIC_ATTRIBUTE_PART}.make (cursor.item))
					else
						collection.values.extend (disassemble_function.item ([cursor.item]))
					end
					cursor.forth
				end
--				the following line produces a reproducible bug in EiffelStudio, even when doing a clean compile...
--				across actual_collection as cursor loop disassemble_function.call ([cursor.item])  end

			end
		end


	is_in_relational_storage_mode :BOOLEAN
		deferred
		end


	-- Storing collections: The backends can either store collections based on their own POID (then they have to issue another update statement for their parents)
	-- or based on the poid of the parent (more relational, less flexible - e.g. it won't be possible to store collections directly that way)

end
