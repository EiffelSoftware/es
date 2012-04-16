note
	description: "Summary description for {PS_COLLECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_HANDLER [COLLECTION_TYPE -> ITERABLE[ANY]]

inherit PS_EIFFELSTORE_EXPORT

feature

	can_handle (a_collection:ANY):BOOLEAN
		-- Can `Current' handle the collection `a_collection'?
		do
			Result:= attached {COLLECTION_TYPE} a_collection
		end

	is_collection_of_basic_type (a_collection:PS_OBJECT_IDENTIFIER_WRAPPER): BOOLEAN
		deferred
			-- TODO!
		end

	disassemble_collection (collection: PS_OBJECT_IDENTIFIER_WRAPPER; depth: INTEGER; mode:INTEGER; a_disassembler:PS_OBJECT_DISASSEMBLER; reference_owner:PS_ABSTRACT_DB_OPERATION; ref_attribute_name:STRING):	PS_ABSTRACT_COLLECTION_OPERATION [COLLECTION_TYPE]
		-- disassemble the collection
		require
			can_handle_collection: can_handle (collection)
		do

			Result := create_result (collection, reference_owner, ref_attribute_name, mode)
			a_disassembler.register_operation (Result, collection.object_identifier)

			-- do actual business code, use agent to disassemble all referenced objects

			do_disassemble (Result, agent a_disassembler.disassemble (?, depth, mode, Result, ""))

		end


	create_result (obj: PS_OBJECT_IDENTIFIER_WRAPPER ref_owner:PS_ABSTRACT_DB_OPERATION; attr_name: STRING ; mode:INTEGER) : PS_ABSTRACT_COLLECTION_OPERATION [COLLECTION_TYPE]
		require
			no_multidimensional_collections_in_relational_mode: is_in_relational_storage_mode implies not attached {PS_ABSTRACT_COLLECTION_OPERATION [ITERABLE[ANY]]} ref_owner
		do
			if is_collection_of_basic_type (obj) then
				create {PS_BASIC_COLLECTION_WRITE[COLLECTION_TYPE] } Result.make (obj, ref_owner, attr_name, mode, is_in_relational_storage_mode)
			else
				create {PS_REFERENCE_COLLECTION_WRITE[COLLECTION_TYPE] } Result.make (obj, ref_owner, attr_name, mode, is_in_relational_storage_mode)
			end
		end


	do_disassemble (collection:PS_ABSTRACT_COLLECTION_OPERATION [COLLECTION_TYPE]; disassemble_function:FUNCTION[ANY, TUPLE[ANY], PS_ABSTRACT_DB_OPERATION])
		local
			cursor:ITERATION_CURSOR[ANY]
		do
			check attached{COLLECTION_TYPE} collection.object_id.item as actual_collection then

				cursor:= actual_collection.new_cursor
				from
				until cursor.after
				loop
					disassemble_function.call ([cursor.item])
				end
--				the following produces a reproducible bug in EiffelStudio, even when doing a clean compile...
--				across actual_collection as cursor loop disassemble_function.call ([cursor.item])  end

			end
		end


	is_in_relational_storage_mode :BOOLEAN
		deferred
		end


	-- Storing collections: The backends can either store collections based on their own POID (then they have to issue another update statement for their parents)
	-- or based on the poid of the parent (more relational, less flexible - e.g. it won't be possible to store collections directly that way)

end
