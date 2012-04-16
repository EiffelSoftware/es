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
	-- if possible, don't deal with primary keys yet. use poids instead.


	-- Intermezzo: What is required for a recursive function disassemble?
		-- The current object
		-- The current object graph depth
		-- The mode (Insert, Update, Delete)
	-- What is required at the class level
		-- A place to get POIDs
		-- The starting object graph depth for all modes (and maybe some special modes if inserts during update are treated differently)
		-- An internal store
		-- Maybe a place to get object metadata
		-- the COLLECTION_HANDLER objects

	--How to deal with different conditions?
		-- Current depth reaches 0 (and global one not infinite)
			-- This object doesn't get inserted/updated any more, save for a special exception during update if the object is found to be new AND the references are followed.
			-- So creating a PS_NO_OPERATION usually is the correct behaviour
			-- If current object is a collection, there's no special case - as collections just forward the depth and don't decrease it

		-- is object known? Apply the rules below

		--  Check if a collection handler can manage current object - if yes, forward to it
			-- otherwise forward to plain object handler

	execute_disassembly (an_object:ANY; a_depth: INTEGER; a_mode: INTEGER)
	do
	--	disassembled_object:= disassemble (an_object, a_depth, a_mode)
	end

	disassembled_object: PS_ABSTRACT_DB_OPERATION
		require
			no_error: not has_error
		attribute
		end


	has_error: BOOLEAN



	disassemble (an_object:ANY; depth: INTEGER; mode:INTEGER): PS_ABSTRACT_DB_OPERATION
		-- Disassembles the object, returning a graph of database operations.
		local
			object_id: PS_OBJECT_IDENTIFIER_WRAPPER

			object_has_id:BOOLEAN
		do
			object_has_id:= id_manager.is_identified (an_object)

			if depth=0 and current_global_depth(mode) /= 0 then -- if global_depth = 0 -> infinite follow of references
				if object_has_id then
					create {PS_NO_OPERATION} Result.make ( id_manager.get_identifier_wrapper(an_object))
				elseif is_insert_during_update_enabled then
					-- call again disassemble on the same object with different parameters
					Result:=disassemble (an_object, custom_insert_depth_during_update, Insert)
				else
					create {PS_ERROR_PROPAGATION_OPERATION} Result.make
				end

			else --if depth > 0

				object_has_id:= id_manager.is_identified (an_object)

				inspect mode
					when Insert then
						if object_has_id then
							-- known object found - decide if we need to update or just set the correct poid.
							if is_update_during_insert_enabled then
								Result:= disassemble (an_object, custom_update_depth_during_insert, Update)
							else
								create {PS_NO_OPERATION} Result.make (id_manager.get_identifier_wrapper (an_object))
							end
						else
							id_manager.identify (an_object)
							Result:= perform_disassemble (an_object, depth, mode)
						end
					when Update then
						if object_has_id then
							Result:= perform_disassemble (an_object, depth, mode)
						else
							-- unknown object found - decide if we insert it or not
							if is_insert_during_update_enabled then
								Result:= disassemble (an_object, custom_insert_depth_during_update, Insert)
							else
								fixme ("decide on behaviour if no inserts should happen during update - throw exception or set reference to 0")
								create {PS_ERROR_PROPAGATION_OPERATION} Result.make
							end
						end
					when Delete then
						if object_has_id then
							Result:= perform_disassemble (an_object, depth, mode)
						else
							has_error:=True
							fixme ("Throw error - Unknown object for deletion")
							create {PS_ERROR_PROPAGATION_OPERATION} Result.make
						end
					else
						has_error:=True
						fixme ("Throw error - Implementation error in function disassemble")
						create {PS_ERROR_PROPAGATION_OPERATION} Result.make

				end
			end
		end

		perform_disassemble (an_object:ANY; depth: INTEGER; mode:INTEGER): PS_ABSTRACT_DB_OPERATION
			require
				object_known: id_manager.is_identified (an_object)
			local
				object_id: PS_OBJECT_IDENTIFIER_WRAPPER
			do
				object_id:= id_manager.get_identifier_wrapper (an_object)

				-- ask the internal store if the object is already disassembled (infinite recurion prevention)

					-- if yes, just return that object
				if internal_operation_store.has (object_id.object_identifier) then
					check attached internal_operation_store.item (object_id.object_identifier) as res then
						Result:= res
					end

				else
					-- ask all collection handlers if they can cope with the data structure
					-- if yes, give it to them, else call disassemble_plain_object

				end
				fixme ("TODO")
				create {PS_ERROR_PROPAGATION_OPERATION} Result.make

			end

		disassemble_plain_object: --PS_WRITE_OPERATION
			PS_ABSTRACT_DB_OPERATION
			do
		--		create Result.make_with_mode (object_id, next_mode)

				-- get all the basic values out

				-- if (depth > 1 or infinite) or (mode = Update and followRefs) then handle reference types:
					-- just call disassemble on each object with depth:= depth-1

				fixme ("TODO")
				create {PS_ERROR_PROPAGATION_OPERATION} Result.make

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

		current_global_depth (current_mode:INTEGER):INTEGER
			do
				inspect current_mode
				when Insert then
					Result:=global_insert_depth
				when Update then
					Result := global_update_depth
				else
					Result:= global_delete_depth
				end
			end

		is_insert_during_update_enabled:BOOLEAN
		is_update_during_insert_enabled:BOOLEAN

		internal_operation_store: HASH_TABLE[PS_ABSTRACT_DB_OPERATION, INTEGER]
			-- translates POIDs to operations.


		id_manager: PS_OBJECT_IDENTIFICATION_MANAGER


		Insert, Update, Delete:INTEGER = Unique -- fixme: common ancestor with abstract_db_operation


		make (an_id_manager: PS_OBJECT_IDENTIFICATION_MANAGER)
			do
				create internal_operation_store.make (100)
				create {PS_ERROR_PROPAGATION_OPERATION} disassembled_object.make
				id_manager:= an_id_manager
			end

end
