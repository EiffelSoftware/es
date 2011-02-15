note
	description: "Summary description for {AFX_MATHEMATICA_CONSTRAINT_SOLVER_OUTPUT_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_MATHEMATICA_CONSTRAINT_SOLVER_OUTPUT_PARSER

inherit
	REFACTORING_HELPER

--	AFX_UTILITY

feature -- Access

	solution: HASH_TABLE [TUPLE [argument_valuations: HASH_TABLE [STRING, STRING]; condition: STRING], STRING]
			-- Solution from parsed Mathematica output
			-- The solution is a piecewise function.
			-- Key of the outer table is a single solution in the piecewise function.
			-- Value of the outer table is the condition and argument valuations under which the solution is obtained.
			-- `argument_valuations' is table, key is the argument name, value is the value of that argument under which the solution is obtained.
			-- `condition' is the condition under which the solution is obtained.

feature -- Parsing

	parse (a_text: STRING)
			-- Parse `a_text' as the output from Mathematica for function Minimize or Maximize.
			-- Make solution accessable from `solution'.
		local
			l_text: STRING
			l_parts: LIST [STRING]
			l_empty_table: HASH_TABLE [STRING, STRING]
			l_index: INTEGER
			l_part: STRING
			l_solution: STRING
			l_squares: INTEGER
			c: CHARACTER
		do
			fixme ("This is a hacky implication, only works in few cases. Serious refactoring is needed in the future. 6.1.2009 Jasonw")
			l_text := a_text.twin
			l_text.left_adjust
			l_text.right_adjust

				-- Remove the outmost brackets.
			l_text.remove_head (1)
			l_text.remove_tail (1)

			create solution.make (5)
			solution.compare_objects

				-- Decide if the solution contains only a single value, or the solution is a piecewise function.
			if l_text.substring (1, 9).is_equal (once "Piecewise") then
				l_text.remove_head (10)

					-- Get the whole part of the piecewise function.
				l_index := 1
				l_squares := 1
				from

				until
					l_squares = 0
				loop
					c := l_text.item (l_index)
					if c = '[' then
						l_squares := l_squares + 1
					elseif c = ']' then
						l_squares := l_squares - 1
					end
					if l_squares /= 0 then
						l_index := l_index + 1
					end
				end
				l_text.keep_head (l_index - 1)

				if l_text.substring (l_text.count, l_text.count).is_equal ("}") then
						-- Does not have default value.
						-- Do nothing
				else
						-- Has default value, we remove this default value.
					l_index := l_text.last_index_of (',', l_text.count)
					l_text.remove_tail (l_text.count - l_index + 1)
				end
				l_text.remove_head (1)
				l_text.remove_tail (1)

					-- Get all parts from the piecewise function.
				l_parts := string_slices (l_text, "}, ")
				from
					l_parts.start
				until
					l_parts.after
				loop
						-- Parse a solution.
					l_part := l_parts.item_for_iteration
					l_part.remove_head (1)
					l_index := l_part.index_of (',', 1)
					l_solution := l_part.substring (1, l_index - 1)

						-- Add solution in to `solution'.
					create l_empty_table.make (1)
					l_empty_table.compare_objects
					fixme ("argument valuation and condition are not handled. 6.1.2009 Jasonw")
					solution.put ([l_empty_table, ""], l_solution)
					io.put_string (l_solution + "%N")
					l_parts.forth
				end
			else
				l_parts := l_text.split (',')
				l_parts.first.left_adjust
				l_parts.first.right_adjust
				create l_empty_table.make (1)
				l_empty_table.compare_objects
				fixme ("argument valuation and condition are not handled. 6.1.2009 Jasonw")
				io.put_string (l_parts.first + "%N")
				solution.put ([l_empty_table, ""], l_parts.first)
			end
		end

end
