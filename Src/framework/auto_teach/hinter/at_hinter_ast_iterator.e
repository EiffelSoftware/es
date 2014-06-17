note
	description: "Custom AST iterator which does the actual comment parsing."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_AST_ITERATOR

inherit

	AT_COMMON
		undefine
			default_create
		end

	AST_ROUNDTRIP_PRINTER_VISITOR
		redefine
			reset,
			process_leading_leaves,
			process_trailing_leaves,
			process_break_as,
			put_string,
			process_do_as,
			process_once_as,

				-- Instructions:
			process_elseif_as,
			process_assign_as,
			process_assigner_call_as,
			process_case_as,
			process_check_as,
			process_creation_as,
			process_create_creation_as,
			process_bang_creation_as,
			process_debug_as,
			process_guard_as,
			process_if_as,
			process_inspect_as,
			process_instr_call_as,
			process_interval_as,
			process_loop_as,
			process_retry_as,
			process_reverse_as
		end

create
	make_with_options

feature -- Status management

	reset
			-- Reset the status of Current
		do
			Precursor
			skipping_until_index := 0
			skipped_section_indentation := 0
			blank_line_inserted := False
		end

feature {NONE} -- Break processing

	process_break_as (a_break_as: BREAK_AS)
			-- Process `a_break_as', also looking for meta-commands.
		local
			l_text: STRING
			l_line_start, l_line_end: INTEGER
			l_lines: ARRAYED_LIST [STRING]
			l_in_skipped_section: BOOLEAN
		do
				-- No call to precursor.

				-- Check if we are in a skipped section. We will need to know this later.
			l_in_skipped_section := in_skipped_section (a_break_as)

				-- Get the text
			l_text := a_break_as.text (match_list)

				-- There seems to be some inconsistency with the handling of new lines. With Windows line endings,
				-- every line will end with %R%N. However, writing this to the output, actually results to an extra
				-- blank line. We prune all '%R's to avoid this.
			l_text.prune_all ('%R')

			l_in_skipped_section := in_skipped_section (a_break_as)

				-- The following code is basically equivalent to l_text.split ('%N'), with the important differences
				-- that new line characters are also a part of the output. {STRING}.split would remove them.
			create l_lines.make (l_text.occurrences ('%N') + 1)
			from
				l_line_start := 1
			until
				l_line_start > l_text.count
			loop
				l_line_end := l_text.index_of ('%N', l_line_start)
				if l_line_end = 0 then
					l_line_end := l_text.count
				end
				l_lines.extend (l_text.substring (l_line_start, l_line_end))
				l_line_start := l_line_end + 1
			end

				-- Ok, we can now process all the lines
				-- Processing normally means one of the following
				-- -> output
				-- -> filter away
				-- -> parse a meta-annotation and act accordingly

			across
				l_lines as ic
			loop
				process_break_line (ic.item, l_in_skipped_section)
			end
		end

	process_break_line (a_break_line: STRING; a_in_skipped_section: BOOLEAN)
			-- Process a single line of a break.
		do
			if is_meta_command (a_break_line) then
				process_meta_command (a_break_line)
			else
				if not a_in_skipped_section then
					put_string_to_context (a_break_line)
				end
			end
		end


feature {NONE} -- Meta-commands processing

	process_meta_command (a_line: STRING)
			-- Process the meta-command contained in `a_line'. Case insensitive.
		local
			l_line: STRING
		do
			l_line := a_line.twin
			l_line.adjust
			if l_line.as_upper.starts_with ("-- #HINT") then
				l_line := a_line.twin
				l_line.prune_all_trailing ('%N')
				put_string_to_context ("%N" + l_line)
				insert_blank_line (false)
			end
		end

	is_meta_command (a_line: STRING): BOOLEAN
			-- Does `a_line' contain a meta-command?
		local
			l_line: STRING
		do
			l_line := a_line.twin
			l_line.adjust
			Result := l_line.starts_with ("-- #")
		end


feature {NONE} -- Implementation - skipping

	skip (a_node: AST_EIFFEL)
			-- Skips `a_node' by setting 'skipping_until_index' to the end position of this node.
		local
			l_newline_index: INTEGER
			l_last_break_text: STRING
			l_last_break_line: STRING
			l_previous_leaf: LEAF_AS
		do
			process_leading_leaves (a_node.index)
			last_index := a_node.index
			if in_skipped_section (a_node) then
					-- Do nothing. Also, calling in_skipped_section asserts that the node is *entirely*
					-- in the skipped section, so we don't even need to update skipping_until_index.
			else
					-- We are at the beginning of a new skipped area, this is the first instruction or block
					-- being skipped. We need to save the numbers of tabs we have before this instruction
					-- by checking the last break.
				l_previous_leaf := match_list.item_by_end_position (a_node.start_position - 1)

					-- The following check should only fail if we are obscurating the very first keyword
					-- in the class. In case this is ever needed in the future, this assertion can be removed.
				check
					attached {BREAK_AS} l_previous_leaf
				end
				if attached {BREAK_AS} l_previous_leaf as l_previous_break then
					l_last_break_text := l_previous_break.text (match_list)
					l_newline_index := l_last_break_text.last_index_of ('%N', l_last_break_text.count)
					if l_newline_index = 0 then
							-- We are probably in some weird situation (e.g. the first instruction being skipped
							-- is not on a new line). Let's stay safe.
						skipped_section_indentation := 0
					else
						l_last_break_line := l_last_break_text.substring (l_newline_index + 1, l_last_break_text.count)
						skipped_section_indentation := count_leading ('%T', l_last_break_line)
					end
				end

					-- Now we can record where the skipped region ends, which is basically all we have to do
				skipping_until_index := a_node.end_position

					-- Finally, insert a blank line, possibly with a placeholder
					-- The flag blank_line_inserted helps us avoiding inserting multiple new lines in case
					-- we encounter two consecutive (but distinct) skipping regions without anything being
					-- printed in between. In this case we clearly don't need more blank lines or placeholders.
					-- This flag is reset by put_string and put_string_to_context.
				if not blank_line_inserted then
					insert_blank_line (options.insert_code_placeholder)
					blank_line_inserted := True
				end
			end
		end

	insert_blank_line (a_insert_placeholder: BOOLEAN)
		-- Insert a blank line with the correct indentation for the current location, and possibly a placeholder.
		local
			l_new_line_with_tabs: STRING
		do
				-- {STRING}.multiply doesn't handle zero as an argument.
			if skipped_section_indentation = 0 then
				l_new_line_with_tabs := ""
			else
				l_new_line_with_tabs := "%T"
				l_new_line_with_tabs.multiply (skipped_section_indentation)
			end
			l_new_line_with_tabs.prepend ("%N")
			put_string_to_context (l_new_line_with_tabs)
			if a_insert_placeholder then
				put_string_to_context (l_new_line_with_tabs + at_strings.code_placeholder + l_new_line_with_tabs)
			end
		end

	in_skipped_section (a_node: AST_EIFFEL): BOOLEAN
			-- Is `a_node' located in the current skipped section?
			-- If so, this function asserts that `a_node' is *entirely* located in the current skipped section.
		do
			if a_node.start_position <= skipping_until_index then
				check
					a_node.end_position <= skipping_until_index
				end
				Result := True
			end
		end

	skipping_until_index: INTEGER
		-- What is the end index of the current/last skipped section?

	skipped_section_indentation: INTEGER
		-- With how many tabs should the skipped section considered to be indented?

	blank_line_inserted: BOOLEAN
		-- Did we already insert a blank line for the current skipping section?

	no_skipping: BOOLEAN = False
		-- Disables all forms of skipping. Temporary.

feature {NONE} -- Implementation

	process_leading_leaves (ind: INTEGER_32)
			-- Redefinition: only processes BREAK_AS leaves and skips the others.
		local
			i: INTEGER_32
		do
			if will_process_leading_leaves then
				if ind > last_index + 1 then
					from
						i := last_index + 1
					until
						i = ind
					loop
							-- Ignore any other unprocessed leaves.
						if attached {BREAK_AS} match_list.i_th (i) as l_break then
							l_break.process (Current)
						end
						i := i + 1
					end
				end
			end
		end

	process_trailing_leaves
			-- Redefinition: only processes BREAK_AS leaves and skips the others.
		local
			l_count: INTEGER
		do
			if will_process_trailing_leaves then
				l_count := end_index
				if last_index < l_count then
					from
						last_index := last_index + 1
					until
						last_index > l_count
					loop
							-- Ignore any other leaves.
						if attached {BREAK_AS} match_list.i_th (last_index) as l_break then
							l_break.process (Current)
						end
						last_index := last_index + 1
					end
				end
			end
		end

	put_string_to_context (a_string: STRING)
			-- Puts `a_string' to the context.
			-- Basically has the same function as put_string, but accepting a string.
		do
			blank_line_inserted := False
			context.add_string (a_string)
		end

	put_string (l_as: LEAF_AS)
			-- Puts the text of `l_as' to the context.
		do
			blank_line_inserted := False
			Precursor (l_as)
		end

	options: AT_OPTIONS

	make_with_options (a_options: AT_OPTIONS)
			-- Initialize Current
		do
			make_with_default_context
			options := a_options
			reset
		end

feature {AST_EIFFEL} -- Other visitors TODO

	-- Right now there is a redundancy, as these two routines here should suffice.
	-- But we will need the instruction visitors later, when we will have more flexibility

	process_do_as (l_as: DO_AS)
			-- Process `l_as'.
		do
				-- We want to process the 'do' keyword in any case.
			safe_process (l_as.do_keyword (match_list))
			if no_skipping then
				safe_process (l_as.compound)
			else
					-- Skip until the end of the whole block
					-- (which doesn't include the 'end' keyword)
				skip (l_as)
			end
		end

	process_once_as (l_as: ONCE_AS)
			-- Process `l_as'.
		do
				-- We want to process the 'once' keyword in any case.
			safe_process (l_as.once_keyword (match_list))
			if no_skipping then
				safe_process (l_as.compound)
			else
					-- Skip until the end of the whole block
					-- (which doesn't include the 'end' keyword)
				skip (l_as)
			end
		end

feature {AST_EIFFEL} -- Instructions visitors

	process_elseif_as (l_as: ELSIF_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_assign_as (l_as: ASSIGN_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_reverse_as (l_as: REVERSE_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_case_as (l_as: CASE_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_check_as (l_as: CHECK_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_creation_as (l_as: CREATION_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_create_creation_as (l_as: CREATE_CREATION_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_bang_creation_as (l_as: BANG_CREATION_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_debug_as (l_as: DEBUG_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_guard_as (l_as: GUARD_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_if_as (l_as: IF_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_inspect_as (l_as: INSPECT_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_interval_as (l_as: INTERVAL_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_loop_as (l_as: LOOP_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

	process_retry_as (l_as: RETRY_AS)
			-- Process `l_as'.
		do
			if no_skipping then
				Precursor (l_as)
			else
				skip (l_as)
			end
		end

end
