note
	description: "Summary description for {PS_OBJECT_COLLECTION_PART}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[detachable ANY]]

inherit
	PS_COLLECTION_PART [COLLECTION_TYPE]

create make

feature -- Object storage mode data


	order_of (a_value: PS_OBJECT_GRAPH_PART) :INTEGER
		require
			part_of_values: values.has (a_value)
		do
			fixme ("TODO: some explicit mechanism to denote order, as the implicit order in 'values' is easy to break unintentionally")
		end

	additional_information: HASH_TABLE[STRING, STRING]
		-- Any additional information that the backend has to store

	add_information (description: STRING; value: STRING)
		do
			additional_information.extend (value, description)
		end


	add_value (a_graph_part: PS_OBJECT_GRAPH_PART)
		-- Add a value to the collection
		do
			values.extend (a_graph_part)
		end


	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- All operations that depend on this one
		do
			create Result.make
			Result.append(values)
			if attached deletion_dependency_for_updates as dep then
				Result.extend (dep)
			end
		end

	clone_except_values: like Current
		-- Create a copy of `Current', with the exception that the `values' list is empty
		do
			create Result.make (object_id,  write_mode, handler)
			Result.set_deletion_dependency (deletion_dependency_for_updates)
		end


	make (obj: PS_OBJECT_IDENTIFIER_WRAPPER; a_mode:PS_WRITE_OPERATION; a_handler: PS_COLLECTION_HANDLER[COLLECTION_TYPE])
		-- initialize `Current'
		local
			del_dependency: like Current
		do
			object_id:=obj
			create values.make
			handler:= a_handler
			create additional_information.make (10)
--			order_count:= 1

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


	is_in_relational_storage_mode:BOOLEAN = False
		-- Is current collection inserted in relational mode?

--	feature {NONE}

--		order_count: INTEGER

end
