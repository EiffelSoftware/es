note
	description: "[
		Helper class to create IV-nodes.
	]"
	date: "$Date$"
	revision: "$Revision$"

frozen class
	IV_FACTORY

inherit

	IV_SHARED_TYPES
		rename
			equal as any_equal
		end

	E2B_SHARED_CONTEXT
		rename
			equal as any_equal
		export
			{NONE} all
		end

feature -- Values

	false_: IV_VALUE
			-- Value for constant `false'.
		do
			create Result.make ("false", types.bool)
		end

	true_: IV_VALUE
			-- Value for constant `true'.
		do
			create Result.make ("true", types.bool)
		end

	void_: IV_VALUE
			-- Value for constant `Void'.
		do
			create Result.make ("Void", types.ref)
		end

	int_value (a_value: INTEGER): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (a_value.out, types.int)
		end

	int64_value (a_value: INTEGER_64): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (a_value.out, types.int)
		end

	nat64_value (a_value: NATURAL_64): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (a_value.out, types.int)
		end

	type_value (a_value: TYPE_A): IV_VALUE
			-- Value for integer `a_value'.
		do
			create Result.make (name_translator.boogie_name_for_type (a_value), types.type)
		end

	default_value (a_type: TYPE_A): IV_EXPRESSION
			-- Default value for type `a_type'.
		require
			not_like_type: not a_type.is_like
		local
			l_boogie_type: IV_TYPE
		do
			l_boogie_type := types.for_type_a (a_type.deep_actual_type)
			if l_boogie_type.is_integer and l_boogie_type.is_boolean then
				-- Generic type
				create {IV_VALUE} Result.make ("Unknown", types.generic_type)
			elseif l_boogie_type.is_integer then
				Result := int_value (0)
			elseif l_boogie_type.is_boolean then
				Result := false_
			elseif l_boogie_type.is_real then
				create {IV_VALUE} Result.make ("0.0", l_boogie_type)
			elseif l_boogie_type.is_reference then
				Result := void_
			elseif l_boogie_type.is_set then
				Result := function_call ("Set#Empty", << >>, l_boogie_type)
			elseif l_boogie_type.is_seq then
				Result := function_call ("Seq#Empty", << >>, l_boogie_type)
			else
				check no_eiffel_type_for_this_boogie_type: False end
			end
		end

feature -- Boolean operators

	or_ (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Or operator `||'.
		do
			create Result.make (a_left, "||", a_right, types.bool)
		end

	or_clean (a_left, a_right: IV_EXPRESSION): IV_EXPRESSION
			-- Or operator `||', removing "false" disjuncts.
		do
			if a_left.is_false then
				Result := a_right
			elseif a_right.is_false then
				Result := a_left
			else
				create {IV_BINARY_OPERATION} Result.make (a_left, "||", a_right, types.bool)
			end
		end

	and_ (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- And operator `&&'.
		do
			create Result.make (a_left, "&&", a_right, types.bool)
		end

	and_clean (a_left, a_right: IV_EXPRESSION): IV_EXPRESSION
			-- Ads operator `&&', removing "true" conjuncts.
		do
			if a_left.is_true then
				Result := a_right
			elseif a_right.is_true then
				Result := a_left
			else
				create {IV_BINARY_OPERATION} Result.make (a_left, "||", a_right, types.bool)
			end
		end

	implies_ (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Implies operator `==>'.
		do
			create Result.make (a_left, "==>", a_right, types.bool)
		end

	equiv (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Equivalence operator `==>'.
		do
			create Result.make (a_left, "<==>", a_right, types.bool)
		end

	not_ (a_expr: IV_EXPRESSION): IV_UNARY_OPERATION
			-- Not operator `!'.
		do
			create Result.make ("!", a_expr, types.bool)
		end

feature -- Relational operators

	equal (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Equal operator `=='.
		do
			create Result.make (a_left, "==", a_right, types.bool)
		end

	not_equal (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Not equal operator `!='.
		do
			create Result.make (a_left, "!=", a_right, types.bool)
		end

	less_equal (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Less than or equal operator `<='.
		do
			create Result.make (a_left, "<=", a_right, types.bool)
		end

	less (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Less than operator `<'.
		do
			create Result.make (a_left, "<", a_right, types.bool)
		end

	sub_type (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Less than operator `<:'.
		do
			create Result.make (a_left, "<:", a_right, types.bool)
		end

feature -- Integer operators

	plus (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Plus operator `+'.
		do
			create Result.make (a_left, "+", a_right, types.int)
		end

	plus_one (a_expr: IV_EXPRESSION): IV_BINARY_OPERATION
			-- `a_expr + 1'.
		do
			Result := plus (a_expr, int_value (1))
		end

	minus (a_left, a_right: IV_EXPRESSION): IV_BINARY_OPERATION
			-- Plus operator `-'.
		do
			create Result.make (a_left, "-", a_right, types.int)
		end

	minus_one (a_expr: IV_EXPRESSION): IV_BINARY_OPERATION
			-- `a_expr - 1'.
		do
			Result := minus (a_expr, int_value (1))
		end

feature -- Functions

	type_of (a_arg: IV_EXPRESSION): IV_FUNCTION_CALL
			-- Function call `type_of (a_arg)'.
		do
			create Result.make ("type_of", types.type)
			Result.add_argument (a_arg)
		end

	old_ (a_arg: IV_EXPRESSION): IV_FUNCTION_CALL
			-- Function call `old (a_arg)'.
		do
			create Result.make ("old", a_arg.type)
			Result.add_argument (a_arg)
		end

	function_call (a_function_name: STRING; a_arguments: ARRAY [ANY]; a_result_type: IV_TYPE): IV_FUNCTION_CALL
			-- Function call to `a_function_name' with arguments `a_arguments'.
		do
			create Result.make (a_function_name, a_result_type)
			if attached a_arguments then
				across a_arguments as i loop
					if attached {STRING} i.item as s then
						Result.add_argument (create {IV_ENTITY}.make (s, types.generic_type))
					elseif attached {IV_EXPRESSION} i.item as e then
						Result.add_argument (e)
					else
						check False end
					end
				end
			end
		end

feature -- Heap and map access

	heap_current_allocated (a_mapping: E2B_ENTITY_MAPPING): IV_HEAP_ACCESS
			-- Heap access to `allocated' on `Current'.
		do
			create Result.make (
				a_mapping.heap.name,
				a_mapping.current_expression,
				create {IV_ENTITY}.make ("allocated", types.field (types.bool)))
		end

	heap_current_initialized (a_mapping: E2B_ENTITY_MAPPING): IV_HEAP_ACCESS
			-- Heap access to `allocated' on `Current'.
		do
			create Result.make (
				a_mapping.heap.name,
				a_mapping.current_expression,
				create {IV_ENTITY}.make ("initialized", types.field (types.bool)))
		end

	heap_current_access (a_mapping: E2B_ENTITY_MAPPING; a_name: STRING; a_content_type: IV_TYPE): IV_HEAP_ACCESS
			-- Heap access to `a_feature' on `Current'.
		do
			create Result.make (
				a_mapping.heap.name,
				a_mapping.current_expression,
				create {IV_ENTITY}.make (a_name, types.field (a_content_type)))
		end

	heap_access (a_heap_name: STRING; a_target: IV_EXPRESSION; a_name: STRING; a_content_type: IV_TYPE): IV_HEAP_ACCESS
			-- Heap access to `a_feature' on `Current'.
		do
			create Result.make (
				a_heap_name,
				a_target,
				create {IV_ENTITY}.make (a_name, types.field (a_content_type)))
		end

	array_access (a_heap: IV_ENTITY; a_array, a_index: IV_EXPRESSION): IV_MAP_ACCESS
			-- Array access to `a_array'[`a_index'].
		do
			create Result.make (
				create {IV_HEAP_ACCESS}.make (
					a_heap.name,
					a_array,
					create {IV_ENTITY}.make ("area", types.field (types.generic_type))),
				a_index)
		end

	map_access (a_map, a_index: IV_EXPRESSION): IV_MAP_ACCESS
			-- Map access to `a_map'[`a_index'].
		do
			create Result.make (a_map, a_index)
		end

feature -- Statements

	procedure_call (a_proc_name: STRING; a_arguments: ARRAY [ANY]): IV_PROCEDURE_CALL
			-- Procedure call.
		do
			create Result.make (a_proc_name)
			if attached a_arguments then
				across a_arguments as i loop
					if attached {STRING} i.item as s then
						Result.add_argument (create {IV_ENTITY}.make (s, types.generic_type))
					elseif attached {IV_EXPRESSION} i.item as e then
						Result.add_argument (e)
					else
						check False end
					end
				end
			end
		end

feature -- Framing

	writes_frame (a_feature: FEATURE_I; a_type: TYPE_A; a_boogie_procedure: IV_PROCEDURE; a_pre_heap: IV_EXPRESSION): IV_EXPRESSION
			-- Boolean expression stating that only the modifies set of `a_feature' in `a_type' (translated into `a_boogie_procedure')
			-- has changed between `a_pre_heap' and the current heap.
		local
			l_fcall: IV_FUNCTION_CALL
		do
			create l_fcall.make (name_translator.boogie_function_for_frame (a_feature, a_type), types.set (types.ref))
			l_fcall.add_argument (old_ (create {IV_ENTITY}.make ("Heap", types.heap_type)))
			across a_boogie_procedure.arguments as i loop
				l_fcall.add_argument (i.item.entity)
			end
			Result := function_call ("writes", <<a_pre_heap, "Heap", l_fcall>>, types.bool)
		end

feature -- Miscellaneous

	trace (a_text: STRING): IV_STATEMENT
			-- Tracing statement.
		local
			l_assume: IV_ASSUME
		do
			create l_assume.make (true_)
			l_assume.set_attribute_string (":captureState %"" + a_text + "%"")
			Result := l_assume
		end

end
