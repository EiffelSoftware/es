note
	description: "Calculates the boost as a frequency that property appears in transitions."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_FREQUENCY_BOOST
inherit
	SEM_BOOST_FUNCTION


feature {SEM_BOOST_FUNCTION, SEM_BOOST_CALCULATOR} -- Operation

	boost (a_queryable: SEM_QUERYABLE; a_equation: EPA_EQUATION; a_field: STRING): DOUBLE
			-- <precursor>
		local
			is_precond, is_postcond, is_written: BOOLEAN
			l_num_matching, l_count: INTEGER
			l_expr_text: STRING
			l_target_state: EPA_STATE
		do
			Result := default_boost
			if attached {SEM_FEATURE_CALL_TRANSITION}a_queryable as l_trans and not a_equation.value.is_nonsensical and not a_equation.has_error then
				if a_field.is_equal (precondition_field_prefix) then
					is_precond := true
				elseif a_field.is_equal (postcondition_field_prefix) then
					is_postcond := true
				end

				if is_precond then
					if l_trans.written_preconditions.has (a_equation) then
						Result := written_boost
						is_written := true
					end
				elseif is_postcond then
					if l_trans.written_postconditions.has (a_equation) then
						Result := written_boost
						is_written := true
					end
				end

				if not is_written then
					from
						queryables.start
						l_expr_text := a_queryable.typed_expression_text (a_equation.expression)
					until
						queryables.after
					loop
						if attached {SEM_FEATURE_CALL_TRANSITION}queryables.item as l_cur_trans then
							if l_cur_trans.feature_.feature_id = l_trans.feature_.feature_id and l_cur_trans.class_.class_id = l_trans.class_.class_id then
								l_num_matching := l_num_matching + 1

								if is_precond then
									l_target_state := l_cur_trans.precondition
								else
									l_target_state := l_cur_trans.postcondition
								end

								if has_typed_equation (l_cur_trans, l_target_state, l_expr_text, a_equation.value) then
									l_count := l_count + 1
								end
							end
						end

						queryables.forth
					end

					Result := l_count / l_num_matching
				end
			end
		end

feature {NONE} -- Implementation

	has_typed_equation (a_queryable: SEM_QUERYABLE; a_state: EPA_STATE; a_expression: STRING; a_value: EPA_EXPRESSION_VALUE): BOOLEAN
			-- Does `a_queryable' have `a_expression' with `a_value' in `a_state' ?
		local
			l_cur_expr: STRING
			l_done: BOOLEAN
			l_cursor: DS_HASH_SET_CURSOR[EPA_EQUATION]
		do
			from
				l_cursor := a_state.new_cursor
				l_cursor.start
			until
				l_cursor.after or l_done
			loop
				if not l_cursor.item.has_error and not l_cursor.item.value.is_nonsensical then
					l_cur_expr := a_queryable.typed_expression_text (l_cursor.item.expression)

					if l_cur_expr.is_equal (a_expression) then
						l_done := true
						Result := l_cursor.item.value.is_equal (a_value)
					end
				end

				l_cursor.forth
			end
		end
end
