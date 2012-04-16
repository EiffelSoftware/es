note
	description: "Class to print out a snippet along with its annotation into text format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SNIPPET_ANNOTATION_PRINTER

feature -- Access

	last_output: STRING
			-- Print out from last `print_snippet'

feature -- Basic operation

	print_snippet (a_snippet: EXT_SNIPPET)
			-- Print `a_snippet' into textual format and
			-- make result available in `last_output'.
		local
		do
			create last_output.make (1024)
			snippet := a_snippet
			register_annotations (a_snippet)

			process_snippet (a_snippet)
		end

feature{NONE} -- Implementation

	snippet: EXT_SNIPPET
			-- Snippet to be printed

	begin_list: HASH_TABLE [LINKED_LIST [ANN_ANNOTATION], INTEGER]
			-- Table of annotations which has the same start break points
			-- Keys are breakpoints, values are annotations starting with those breakpoints.

	end_list: HASH_TABLE [LINKED_LIST [ANN_ANNOTATION], INTEGER]
			-- Table of annotations which has the same last break points
			-- Keys are breakpoints, values are annotations ending with those breakpoints.

feature{NONE} -- Implemenation

	register_annotations (a_snippet: EXT_SNIPPET)
			-- Register annotations from `a_snippet' into Current printer.
		local

			l_bp: INTEGER
			l_annotations: LINKED_LIST [ANN_ANNOTATION]
		do
			create begin_list.make (10)
			create end_list.make (10)

			across a_snippet.annotations as l_anns loop
				l_bp := l_anns.item.first_breakpoint
				begin_list.search (l_bp)
				if begin_list.found then
					l_annotations := begin_list.found_item
				else
					create l_annotations.make
					begin_list.force (l_annotations, l_bp)
				end
				l_annotations.extend (l_anns.item)

				l_bp := l_anns.item.last_breakpoint
				end_list.search (l_bp)
				if end_list.found then
					l_annotations := end_list.found_item
				else
					create l_annotations.make
					end_list.force (l_annotations, l_bp)
				end
				l_annotations.extend (l_anns.item)
			end
		end

	breakpoint_tag (a_header: STRING; a_breakpoints: DS_HASH_SET [INTEGER]): STRING
			-- Assertion tag to cover breakpoints in `a_breakpoints'
			-- `a_header' is a string which appears before all breakpoint information.
		local
			l_list: SORTED_TWO_WAY_LIST [INTEGER]
			l_cursor: DS_HASH_SET_CURSOR [INTEGER]
		do
			create l_list.make
			from
				l_cursor := a_breakpoints.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_list.extend (l_cursor.item)
				l_cursor.forth
			end

			create Result.make (20)
			Result.append (a_header)
			across l_list as l_bps loop
				Result.append_character ('_')
				Result.append_integer (l_bps.item)
			end
		end

	process_snippet (a_snippet: EXT_SNIPPET)
			-- Process `a_snippet' to print out its content
			-- as well as its annotations.
		local
			l_printer: EPA_BREAKPOINT_AST_PRINTER
			l_line: STRING
			l_output: ETR_AST_STRING_OUTPUT
			l_transformer: EXT_TEXT_SNIPPET_TRANSFORMER
		do
			create l_output.make
			create l_transformer.make_with_output (l_output)
			create l_printer
			l_printer.set_ast_to_text_agent (agent l_transformer.transformed_ast (?, a_snippet))
			l_printer.print_ast (a_snippet.ast)
			across l_printer.last_output as l_lines loop
				l_line := l_lines.item
				process_line (l_line)
			end
		end

	process_line (a_line: STRING)
			-- Process `a_line'.
		local
			l_bp_slot: INTEGER
			l_header: STRING
		do
			if a_line.starts_with (once "[") then
					-- This is a breakpointable line.					
				l_bp_slot := breakpoint_from_line (a_line)
				l_header := header_space_from_line (a_line)
				process_annotations (l_bp_slot, l_header, True)
				last_output.append (a_line)
				last_output.append_character ('%N')
				process_annotations (l_bp_slot, l_header, False)
			else
					-- This is a non-breakpointable line,
					-- we just print the line.
				last_output.append (a_line)
				last_output.append_character ('%N')
			end
		end

	process_annotations (a_bp_slot: INTEGER; a_header: STRING; a_before: BOOLEAN)
			-- Process annotations before `a_bp_slot'.
			-- `a_header' is header string for the line with that breakpoint slot.		
		local
			l_annotations: STRING
			l_tbl: like begin_list
			l_ann: ANN_ANNOTATION
		do
			create l_annotations.make (256)
			if a_before then
				l_tbl := begin_list
			else
				l_tbl := end_list
			end

			l_tbl.search (a_bp_slot)
			if l_tbl.found then
				across l_tbl.found_item as l_list loop
					l_ann := l_list.item
					if attached {ANN_STATE_ANNOTATION} l_ann as l_state_ann and then l_state_ann.is_pre_state = a_before then
						l_annotations.append (a_header)
						l_annotations.append_character (' ')
						l_annotations.append_character (' ')
						l_annotations.append (text_of_state_annatation (l_state_ann))
						l_annotations.append_character ('%N')
					end
				end
			end
			last_output.append (l_annotations)
		end

	text_of_state_annatation (a_annotation: ANN_STATE_ANNOTATION): STRING
			-- Text from `a_annotation'
		do
			create Result.make (128)
			Result.append_character ('{')
			if a_annotation.is_pre_state then
				Result.append (breakpoint_tag (once "pre", a_annotation.breakpoints))
			else
				Result.append (breakpoint_tag (once "post", a_annotation.breakpoints))
			end
			Result.append_character (':')
			Result.append_character (' ')
			Result.append (a_annotation.property)
			Result.append_character ('}')
		end


	process_end_annotations (a_bp_slot: INTEGER; a_header: STRING)
			-- Process annotations after `a_bp_slot'.
			-- `a_header' is header string for the line with that breakpoint slot.
		do
		end


	breakpoint_from_line (a_line: STRING): INTEGER
			-- Breakpoint from `a_line'
		local
			l_index: INTEGER
		do
			l_index := a_line.index_of (']', 1)
			Result := a_line.substring (2, l_index - 1).to_integer
		end

	header_space_from_line (a_line: STRING): STRING
			-- Header spacing from `a_line'
		local
			l_text: STRING
			l_index: INTEGER
		do
			if a_line.starts_with (once "[") then
				l_index := a_line.index_of (']', 2)
				l_text := a_line.substring (l_index + 2, a_line.count)
				l_text.left_adjust
				Result := a_line.substring (1, a_line.count - l_text.count)
			else
				l_text := a_line.twin
				l_text.left_adjust
				Result := a_line.substring (1, a_line.count - l_text.count)
			end
		end

end
