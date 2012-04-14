note
	description: "Summary description for {PS_COLLECTION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_HANDLER [COLLECTION_TYPE -> ITERABLE[ANY]]


feature

	can_handle (a_collection:ANY):BOOLEAN
		-- Can `Current' handle the collection `a_collection'?
		do
			Result:= attached {COLLECTION_TYPE} a_collection
		end

	is_collection_of_basic_type (a_collection:PS_OBJECT_IDENTIFIER_WRAPPER): BOOLEAN
		do
			--TODO
			Result:=True
		end

	disassemble_collection (a_collection:ANY; a_disassembler:PS_OBJECT_DISASSEMBLER):
				detachable -- delete this line
			PS_ABSTRACT_COLLECTION_OPERATION
		-- disassemble the collection
		require
			can_handle_collection: can_handle (a_collection)
		do
			-- a_disassembler.get_poid

			--Result := create_result (poid, parent, attr_name, mode)
			-- a_disassembler.register_at_internal_store

			-- do actual business code, use agent to disassemble all referenced objects
		--	do_disassemble (Result, agent a_disassembler (?, --right_depths, mode)





		end


	create_result (obj, parent: PS_OBJECT_IDENTIFIER_WRAPPER ; attr_name: STRING ; write_mode:INTEGER) : PS_ABSTRACT_COLLECTION_OPERATION
		do
			if is_collection_of_basic_type (obj) then
				create { PS_BASIC_COLLECTION_WRITE[COLLECTION_TYPE] } Result.make (obj, parent, attr_name, write_mode)
			else
				create {PS_REFERENCE_COLLECTION_WRITE[COLLECTION_TYPE] } Result.make (obj, parent, attr_name, write_mode)
			end
		end


	do_disassemble (collection:PS_ABSTRACT_COLLECTION_OPERATION; disassemble:FUNCTION[ANY, TUPLE[ANY], PS_ABSTRACT_DB_OPERATION])
		deferred
			-- usually: across actual_collection as c loop
			--		collection.references.extend(disassemble.call(c))
		end


end
