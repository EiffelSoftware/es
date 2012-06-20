note
	description: "Summary description for {PS_OBJECT_COLLECTION_PART}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[detachable ANY]]

inherit
	PS_COLLECTION_PART [COLLECTION_TYPE]
	redefine split end

create make

feature -- Object storage mode data


	order_of (a_value: PS_OBJECT_GRAPH_PART) :INTEGER
		require
			part_of_values: values.has (a_value)
		do
			across order_map as cursor loop
				if cursor.item.first = a_value then
					Result:= cursor.item.second
				end
			end
--			fixme ("TODO: some explicit mechanism to denote order, as the implicit order in 'values' is easy to break unintentionally")
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
			--values.extend (a_graph_part)
			add_value_explicit_order (a_graph_part, order_count)
			order_count:= order_count+1
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
			order_count:= 1
			create order_map.make

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


	split (a_dependency:PS_OBJECT_GRAPH_PART): like Current
		-- Create a copy of `Current', whose only dependency is `a_dependency', and with mode `Insert'
		do
			Result:= clone_except_values
			Result.set_mode (write_mode.insert)
			Result.add_value_explicit_order (a_dependency, order_of (a_dependency))
		end

feature {PS_OBJECT_COLLECTION_PART}

	add_value_explicit_order (val: PS_OBJECT_GRAPH_PART; order:INTEGER)
		do
			values.extend (val)
			order_map.extend (create {PS_PAIR[PS_OBJECT_GRAPH_PART, INTEGER]}.make (val, order))
		end


feature {NONE}

	order_count: INTEGER

	order_map: LINKED_LIST[PS_PAIR[PS_OBJECT_GRAPH_PART, INTEGER]]

end
