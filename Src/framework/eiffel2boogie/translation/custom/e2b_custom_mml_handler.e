note
	description: "Summary description for {E2B_CUSTOM_MML_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_MML_HANDLER

inherit
	E2B_CUSTOM_CALL_HANDLER

	E2B_CUSTOM_NESTED_HANDLER

	SHARED_WORKBENCH

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := helper.is_class_logical (a_target_type.base_class)
		end

	is_handling_nested (a_nested: NESTED_B): BOOLEAN
			-- <Precursor>
		do
			if
				not a_nested.target.type.is_like and then
				a_nested.target.type.base_class /= Void and then
				(a_nested.target.type.base_class.class_id = system.tuple_id or a_nested.target.type.base_class.class_id = system.array_id)
			then
				if attached {FEATURE_B} a_nested.message as f then
					Result := f.feature_name.same_string ("to_mml_set")
				end
			end
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			handle_routine_call (a_translator, a_feature, a_parameters)
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			handle_routine_call (a_translator, a_feature, a_parameters)
		end

	handle_binary (a_translator: E2B_EXPRESSION_TRANSLATOR; a_class: CLASS_C; a_left, a_right: IV_EXPRESSION; a_operator: STRING)
			-- Handle built-in (non alias) binary expression where `a_left' is of logical type.
		require
			eq_or_neq: a_operator ~ "==" or a_operator ~ "!="
		local
			l_eqs: like helper.class_note_values
			l_expr: IV_EXPRESSION
		do
			l_eqs := helper.class_note_values (a_class, "equality")
			if not l_eqs.is_empty then
				l_expr := factory.function_call (l_eqs.first, << a_left, a_right >>, types.bool)
			else
				l_expr := factory.equal (a_left, a_right)
			end
			if a_operator ~ "!=" then
				l_expr := factory.not_ (l_expr)
			end
			a_translator.set_last_expression (l_expr)
		end

	handle_nested_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- <Precursor>
		do
			handle_nested (a_translator, a_nested)
		end

	handle_nested_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- <Precursor>
		do
			handle_nested (a_translator, a_nested)
		end

feature {NONE} -- Implementation

	handle_routine_call (a_translator: E2B_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_fname: STRING
			l_fcall: IV_FUNCTION_CALL
			l_args: ARRAY [IV_EXPRESSION]
		do
			check helper.is_class_logical (a_translator.current_target_type.base_class) end
			l_fname := helper.string_feature_note_value (a_feature, "maps_to")
			if l_fname.is_empty then
					-- Use standard naming scheme
				l_fname := helper.class_note_values (a_translator.current_target_type.base_class, "maps_to").first + "#" +
					to_camel_case (a_feature.feature_name)
			end

			a_translator.process_parameters (a_parameters)

			if l_fname ~ "[]" then
					-- The feature maps to map access
				create l_args.make (1, a_translator.last_parameters.count)
				across
					a_translator.last_parameters as params
				loop
					l_args [params.target_index] := params.item
				end
				a_translator.set_last_expression (factory.map_access (a_translator.current_target, l_args))
			else
				if a_feature.has_return_value then
					create l_fcall.make (l_fname, types.for_type_a (a_feature.type))
					if not a_feature.is_external then
							-- We use external as static, so only add the target if not external
						l_fcall.add_argument (a_translator.current_target)
					end
				else
						-- Since logical classes are immutable, this must be a creation procedure
					create l_fcall.make (l_fname, types.for_type_a (a_translator.current_target_type))
				end
				across
					a_translator.last_parameters as params
				loop
					l_fcall.add_argument (params.item)
				end
				a_translator.set_last_expression (l_fcall)
			end
		end

	handle_nested (a_translator: E2B_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- Handle `a_nested'.
		local
			l_tuple: TUPLE_CONST_B
			l_array: ARRAY_CONST_B
			l_exprs: LINKED_LIST [IV_EXPRESSION]
			l_expr: IV_EXPRESSION
			l_elem_type: IV_TYPE
		do
			if attached {ACCESS_EXPR_B} a_nested.target as x then
				l_tuple ?= x.expr
				l_array ?= x.expr
			end
			check l_tuple /= Void or l_array /= Void end
			create l_exprs.make
			if l_tuple /= Void then
				across l_tuple.expressions as i loop
					i.item.process (a_translator)
					l_exprs.extend (a_translator.last_expression)
					if l_elem_type = Void then
						l_elem_type := a_translator.last_expression.type
					elseif l_elem_type /= a_translator.last_expression.type then
						-- TODO: signal an error
					end
				end
			else
				check l_array /= Void end
				across l_array.expressions as i loop
					i.item.process (a_translator)
					l_exprs.extend (a_translator.last_expression)
					if l_elem_type = Void then
						l_elem_type := a_translator.last_expression.type
					elseif l_elem_type /= a_translator.last_expression.type then
						-- TODO: signal an error
					end
				end
			end
			if l_exprs.is_empty then
				-- TODO: how to determine elem type here?
				a_translator.set_last_expression (
					factory.function_call ("Set#Empty", Void, types.set (types.ref)))
			else
				from
					l_exprs.start
					l_expr := factory.function_call ("Set#Singleton", << l_exprs.item >>, types.set (l_elem_type))
					l_exprs.forth
				until
					l_exprs.after
				loop
					l_expr := factory.function_call (
						"Set#Extended",
						<< l_expr, l_exprs.item >>,
						types.set (l_elem_type))
					l_exprs.forth
				end
				a_translator.set_last_expression (l_expr)
			end
		end

	to_camel_case (a_name: STRING): STRING
			-- Eiffel-style identifier `a_name' converted to camel case.
		local
			i: INTEGER
		do
			Result := a_name.string
			from
				i := 1
			until
				not Result.valid_index (i)
			loop
				Result.replace_substring (Result.substring (i, i).as_upper, i, i)
				i := Result.index_of ('_', i)
				if Result.valid_index (i) then
					Result.remove (i)
				end
			end
		end

end
