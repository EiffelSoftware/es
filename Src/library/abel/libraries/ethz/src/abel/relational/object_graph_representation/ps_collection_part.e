note
	description: "Represents a collection in an object graph. It stores a superset of all the data required for either an object or relational storage mode"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[detachable ANY]]
inherit
	PS_COMPLEX_ATTRIBUTE_PART

inherit{NONE}
	REFACTORING_HELPER

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


feature -- Object storage mode data

	-- inherited feature object_id

	order
		do
			fixme ("TODO: some explicit mechanism to denote order, as the implicit order in 'values' is easy to break unintentionally")
		end

feature -- Data for both modes

	values:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- The objects in the collection

	add_value (a_graph_part: PS_OBJECT_GRAPH_PART)
		-- Add a value to the collection
		require
			no_mixed_type_collections: not values.is_empty implies values[1].is_basic_attribute = a_graph_part.is_basic_attribute
			no_basic_type_in_relational_mode: handler.is_in_relational_storage_mode (Current) implies not a_graph_part.is_basic_attribute
			no_multidimensional_collections_in_relational_mode: handler.is_in_relational_storage_mode (Current) implies not attached{PS_COLLECTION_PART[ITERABLE[ANY]]} a_graph_part
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


feature -- Status report

	are_items_of_basic_type:BOOLEAN
		-- are the current collection's items of a basic type?
		require
			not values.is_empty
		do
			Result:= values[1].is_basic_attribute
		end

	handler: PS_COLLECTION_HANDLER[COLLECTION_TYPE]



--	is_in_relational_mode:BOOLEAN
		-- Is current collection inserted in relational mode?



--	capacity: INTEGER
		-- The collections capacity, if fixed.

--	set_capacity (cap: INTEGER)
--		do
--			capacity:=cap
--		end

feature -- Dependency handling



	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- All operations that depend on this one
		do
--			fixme ("[
--				TODO: Getting the dependencies is tricky... In object mode, it's all items in `values'.
--				In relational mode, it can either be all the 'values' plus the parent, or every item in 'values' additionally has the dependency 'parent'.
--				Asking the handler what to do might be the best solution.
--				In case of an Update, probably there should be a Delete generated first, which is also a dependency of Current.
--				]"
--				)
			create Result.make

			if handler.is_1_to_n_mapped (Current) then 	-- 1:N relational mode
				-- no dependency required as foreign keys are stored within the objects
			elseif handler.is_in_relational_storage_mode (Current) then -- M:N relational mode
				Result.append (values)
				Result.extend (reference_owner)
			else	-- Object mode
				Result.append(values)
			end
			if attached deletion_dependency_for_updates as dep then
				Result.extend (dep)
			end
		end

	remove_dependency (obj:PS_OBJECT_GRAPH_PART)
		-- Remove dependency `obj' from the list
		do
			fixme ("TODO: The planner can't just take away a dependency like the 'parent' in case of relational mode - Investigate if this is actually possible")
			values.prune (obj)
		end

	split (a_dependency:PS_OBJECT_GRAPH_PART): like Current
		-- Create a copy of `Current', whose only dependency is `a_dependency', and with mode `Insert'
		do
			--fixme ("TODO: if Current is an update operation, make sure that the deletion happens before any of the two inserts after a split.")
			Result:= clone_except_values
			Result.values.extend (a_dependency)
		end


	clone_except_values: like Current
		-- Create a copy of `Current', with the exception that the `values' list is empty
		do
			Result:= handler.create_object_graph_part (object_id, reference_owner, reference_owner_attribute_name, write_mode)
			Result.set_deletion_dependency (deletion_dependency_for_updates)
		end


feature {PS_COLLECTION_PART} -- Deletion dependency

	set_deletion_dependency (a_dep: detachable like Current)
		do
			deletion_dependency_for_updates:= a_dep
		end

	deletion_dependency_for_updates: detachable like Current
		-- If `Current' is an update, the collection needs to be deleted and inserted again. This is the statement to delete it.


feature {NONE} -- Initialization

	make (obj: PS_OBJECT_IDENTIFIER_WRAPPER; owner: PS_OBJECT_GRAPH_PART; attr_name: STRING ; a_mode:PS_WRITE_OPERATION; a_handler: PS_COLLECTION_HANDLER[COLLECTION_TYPE])
		-- initialize `Current'
		do
			object_id:=obj
			reference_owner:= owner
			reference_owner_attribute_name:= attr_name
			create values.make
			handler:= a_handler

			if a_mode = a_mode.update then
				deletion_dependency_for_updates:= handler.create_object_graph_part (obj, owner, attr_name, a_mode.delete)
				write_mode:= a_mode.insert
			else
--				deletion_dependency_for_updates:= handler.create_object_graph_part (obj, owner, attr_name, a_mode.no_operation)
				write_mode:= a_mode
			end
		ensure
			no_update_mode: write_mode /= write_mode.update
		end



invariant
	same_types: dependencies.for_all (agent {PS_OBJECT_GRAPH_PART}.is_basic_attribute)  or not dependencies.for_all (agent {PS_OBJECT_GRAPH_PART}.is_basic_attribute)
end
