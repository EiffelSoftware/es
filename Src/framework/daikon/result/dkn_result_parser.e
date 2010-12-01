note
	description: "Daikon result parser"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_RESULT_PARSER

inherit
	EPA_STRING_UTILITY

	DKN_SHARED_EQUALITY_TESTERS

	EPA_CONSTANTS

	EPA_UTILITY

feature -- Access

	last_invariants: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			-- Invariants parsed by last `parse_from_string' or `parse_from_file'
			-- Key is program point, value is the set of invariants detected at the porgram point.

feature -- Basic operations

	parse_from_string (a_string: STRING; a_declaration: DKN_DECLARATION)
			-- Parse result from `a_string' for program points and variables in `a_declaration'.
			-- Make result available in `last_invariants'.
		local
			l_stream: KL_STRING_INPUT_STREAM
			l_line: STRING
			l_mode: INTEGER -- 0 irrelevant line 1 next line is ppt; 2 next line is invariant
			l_sections: LINKED_LIST [LINKED_LIST [STRING]]
			l_section: LINKED_LIST [STRING]
			l_ppt_name: STRING
			l_invs: DS_HASH_SET [DKN_INVARIANT]
		do
			create last_invariants.make_equal (20)
			create l_sections.make
			create l_stream.make (a_string)

				-- Collect invariant sections.
			from
				l_stream.read_line
			until
				l_stream.end_of_input
			loop
				l_line := l_stream.last_string.twin
				if l_line.has_substring (once "===============") then
					create l_section.make
					l_sections.extend (l_section)
				else
					if l_section /= Void and then not l_line.starts_with (exiting_daikon_string) then
						if l_line.item (l_line.count) = '%R' then
							l_line.remove_tail (1)
						end
						l_section.extend (l_line)
					end
				end
				l_stream.read_line
			end

				-- Iterate through all found invariant sections and build up result.
			across l_sections as l_inv_sections loop
				l_section := l_inv_sections.item
				if l_section.count >= 2 then
					l_ppt_name := l_section.first
					if attached {DKN_PROGRAM_POINT} a_declaration.item_by_daikon_name (l_ppt_name) as l_ppt then
						create l_invs.make (20)
						l_invs.set_equality_tester (daikon_invariant_equality_tester)
						last_invariants.force_last (l_invs, l_ppt)
						from
							l_section.go_i_th (2)
						until
							l_section.after
						loop
							l_invs.force_last (invariant_from_string (l_section.item_for_iteration, l_ppt))
							l_section.forth
						end
					end
				end
			end
		end

	parse_from_file (a_file_name: STRING; a_declaration: DKN_DECLARATION)
			-- Parse result from `a_file_name' for program points and variables in `a_declaration'.
			-- Make result available in `last_invariants'.
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_name)
			l_file.read_stream (l_file.count)
			l_file.close
			parse_from_string (l_file.last_string, a_declaration)
		end

feature{NONE} -- Implementation

	invariant_from_string (a_string: STRING; a_ppt: DKN_PROGRAM_POINT): DKN_INVARIANT
			-- Invariant from `a_string' for program point `a_ppt'
		local
			l_text: STRING
			l_one_of: STRING
			l_parts: LIST [STRING]
			l_values: DS_HASH_SET [STRING]
			l_expr: STRING
		do
			l_text := a_string.twin
			l_text.replace_substring_all (once "!=", once "/=")
			l_text.replace_substring_all (once " null", once " Void")
			l_text.replace_substring_all (once "orig(", once "old (")

			if l_text.has_substring (equation_separator) then
					-- This is an expression invariant.				
				l_text.replace_substring_all (equation_separator, once " = ")
				create {DKN_EXPRESSION_INVARIANT} Result.make (l_text)

			elseif l_text.has_substring (one_of_string) then
					-- This is an "one of" invariant.
				l_parts := string_slices (l_text, one_of_string)
				l_expr := l_parts.first.twin
				l_parts.last.remove_head (2)
				l_parts.last.remove_tail (2)
				l_parts := l_parts.last.split (',')
				create l_values.make (l_parts.count)
				l_values.set_equality_tester (string_equality_tester)
				across l_parts as l_vs loop
					l_vs.item.left_justify
					l_vs.item.right_justify
					l_values.force_last (l_vs.item)
				end
				create {DKN_ONE_OF_INVARIANT} Result.make (l_expr, l_values)
			else
				check False end
			end
		end

	one_of_string: STRING = " one of "

	exiting_daikon_string: STRING = "Exiting Daikon."

end
