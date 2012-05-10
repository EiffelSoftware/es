note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ENTITY_MAPPING

inherit

	IV_SHARED_TYPES

	E2B_SHARED_CONTEXT

create
	make,
	make_copy

feature {NONE} -- Initialization

	make
			-- Initialize name mapping.
		do
			create {IV_ENTITY} current_expression.make (default_current_name, types.ref)
			result_expression := Void
			create heap.make (global_heap_name, types.heap_type)
			old_heap := Void
			create argument_mapping.make (5)
			create local_mapping.make (5)
		end

	make_copy (a_other: E2B_ENTITY_MAPPING)
			-- Initialize with data from `a_other'.
		do
			current_expression := a_other.current_expression
			result_expression := a_other.result_expression
			heap := a_other.heap
			old_heap := a_other.old_heap
			create argument_mapping.make (5)
			argument_mapping.copy (a_other.argument_mapping)
			create local_mapping.make (5)
			local_mapping.copy (a_other.local_mapping)
		end

feature -- Access

	current_expression: IV_EXPRESSION
			-- Expression for `Current'.

	current_entity: IV_ENTITY
			-- Entity for `Current'.
		do
			if attached {IV_ENTITY} current_expression as c then
				Result := c
			else
				check False end
			end
		end

	result_expression: IV_EXPRESSION
			-- Expression for `Result'.

	result_entity: IV_ENTITY
			-- Entity for `Result'.
		do
			if attached {IV_ENTITY} result_expression as r then
				Result := r
			else
				check False end
			end
		end

	argument (a_feature: FEATURE_I; a_type: TYPE_A; a_position: INTEGER): IV_EXPRESSION
			-- Argument of feature `a_feature' at position `a_position'.
		local
			l_name: STRING
			l_type: IV_TYPE
		do
			if argument_mapping.has_key (a_position) then
				Result := argument_mapping.item (a_position)
			else
				l_name := a_feature.arguments.item_name (a_position)
				l_type := types.for_type_in_context (a_feature.arguments.i_th (a_position), a_type)
				create {IV_ENTITY} Result.make (l_name, l_type)
			end
		end

	local_ (a_position: INTEGER): IV_EXPRESSION
			-- Local of feature `a_feature' at position `a_position'.
		do
			check local_mapping.has_key (a_position) end
			Result := local_mapping.item (a_position)
		end

	heap: IV_ENTITY
			-- Entity for heap.

	old_heap: detachable IV_ENTITY
			-- Entity for old heap.

	default_result_name: STRING = "Result"
			-- Default name for `Result'.

	default_current_name: STRING = "Current"
			-- Default name for `Current'.

	global_heap_name: STRING = "Heap"
			-- Name of global heap.

	bound_heap_name: STRING = "heap"
			-- Name of heap as bound variable.

feature -- Element change

	set_current (a_current: IV_EXPRESSION)
			-- Set `current_entity' to `a_current'.
		require
			a_current_attached: attached a_current
		do
			current_expression := a_current
		ensure
			current_expression_set: current_expression = a_current
		end

	set_result (a_result: IV_EXPRESSION)
			-- Set `result_expression' to `a_result'.
		require
			a_result_attached: attached a_result
		do
			result_expression := a_result
		ensure
			result_expression_set: result_expression = a_result
		end

	set_default_result (a_type: TYPE_A)
			-- Set `result_expression' to a default result entity fo type `a_type'.
		do
			create {IV_ENTITY} result_expression.make (default_result_name, types.for_type_a (a_type))
		end

	set_argument (a_position: INTEGER; a_expression: IV_EXPRESSION)
			-- Set arguement at position `a_position' to `a_expression'.
		do
			argument_mapping.extend (a_expression, a_position)
		end

	clear_arguments
			-- Clear argument mapping.
		do
			argument_mapping.wipe_out
		end

	set_local (a_position: INTEGER; a_expression: IV_EXPRESSION)
			-- Set local at position `a_position' to `a_expression'.
		do
			local_mapping.extend (a_expression, a_position)
		end

	clear_locals
			-- Clear local mapping.
		do
			local_mapping.wipe_out
		end

	set_heap (a_entity: IV_ENTITY)
			-- Set `heap' to `a_name'.
		require
			a_entity_attached: attached a_entity
		do
			heap := a_entity
		ensure
			heap_set: heap = a_entity
		end

	set_old_heap (a_entity: IV_ENTITY)
			-- Set `old_heap' to `a_name'.
		require
			a_entity_attached: attached a_entity
		do
			old_heap := a_entity
		ensure
			old_heap_set: old_heap = a_entity
		end

	clear_old_heap
			-- Set `old_heap_name' to Void.
		do
			old_heap := Void
		ensure
			old_heap_cleared: old_heap = Void
		end

feature {E2B_ENTITY_MAPPING} -- Implementation

	argument_mapping: HASH_TABLE [IV_EXPRESSION, INTEGER]
			-- Mapping for arguments.

	local_mapping: HASH_TABLE [IV_EXPRESSION, INTEGER]
			-- Mapping for locals.

end
