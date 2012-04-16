note
	description: "Class to print an AST node with breakpoint slots"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_BREAKPOINT_AST_PRINTER

inherit
	EPA_UTILITY

feature -- Access

	last_output: LINKED_LIST [STRING]
			-- Output lines from last `print_ast'

	last_output_as_string: STRING
			-- A single string representation for `last_output'
		local
			l_line: STRING
		do
			create Result.make (1024)
			across last_output as l_lines loop
				Result.append (l_lines.item)
				Result.append_character ('%N')
			end
		end

feature -- Basic operations

	print_ast (a_ast: AST_EIFFEL)
			-- Print `a_ast' into string with breakpoint slots,
			-- make result available in `last_output'.
		local
			l_text: STRING
			l_bp_slot: INTEGER
			l_new_line: STRING
		do
			create last_output.make
			if attached ast_to_text_agent as a_agent then
				l_text := a_agent.item ([a_ast])
			else
				l_text := text_from_ast (a_ast)
			end
			fixme ("We assume the breakpoint slot of AST starts from 1. Jasonw 21.7.2011")
			l_bp_slot := 1
			across l_text.split ('%N') as l_lines loop
				l_new_line := l_lines.item.twin
				l_new_line.left_adjust
				l_new_line.right_adjust
				if not l_new_line.is_empty then
					if is_line_breakpointed (l_lines.item) then
						l_new_line := breakpoint_header (l_bp_slot) + l_lines.item
						l_bp_slot := l_bp_slot + 1
					else
						l_new_line := non_breakpoint_header + l_lines.item
					end
					last_output.extend (l_new_line)
				end
			end
		end

feature -- Access

	ast_to_text_agent: FUNCTION [ANY, TUPLE [AST_EIFFEL], STRING]
			-- Agent to get text out of an AST node

	set_ast_to_text_agent (a_agent: like ast_to_text_agent)
			-- Set `a_ast_to_text_agent' with `a_agent'.
		do
			ast_to_text_agent := a_agent
		end

feature{NONE} -- Implementation

	breakpoint_header (a_slot: INTEGER): STRING
			-- Header string for a line with breakpoint `a_slot'
		do
			create Result.make (5)
			Result.append_character ('[')
			if a_slot < 10 then
				Result.append_character (' ')
			end
			Result.append_integer (a_slot)
			Result.append_character (']')
			Result.append_character (' ')
		end

	non_breakpoint_header: STRING
			-- Header string for a non-breakpoint line
		do
			create Result.make (5)
			Result.append_character (' ')
			Result.append_character (' ')
			Result.append_character (' ')
			Result.append_character (' ')
			Result.append_character (' ')
		end

	is_line_breakpointed (a_line: STRING): BOOLEAN
			-- Does `a_line' contain a breakpoint?
		local
			l_text: STRING
		do
			l_text := a_line.twin
			l_text.left_adjust
			l_text.right_adjust
			Result := not non_breakpointable_lines.has (l_text)
		end

	non_breakpointable_lines: HASH_TABLE [INTEGER, STRING]
			-- Table of non-breakpointable lines
			-- Keys are line contents, values are not used for the moment.
		once
			create Result.make (6)
			Result.compare_objects
			Result.extend (0, "from")
			Result.extend (0, "until")
			Result.extend (0, "loop")
			Result.extend (0, "else")
			Result.extend (0, "end")
			Result.extend (0, "inspect")
		end

end
