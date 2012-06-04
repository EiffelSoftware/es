note
	description: "Summary description for {PS_RELATIONAL_COLLECTION_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONAL_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[detachable ANY]]
inherit
	PS_COLLECTION_PART [COLLECTION_TYPE]


create make


feature -- Relational storage mode data

	reference_owner:PS_OBJECT_GRAPH_PART
		-- An object that holds a reference to `Current.object_id'
		-- Please note that this is only required if the insertion happens in relational mode, and the design is flawed if more than one object holds a reference to this collection
		-- (this cannot really be mapped to relational databases anyway)

	reference_owner_attribute_name: STRING
		-- The attribute name of the reference_owner of the current collection.
		-- Please note that this is only required if the insertion happens in relational mode, and the design is flawed if more than one object holds a reference to this collection
		-- (this cannot really be mapped to relational databases anyway)


	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- All operations that depend on this one
		do
			create Result.make

			if handler.is_1_to_n_mapped (Current) then 	-- 1:N relational mode
				-- no dependency required as foreign keys are stored within the objects
			else -- M:N relational mode
				Result.append (values)
				Result.extend (reference_owner)
			end
			if attached deletion_dependency_for_updates as dep then
				Result.extend (dep)
			end
		end


	clone_except_values: like Current
		do
			create Result.make (object_id, reference_owner, reference_owner_attribute_name, write_mode, handler)
			Result.set_deletion_dependency (deletion_dependency_for_updates)
		end


	add_value (a_graph_part: PS_OBJECT_GRAPH_PART)
		-- Add a value to the collection
		do
			if handler.is_1_to_n_mapped (Current) then
				-- Add the value to the object instead
				check attached{PS_SINGLE_OBJECT_PART} a_graph_part as obj then -- everything else is covered by preconditions
					obj.add_attribute (reference_owner_attribute_name, Current)
				end
			else
				values.extend (a_graph_part)
			end
		end

	is_in_relational_storage_mode:BOOLEAN = True
		-- Is current collection inserted in relational mode?


feature {NONE}



	make (obj: PS_OBJECT_IDENTIFIER_WRAPPER; owner: PS_OBJECT_GRAPH_PART; attr_name: STRING ; a_mode:PS_WRITE_OPERATION; a_handler: PS_COLLECTION_HANDLER[COLLECTION_TYPE])
		-- initialize `Current'
		local
			del_dependency: like Current
		do
			object_id:=obj
			reference_owner:= owner
			reference_owner_attribute_name:= attr_name
			create values.make
			handler:= a_handler

			if a_mode = a_mode.update then
				write_mode:= a_mode.insert
				del_dependency:= clone_except_values
				del_dependency.set_mode (write_mode.delete)
				deletion_dependency_for_updates:= del_dependency
			else
--				deletion_dependency_for_updates:= handler.create_object_graph_part (obj, owner, attr_name, a_mode.no_operation)
				write_mode:= a_mode
			end
		ensure
			no_update_mode: write_mode /= write_mode.update
		end




end
