note
	description: "Represents a collection in an object graph. It stores a superset of all the data required for either an object or relational storage mode"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_COLLECTION_PART [COLLECTION_TYPE -> ITERABLE[detachable ANY]]
inherit
	PS_COMPLEX_ATTRIBUTE_PART

inherit{NONE}
	REFACTORING_HELPER


feature {PS_EIFFELSTORE_EXPORT}-- Collection data

	values:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- The objects in the collection

	add_value (a_graph_part: PS_OBJECT_GRAPH_PART)
		-- Add a value to the collection
		require
			no_mixed_type_collections: not values.is_empty implies values[1].is_basic_attribute = a_graph_part.is_basic_attribute
			no_basic_type_in_relational_mode: is_in_relational_storage_mode implies not a_graph_part.is_basic_attribute
			no_multidimensional_collections_in_relational_mode: is_in_relational_storage_mode implies not attached{PS_COLLECTION_PART[ITERABLE[ANY]]} a_graph_part
		deferred
		end


feature {PS_EIFFELSTORE_EXPORT}-- Status report

	are_items_of_basic_type:BOOLEAN
		-- are the current collection's items of a basic type?
		require
			not values.is_empty
		do
			Result:= values[1].is_basic_attribute
		end

	handler: PS_COLLECTION_HANDLER[COLLECTION_TYPE]

	is_in_relational_storage_mode:BOOLEAN
		-- Is current collection inserted in relational mode?
		deferred
		end


feature {PS_EIFFELSTORE_EXPORT}-- Dependency handling



--	dependencies:LINKED_LIST[PS_OBJECT_GRAPH_PART]
		-- All operations that depend on this one

--			fixme ("[
--				TODO: Getting the dependencies is tricky... In object mode, it's all items in `values'.
--				In relational mode, it can either be all the 'values' plus the parent, or every item in 'values' additionally has the dependency 'parent'.
--				Asking the handler what to do might be the best solution.
--				In case of an Update, probably there should be a Delete generated first, which is also a dependency of Current.
--				]"
--				)


	remove_dependency (obj:PS_OBJECT_GRAPH_PART)
		-- Remove dependency `obj' from the list
		do
			fixme ("TODO: The planner can't just take away a dependency like the 'parent' in case of relational mode - Investigate if this is actually possible")
			values.prune (obj)
		end

	split (a_dependency:PS_OBJECT_GRAPH_PART): like Current
		-- Create a copy of `Current', whose only dependency is `a_dependency', and with mode `Insert'
		do
			Result:= clone_except_values
			Result.set_mode (write_mode.insert)
			Result.values.extend (a_dependency)
		ensure
			Result.write_mode = write_mode.insert
			Result.values.count = 1
			Result.values.i_th (1) = a_dependency
		end


	clone_except_values: like Current
		-- Create a copy of `Current', with the exception that the `values' list is empty
		require
			not_in_delete_mode: write_mode /= write_mode.delete
		deferred
		end


feature {PS_COLLECTION_PART} -- Deletion dependency

	set_deletion_dependency (a_dep: detachable like Current)
		do
			deletion_dependency_for_updates:= a_dep
		end

	deletion_dependency_for_updates: detachable like Current
		-- If `Current' is an update, the collection needs to be deleted and inserted again. This is the statement to delete it.

	set_mode (a_mode: PS_WRITE_OPERATION)
		do
			write_mode:= a_mode
		end


feature {NONE} -- Initialization





invariant
	same_types: values.for_all (agent {PS_OBJECT_GRAPH_PART}.is_basic_attribute)  or not values.for_all (agent {PS_OBJECT_GRAPH_PART}.is_basic_attribute)
	deletion_dependency_mode_correct: attached deletion_dependency_for_updates as dep implies dep.write_mode = dep.write_mode.delete
end
