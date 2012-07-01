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


	execute_disassembly (an_object:ANY; a_mode:PS_WRITE_OPERATION; transaction: PS_TRANSACTION)
	do
		internal_operation_store.wipe_out
		int_transaction:= transaction
		disassembled_object:= disassemble (an_object, current_global_depth (a_mode), a_mode, create {PS_IGNORE_PART}.make, "root")
	end

	disassembled_object: PS_OBJECT_GRAPH_PART
		require
			no_error: not has_error
		attribute
		end


	has_error: BOOLEAN

	current_transaction: PS_TRANSACTION
		do
			Result:= attach (int_transaction)
		end

	int_transaction: detachable PS_TRANSACTION
	--counter: INTEGER

	disassemble (an_object:ANY; depth: INTEGER; mode:PS_WRITE_OPERATION; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING): PS_OBJECT_GRAPH_PART
		-- Disassembles the object, returning a graph of database operations.
		local
			object_id: PS_OBJECT_IDENTIFIER_WRAPPER
			collection_found:BOOLEAN
			object_has_id:BOOLEAN
		do

			fixme ( "[
				This function is really ugly - however, it works at the moment.
				
				At some time one could refactor it, like putting the logic to calculate the next write_mode, or the next graph part, into their own functions.
				
				Also, it is essential that the disassembler does not identify unidentified objects by itself. 
				This should be done by the WRITE_EXECUTOR.
				If that is done, we can implement the PS_RELATIONAL_REPOSITORY.can_handle feature


			]")

			object_has_id:= id_manager.is_identified (an_object, current_transaction)

			if id_manager.is_identified (an_object, current_transaction) and then internal_operation_store.has (id_manager.get_identifier_wrapper (an_object, current_transaction).object_identifier) then
				Result:= attach (internal_operation_store[id_manager.get_identifier_wrapper (an_object, current_transaction).object_identifier])
			else

			if depth=0 and current_global_depth(mode) /= settings.object_graph_depth_infinite then
				if object_has_id then
					-- see if we deal with a collection - those still have to be updated
					if collection_handlers.there_exists (agent {PS_COLLECTION_HANDLER[ITERABLE[ANY]]}.can_handle (an_object)) then
						Result:=perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
					else -- just return the correct poid
						create {PS_SINGLE_OBJECT_PART} Result.make_with_mode ( id_manager.get_identifier_wrapper(an_object, current_transaction), mode.No_operation)
					end
				elseif settings.is_insert_during_update_enabled then
					-- call again disassemble on the same object with different parameters
					Result:=disassemble (an_object, settings.custom_insert_depth_during_update, mode.Insert, reference_owner, ref_attribute_name)
				else
					create {PS_IGNORE_PART} Result.make
				end

			else --if depth > 0

				if mode = mode.Insert then
					if object_has_id then
						-- known object found - decide if we need to update or just set the correct poid.
						if settings.is_update_during_insert_enabled then
							Result:= disassemble (an_object, settings.custom_update_depth_during_insert, mode.Update, reference_owner, ref_attribute_name)
						else
		--					object_id:= id_manager.get_identifier_wrapper (an_object)
		--					if internal_operation_store.has (object_id.object_identifier) then
								--counter:= counter + 1
								--check counter<2 end
		--						Result:= attach (internal_operation_store[object_id.object_identifier])
								--print ("already known object found")
		--					else
								--check false end
								create {PS_SINGLE_OBJECT_PART} Result.make_with_mode ( id_manager.get_identifier_wrapper(an_object, current_transaction), mode.No_operation)
		--					end

						end
					else
						id_manager.identify (an_object, current_transaction)
						Result:= perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
					end
				elseif mode = mode.Update then
					if object_has_id then
						Result:= perform_disassemble (an_object, depth, mode, reference_owner, ref_attribute_name)
						--print ("blub")
					else
						-- unknown object found - decide if we insert it or not
						if settings.is_insert_during_update_enabled then
							Result:= disassemble (an_object, settings.custom_insert_depth_during_update, mode.Insert, reference_owner, ref_attribute_name)
						else
					--		fixme ("decide on behaviour if no inserts should happen during update - throw exception or set reference to 0")
							if settings.throw_error_for_unknown_objects then
								create {PS_IGNORE_PART} Result.make
								has_error:=True
							else
								create {PS_NULL_REFERENCE_PART} Result.make
							end
						end
					end
					--check false end
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
		end

		perform_disassemble (an_object:ANY; depth: INTEGER; mode:PS_WRITE_OPERATION; reference_owner:PS_OBJECT_GRAPH_PART; ref_attribute_name:STRING): PS_OBJECT_GRAPH_PART
			-- Checks if the operation for the object already exists and if not, issues the command to the plain_object feature or a collection handler.
			require
				object_known: id_manager.is_identified (an_object, current_transaction)
			local
				object_id: PS_OBJECT_IDENTIFIER_WRAPPER
				collection_found:BOOLEAN
				void_safety_default: PS_IGNORE_PART
			do
				create void_safety_default.make -- Void safety...
				Result:=void_safety_default
				object_id:= id_manager.get_identifier_wrapper (an_object, current_transaction)

				-- ask the internal store if the object is already disassembled (infinite recurion prevention)
					-- if yes, just return that object
				if internal_operation_store.has (object_id.object_identifier) then
					check attached internal_operation_store.item (object_id.object_identifier) as res then
						Result:= res
					end
				--	print ("blab")
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
				--print ("plain object")
				create Result.make_with_mode (id, mode)
				create reflection
				register_operation (Result, Result.object_id.object_identifier)

				from i:=1
				until i> reflection.field_count (id.item) or mode = mode.no_operation
				loop
					fixme ("Should this be an IF attached?")
					attr_name:= reflection.field_name (i, id.item)
					if attached reflection.field (i, id.item) as attr_value then
						attr_name:= reflection.field_name (i, id.item)
						if is_basic_type (attr_value) then
--							print ("basic attribute found: " + attr_name + "%N")
							create basic_attr.make (attr_value, id_manager.metadata_manager.create_metadata_from_object (attr_value))
							Result.add_attribute (attr_name, basic_attr)
							--if attr_name.is_case_insensitive_equal ("char_32_max") then
							--	print (attr_value.out)
							--end
--							Result.basic_attributes.extend (attr_name)
--							Result.basic_attribute_values.extend (attr_value, attr_name)

						else
							--check false end
							-- if (depth > 1 or infinite) or (mode = Update and followRefs) then handle reference types:
--							print ("complex attribute found: "+attr_name +"%N")

							if depth > 1 or current_global_depth(mode) = settings.object_graph_depth_infinite or (depth=1 and settings.update_last_references and mode=mode.Update) then
								ref_value:= disassemble (attr_value, depth-1, mode, Result, attr_name)
								Result.add_attribute (attr_name, ref_value)
--								if not attached{PS_IGNORE_PART} ref_value then
--									Result.references.extend (attr_name)
--									Result.reference_values.extend (ref_value, attr_name)
--								end
							end
						end
					else
--						print ("void field found")
						--check false end
					end
					i:= i+1
				end
			end

		is_basic_type (obj:ANY):BOOLEAN
		do
				fixme ("TODO")
			Result:=attached{NUMERIC} obj or attached{BOOLEAN} obj or attached{CHARACTER_8} obj or attached{CHARACTER_32} obj or attached{READABLE_STRING_GENERAL} obj
	--			or attached{SPECIAL[ANY]} obj
		end


		register_operation (an_operation:PS_OBJECT_GRAPH_PART; a_poid:INTEGER)
			do
				internal_operation_store.extend (an_operation, a_poid)
			end

		current_global_depth (mode:PS_WRITE_OPERATION):INTEGER
			do
				fixme ("support custom depths")
				if mode = mode.Insert then
					Result:=settings.insert_depth
				elseif mode = mode.update then
					Result := settings.update_depth
				elseif mode = mode.delete then
					Result:= settings.deletion_depth
				else
					Result := 1
				end
			end



		internal_operation_store: HASH_TABLE[PS_OBJECT_GRAPH_PART, INTEGER]
			-- translates POIDs to operations.


		id_manager: PS_OBJECT_IDENTIFICATION_MANAGER

--			collection_handlers: LINKED_LIST[PS_COLLECTION_HANDLER[ITERABLE[ANY]]]
		settings: PS_OBJECT_GRAPH_SETTINGS

		collection_handlers: LINKED_LIST[PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]]]

		add_handler (a_handler: PS_COLLECTION_HANDLER[ITERABLE[detachable ANY]])
			do
				collection_handlers.extend (a_handler)
			end

feature {NONE} -- Helper functions

	next_level (current_level:INTEGER; current_persistent:BOOLEAN; current_is_collection:BOOLEAN; next_persistent:BOOLEAN):INTEGER
		do
			if next_persistent /= current_persistent then
				Result:= 0
			else
				if current_is_collection then
					Result:= current_level
				else
					Result:= current_level + 1
				end
			end
		end

	next_operation (current_operation: PS_WRITE_OPERATION; current_level:INTEGER; current_persistent:BOOLEAN; next_persistent:BOOLEAN):PS_WRITE_OPERATION
		do
			Result:= current_operation.no_operation

			if current_level < current_global_depth (current_operation) or current_global_depth(current_operation) = settings.object_graph_depth_infinite then
				if current_persistent = next_persistent then
					Result:= current_operation
				elseif current_operation = current_operation.update and not next_persistent and settings.is_insert_during_update_enabled then
					Result:= current_operation.insert
				elseif current_operation = current_operation.insert and next_persistent and settings.is_update_during_insert_enabled then
					Result:= current_operation.update
				end
			end
		end

	is_next_persistent (next_object:ANY):BOOLEAN
		do
			if not is_basic_type (next_object) then
				Result:= id_manager.is_identified (next_object, current_transaction)
			else
				Result:= False
			end
		end

	next_object_graph_part (next_object:detachable ANY; current_part:PS_OBJECT_GRAPH_PART; current_operation:PS_WRITE_OPERATION):PS_OBJECT_GRAPH_PART

		do
			if attached next_object as object  then
				if is_basic_type (object) then
					create {PS_BASIC_ATTRIBUTE_PART} Result.make (object, id_manager.metadata_manager.create_metadata_from_object (object))
				else

					if is_in_store (object) then
						Result:= get_from_store (object)
					else
						if across collection_handlers as handler some handler.item.can_handle (object) end then
							Result:= create_collection_part (object, current_part, current_operation)
						else
							if current_operation = current_operation.update and not is_next_persistent (next_object) and not settings.is_insert_during_update_enabled then
								if settings.throw_error_for_unknown_objects then
									has_error:= True
								end
								create {PS_NULL_REFERENCE_PART} Result.make
							else
								create {PS_SINGLE_OBJECT_PART} Result.make_new (object,id_manager.metadata_manager.create_metadata_from_object (object), is_next_persistent (object))
							end
						end
						store (Result)
					end
				end

			else
				create {PS_IGNORE_PART} Result.make
			end
		end

	create_collection_part (next_object:ANY; current_part:PS_OBJECT_GRAPH_PART; current_operation:PS_WRITE_OPERATION):PS_OBJECT_GRAPH_PART
		do
			create {PS_IGNORE_PART} Result.make

			across collection_handlers as cursor loop
				if cursor.item.can_handle (next_object) then
					Result:= cursor.item.create_part (next_object, id_manager.metadata_manager.create_metadata_from_object (next_object), current_part)
				end
			end

		end


feature {NONE} -- Bookkeeping

	internal_store: LINKED_LIST[PS_OBJECT_GRAPH_PART]

	is_in_store (an_object:ANY):BOOLEAN
		do
			Result := across internal_store as cursor some cursor.item.represented_object = an_object end
		end

	store (a_part: PS_OBJECT_GRAPH_PART)
		require
			a_part.is_representing_object and not a_part.is_basic_attribute
		do
			internal_store.extend (a_part)
		end

	get_from_store (object:ANY):PS_OBJECT_GRAPH_PART
		do
			Result := internal_store.item
			across internal_store as cursor loop
				if cursor.item.represented_object = object then
					Result:= cursor.item
				end
			end
		end

feature{NONE} -- Initialization

		make (an_id_manager: PS_OBJECT_IDENTIFICATION_MANAGER; graph_settings: PS_OBJECT_GRAPH_SETTINGS)
			do
				create internal_operation_store.make (100)
				create {PS_IGNORE_PART} disassembled_object.make
				id_manager:= an_id_manager
				create collection_handlers.make
				settings:= graph_settings
				create internal_store.make
			end



end
