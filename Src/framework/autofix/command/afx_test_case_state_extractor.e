note
	description: "Summary description for {AFX_TEST_CASE_STATE_EXTRACTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_CASE_STATE_EXTRACTOR

create
	make

feature{NONE} -- Initialization

	make (a_file_name: STRING)
			-- Initialize Current.
			-- `a_file_name' is the full path indicating a test case file.
		do
			file_name := a_file_name.twin
			create states.make (20)
			states.compare_objects
			analyze
		end

feature -- Access

	file_name: STRING
		-- Full path indicating a test case file

	states: HASH_TABLE [NATURAL_8, STRING]
			-- Object states stored in the test case
			-- Key is predicate name,
			-- Value is the value of that predicate.
			-- The predicate name is prefixed with the object index. For example,
			-- a predicate `is_empty' in the first object is renamed as "v1_is_empty".

feature -- Constants

	boolean_true: NATURAL_8 = 1
	boolean_false: NATURAL_8 = 2
	value_unknown: NATURAL_8 = 128

	integer_zero: NATURAL_8 = 1
	integer_positive: NATURAL_8 = 2
	integer_negative: NATURAL_8 = 4

feature{NONE} -- Implementation

	analyze
			-- Analyze test case indicated by `file_name' and store result in `states'.
		local
			l_file: PLAIN_TEXT_FILE
			l_done: BOOLEAN
			l_in_state: BOOLEAN
			l_lines: LINKED_LIST [STRING]
			l_line: STRING
			l_var_index: INTEGER
			l_parts: LIST [STRING]
			l_expr: STRING
			l_value: STRING
			l_final_expr: STRING
		do
			create l_lines.make
			create l_file.make_open_read (file_name)
			l_var_index := 0
			from
				l_file.read_line
			until
				l_file.after or l_done
			loop
				if l_file.last_string.has_substring (once "-- Object states") then
					l_in_state := True
				elseif l_file.last_string.has_substring (once "-- Exception trace") then
					l_done := True
				elseif l_in_state then
					l_line := l_file.last_string.twin
					l_line.left_adjust
					l_line.right_adjust
					if not l_line.is_empty then
						if l_line.starts_with (once "-- ") then
								-- It is a variable description.
							l_var_index := l_var_index + 1
						elseif l_line.starts_with (once "--|") then
								-- It is an expression description.
							l_line.remove_head (3)
							l_parts := l_line.split ('=')
							if l_parts.count = 2 then
									-- Contruct the final expression name by prefixing it with object index.
								l_expr := l_parts.first
								l_expr.left_adjust
								l_expr.right_adjust
								l_value := l_parts.last
								l_value.left_adjust
								l_value.right_adjust
								if not l_expr.is_empty and then not l_value.is_empty then
									create l_final_expr.make (30)
									l_final_expr.append_character ('v')
									l_final_expr.append_integer (l_var_index)
									l_final_expr.append_character ('_')
									l_final_expr.append (l_expr)
									update_value (l_final_expr, l_value)
								end
							end
						end
					end
				end
				l_file.read_line
			end
			l_file.close
		end

	update_value (a_expression: STRING; a_value: STRING)
			-- Update `a_expression' with `a_value' in `states'.
		local
			l_bool: BOOLEAN
			l_int: INTEGER
			l_states: like states
			l_original_value: NATURAL_8
			l_new_value: NATURAL_8
		do
			l_states := states
			l_states.search (a_expression)
			if l_states.found then
				l_original_value := l_states.found_item
			else
				l_original_value := 0
				l_states.put (l_original_value, a_expression)
			end
			if a_value.is_boolean then
				l_bool := a_value.to_boolean
				if l_bool then
					l_new_value := l_original_value.bit_or (boolean_true)
				else
					l_new_value := l_original_value.bit_or (boolean_false)
				end
			elseif a_value.is_integer then
				l_int := a_value.to_integer
				if l_int > 0 then
					l_new_value := l_original_value.bit_or (integer_positive)
				elseif l_int < 0 then
					l_new_value := l_original_value.bit_or (integer_negative)
				else
					l_new_value := l_original_value.bit_or (integer_zero)
				end
			else
				l_new_value := l_original_value.bit_or (value_unknown)
			end

			if l_new_value /= l_original_value then
				l_states.force (l_new_value, a_expression)
			end
		end

end
