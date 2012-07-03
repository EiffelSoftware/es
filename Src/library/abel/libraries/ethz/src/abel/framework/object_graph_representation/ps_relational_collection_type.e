note
	description: "Summary description for {PS_RELATIONAL_COLLECTION_TYPE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_RELATIONAL_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[detachable ANY]]
inherit
	PS_COLLECTION_PART [COLLECTION_TYPE]


create make_new


feature {PS_EIFFELSTORE_EXPORT}-- Relational storage mode data

	reference_owner: PS_SINGLE_OBJECT_PART--PS_OBJECT_GRAPH_PART
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


	clone_except_values: PS_RELATIONAL_COLLECTION_PART [COLLECTION_TYPE]
		do
			--create Result.make (object_id, reference_owner, reference_owner_attribute_name, write_mode, handler)
			create {PS_RELATIONAL_COLLECTION_PART [COLLECTION_TYPE]} Result.make_new (represented_object, metadata, reference_owner, handler, root)
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

	add_additional_information
		do
		end

feature {NONE}


	make_new (obj:ANY; meta:PS_TYPE_METADATA; owner:PS_SINGLE_OBJECT_PART; a_handler:PS_COLLECTION_HANDLER[COLLECTION_TYPE]; a_root:PS_OBJECT_GRAPH_ROOT)
		local
			attr_name:STRING
			i:INTEGER
			reflection:INTERNAL
		do
			represented_object:= obj
			reference_owner:= owner
			create values.make
			handler:= a_handler
			internal_metadata:= meta
			root:= a_root

			from
				reference_owner_attribute_name:= ""
				create reflection
				i:=1
			until
				i > reflection.field_count (owner.represented_object)
			loop
				if reflection.field (i, owner.represented_object) = obj then
					reference_owner_attribute_name:= reflection.field_name (i, owner.represented_object)
				end
				i:= i+1
			end

			create write_mode
			write_mode:= write_mode.no_operation
		end

end
