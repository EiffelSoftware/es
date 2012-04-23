note
	description: "This class follows the object graph and collects information necessary to perform write operations."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_DISASSEMBLER

inherit
	PS_EIFFELSTORE_EXPORT

inherit {NONE}
	REFACTORING_HELPER

create make

feature {PS_EIFFELSTORE_EXPORT}

-- Todo: The algorithm is currently broken: an object that has already been inserted with depth X won't change its depth if the disassembler finds it again at a later stage with depth >X


	execute_disassembly (an_object:ANY; a_depth: INTEGER; a_mode: INTEGER)
	do
	--	disassembled_object:= disassemble (an_object, a_depth, a_mode)
	end

	disassembled_object: PS_OBJECT_GRAPH_PART
		require
			no_error: not has_error
		attribute
		end


	has_error: BOOLEAN



	disassemble (an_object:ANY; depth: INTEGER; mode:PS_WRITE_OPERATION; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING): PS_OBJECT_GRAPH_PART
		-- Disassembles the object, returning a graph of database operations.
		local
			object_id: PS_OBJECT_IDENTIFIER_WRAPPER
			collection_found:BOOLEAN
			object_has_id:BOOLEAN
		do
			object_has_id:= id_manager.is_identified (an_object)

			if depth=0 and current_global_depth(mode) /= Infinite then
				if object_has_id then
					-- see if we deal with a collection - those still have to be updated
					if collection_handlers.there_exists (agent {PS_COLLECTION_HANDLER[ITERABLE[ANY]]}.can_handle (an_object)) then
						Result:=perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
					else -- just return the correct poid
						create {PS_SINGLE_OBJECT_PART} Result.make_with_mode ( id_manager.get_identifier_wrapper(an_object), mode.No_operation)
					end
				elseif is_insert_during_update_enabled then
					-- call again disassemble on the same object with different parameters
					Result:=disassemble (an_object, custom_insert_depth_during_update, mode.Insert, reference_owner, ref_attribute_name)
				else
					create {PS_IGNORE_PART} Result.make
				end

			else --if depth > 0

				if mode = mode.Insert then
					if object_has_id then
						-- known object found - decide if we need to update or just set the correct poid.
						if is_update_during_insert_enabled then
							Result:= disassemble (an_object, custom_update_depth_during_insert, mode.Update, reference_owner, ref_attribute_name)
						else
							create {PS_SINGLE_OBJECT_PART} Result.make_with_mode ( id_manager.get_identifier_wrapper(an_object), mode.No_operation)
						end
					else
						id_manager.identify (an_object)
						Result:= perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
					end
				elseif mode = mode.Update then
					if object_has_id then
						Result:= perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
					else
						-- unknown object found - decide if we insert it or not
						if is_insert_during_update_enabled then
							Result:= disassemble (an_object, custom_insert_depth_during_update, mode.Insert, reference_owner, ref_attribute_name)
						else
					--		fixme ("decide on behaviour if no inserts should happen during update - throw exception or set reference to 0")
							if is_report_error_for_new_objects_during_insert_enabled then
								create {PS_IGNORE_PART} Result.make
								has_error:=True
							else
								create {PS_NULL_REFERENCE_PART} Result.make
							end
						end
					end
				elseif mode = mode.Delete then
					if object_has_id then
						Result:= perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
					else
						has_error:=True
						fixme ("Throw error - Unknown object for deletion")
						create {PS_IGNORE_PART} Result.make
					end
				else
					has_error:=True
					fixme ("Throw error - Implementation error in function disassemble")
					create {PS_IGNORE_PART} Result.make
				end
			end
		end

		perform_disassemble (an_object:ANY; depth: INTEGER; mode:PS_WRITE_OPERATION; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING): PS_OBJECT_GRAPH_PART
			-- Checks if the operation for the object already exists and if not, issues the command to the plain_object feature or a collection handler.
			require
				object_known: id_manager.is_identified (an_object)
			local
				object_id: PS_OBJECT_IDENTIFIER_WRAPPER
				collection_found:BOOLEAN
				void_safety_default: PS_IGNORE_PART
			do
				create void_safety_default.make -- Void safety...
				Result:=void_safety_default
				object_id:= id_manager.get_identifier_wrapper (an_object)

				-- ask the internal store if the object is already disassembled (infinite recurion prevention)
					-- if yes, just return that object
				if internal_operation_store.has (object_id.object_identifier) then
					check attached internal_operation_store.item (object_id.object_identifier) as res then
						Result:= res
					end

				else
					-- ask all collection handlers if they can cope with the data structure
					collection_found:=False
					across collection_handlers as collection_cursor
					loop
						if collection_cursor.item.can_handle (an_object) then
							-- if yes, give it to them,
							Result:= collection_cursor.item.disassemble_collection (object_id, depth, mode, Current, reference_owner, ref_attribute_name)
							collection_found:=True
						end
					end
					-- else call disassemble_plain_object
					if not collection_found then
						Result:=disassemble_plain_object (object_id, depth, mode, reference_owner, ref_attribute_name)
					end
				end

				-- just a little check ensuring correctness (unfortunately not possible in postcondition)
				check Result /= void_safety_default end

			end

		disassemble_plain_object (id: PS_OBJECT_IDENTIFIER_WRAPPER; depth: INTEGER; mode:PS_WRITE_OPERATION; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING): PS_SINGLE_OBJECT_PART
				-- disassembles a normal object, and recursively calls disassemble on reference types.
			local
				reflection:INTERNAL
				i:INTEGER
				attr_name:STRING
				ref_value:PS_OBJECT_GRAPH_PART
				basic_attr:PS_BASIC_ATTRIBUTE_PART
			do
				create Result.make_with_mode (id, mode)
				create reflection

				from i:=1
				until i< reflection.field_count (id.item)
				loop
					fixme ("Should this be an IF attached?")
					check attached reflection.field (i, id.item) as attr_value then
						attr_name:= reflection.field_name (i, id.item)
						if is_basic_type (attr_value) then
							create basic_attr.make (attr_value)
							Result.add_attribute (attr_name, basic_attr)
--							Result.basic_attributes.extend (attr_name)
--							Result.basic_attribute_values.extend (attr_value, attr_name)

						else
							-- if (depth > 1 or infinite) or (mode = Update and followRefs) then handle reference types:
							if depth > 1 or current_global_depth(mode) = Infinite or (depth=1 and update_references_at_depth_1 and mode=mode.Update) then
								ref_value:= disassemble (attr_value, depth-1, mode, Result, attr_name)
								Result.add_attribute (attr_name, ref_value)
--								if not attached{PS_IGNORE_PART} ref_value then
--									Result.references.extend (attr_name)
--									Result.reference_values.extend (ref_value, attr_name)
--								end
							end
						end
					end
				end
			end

		is_basic_type (obj:ANY):BOOLEAN
		do
				fixme ("TODO")
			Result:=True
		end


		register_operation (an_operation:PS_OBJECT_GRAPH_PART; a_poid:INTEGER)
			do
				internal_operation_store.extend (an_operation, a_poid)
			end

		global_insert_depth:INTEGER
		global_update_depth:INTEGER
		global_delete_depth:INTEGER

		custom_insert_depth_during_update:INTEGER
			do
				Result:=global_insert_depth
			end

		custom_update_depth_during_insert:INTEGER
			do
				Result:=global_update_depth
			end

		current_global_depth (mode:PS_WRITE_OPERATION):INTEGER
			do
				if mode = mode.Insert then
					Result:=global_insert_depth
				elseif mode = mode.update then
					Result := global_update_depth
				elseif mode = mode.delete then
					Result:= global_delete_depth
				else
					Result := 1
				end
			end

		is_insert_during_update_enabled:BOOLEAN
		is_update_during_insert_enabled:BOOLEAN
		update_references_at_depth_1:BOOLEAN
		is_report_error_for_new_objects_during_insert_enabled:BOOLEAN = False


		internal_operation_store: HASH_TABLE[PS_OBJECT_GRAPH_PART, INTEGER]
			-- translates POIDs to operations.


		id_manager: PS_OBJECT_IDENTIFICATION_MANAGER

		collection_handlers: LINKED_LIST[PS_COLLECTION_HANDLER[ITERABLE[ANY]]]


		Infinite:INTEGER = 0 -- Infinite follow of references

		make (an_id_manager: PS_OBJECT_IDENTIFICATION_MANAGER)
			do
				create internal_operation_store.make (100)
				create {PS_IGNORE_PART} disassembled_object.make
				id_manager:= an_id_manager
				create collection_handlers.make
			end



		-- TODO: The write planner has to detect ABSTRACT_COLLECTION_OPERATIONs in relational mode and remove their attribute from the reference holders attribute table.
		-- The reason why we can't do this here is that - as this is a graph dependency graph with one root node - we will lose the collection operation and maybe even some of its references.

end
