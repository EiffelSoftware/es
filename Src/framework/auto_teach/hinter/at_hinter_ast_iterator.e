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

				-- Features
			process_feature_as,

				-- Routine arguments
			process_formal_argu_dec_list_as,

				-- Routine bodies
			process_do_as,
			process_once_as,

				-- Locals
			process_local_dec_list_as,

				-- Contracts
			process_require_as,
			process_require_else_as,
			process_ensure_as,
			process_ensure_then_as,
			process_invariant_as

			-- Instructions:
			--			process_elseif_as,
			--			process_assign_as,
			--			process_assigner_call_as,
			--			process_case_as,
			--			process_check_as,
			--			process_creation_as,
			--			process_create_creation_as,
			--			process_bang_creation_as,
			--			process_debug_as,
			--			process_guard_as,
			--			process_if_as,
			--			process_inspect_as,
			--			process_instr_call_as,
			--			process_interval_as,
			--			process_loop_as,
			--			process_retry_as,
			--			process_reverse_as
		end

create
	make_with_options

feature -- Interface

	reset
			-- Reset the status of Current
		do
			Precursor
			skipping_until_position := 0
			skipped_section_indentation := 0
			blank_line_inserted := False
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
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
			l_in_skipped_section := is_node_in_skipped_section (a_break_as)

				-- Get the text
			l_text := a_break_as.text (match_list)

				-- There seems to be some inconsistency with the handling of new lines. With Windows line endings,
				-- every line will end with %R%N. However, writing this to the output, actually results to an extra
				-- blank line. We prune all '%R's to avoid this.
			l_text.prune_all ('%R')

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
			last_index := a_break_as.index
		end

	process_break_line (a_break_line: STRING; a_in_skipped_section: BOOLEAN)
			-- Process a single line of a break.
		do
			if oracle.is_meta_command (a_break_line) then
				oracle.process_meta_command (a_break_line)
				if attached oracle.last_hint as l_last_hint then
					output_hint (l_last_hint)
				end
			else
				if not a_in_skipped_section then
					put_string_to_context (a_break_line)
				end
			end
		end

feature {NONE} -- Hint processing

	output_hint (a_line: STRING)
			-- Outputs the specified hint with the correct indentation.
		require
				-- a_line is a hint command. How to specify that?
			single_return_terminated_line: a_line.ends_with ("%N") and a_line.occurrences ('%N') = 1
		local
			l_line: STRING
			l_hint_level: INTEGER
			l_indentation: INTEGER
		do
			l_line := a_line.twin
			l_line.left_adjust
			check
				l_line.starts_with (at_strings.hint_command)
			end
			l_hint_level := string_to_int (l_line.substring (at_strings.hint_command.count + 1, l_line.count))
			if l_hint_level <= options.hint_level then
				if in_skipped_section then
					l_indentation := skipped_section_indentation
						-- We will be in an already indented line, no need to indent it again.
				else
					l_indentation := count_leading ('%T', a_line)
					put_string_to_context (tab_string (l_indentation))
				end
				put_string_to_context (l_line) -- Remember that `l_line' ends with a %N character.
				put_string_to_context (tab_string (l_indentation) + "%N")
				if in_skipped_section then
						-- We need to leave things as we found them, so re-indent the line.
					put_string_to_context (tab_string (l_indentation))
				end
			end
		end

feature {NONE} -- Implementation - skipping

	skip (a_node: AST_EIFFEL; a_inline: BOOLEAN)
			-- Skips `a_node' by setting 'skipping_until_index' to the end position of this node.
			-- If `a_inline' is true, no blank line will be inserted.
		local
			l_newline_index, l_start_position, l_leaf_index: INTEGER
			l_last_break_text: STRING
			l_last_break_line: STRING
			l_previous_leaf: LEAF_AS
		do
			process_leading_leaves (a_node.first_token (match_list).index)
			last_index := a_node.index
			if is_node_in_skipped_section (a_node) then
					-- Do nothing. Also, calling in_skipped_section asserts that the node is *entirely*
					-- in the skipped section, so we don't even need to update skipping_until_index.
			else
					-- Record where the skipped region ends, which is basically all we have to do
				skipping_until_position := a_node.end_position

					-- If necessary, insert a blank line, possibly with a placeholder.
					-- We assume that `skipped_section_indentation' has already set with the proper value.
					-- The flag blank_line_inserted helps us avoiding inserting multiple new lines in case
					-- we encounter two consecutive (but distinct) skipping regions without anything being
					-- printed in between. In this case we clearly don't need more blank lines or placeholders.
					-- This flag is reset by put_string and put_string_to_context.
				if not a_inline and not blank_line_inserted then
					insert_blank_line (skipped_section_indentation, options.insert_code_placeholder)
					blank_line_inserted := True
				end
			end
		end

	insert_blank_line (a_indentation: INTEGER; a_insert_placeholder: BOOLEAN)
			-- Insert a blank line with the correct indentation for the current location, and possibly a placeholder.
		local
			l_new_line_with_tabs: STRING
		do
			l_new_line_with_tabs := tab_string (a_indentation)
			l_new_line_with_tabs.prepend ("%N")
			put_string_to_context (l_new_line_with_tabs)
			if a_insert_placeholder then
				put_string_to_context (l_new_line_with_tabs + at_strings.code_placeholder + l_new_line_with_tabs)
			end
		end

	in_skipped_section: BOOLEAN
			-- Is the end of the last node being processed located in the current skipped section?
		local
			l_leaf: detachable LEAF_AS
		do
			if last_index = 0 then
				Result := false
			else
				l_leaf := match_list.at (last_index)
				Result := l_leaf.end_position <= skipping_until_position
			end
		end

	is_node_in_skipped_section (a_node: AST_EIFFEL): BOOLEAN
			-- Is `a_node' located in the current skipped section?
			-- If so, this function asserts that `a_node' is *entirely* located in the current skipped section.
		do
			if a_node.start_position <= skipping_until_position then
				check
					a_node.end_position <= skipping_until_position
				end
				Result := True
			end
		end

	indentation (a_node: AST_EIFFEL): INTEGER
			-- The indentation value of the given node.
		local
			l_newline_index, i: INTEGER
			l_last_break_text: STRING
			l_last_break_line: STRING
		do
			-- Navigate backwards until we find the previous break containing a newline character.
			from
				i := a_node.first_token (match_list).index
			until
				i <= 0 or attached l_last_break_text
			loop
				if attached {BREAK_AS} match_list [i] as l_this_break then
					l_last_break_text :=  l_this_break.text (match_list)
					if not l_last_break_text.has ('%N') then
						l_last_break_text := Void
					end
				end
				i := i - 1
			end

			if attached l_last_break_text then
				l_newline_index := l_last_break_text.last_index_of ('%N', l_last_break_text.count)

					-- We checked before that this break contains a newline character.
				check newline_found: l_newline_index > 0 end

				l_last_break_line := l_last_break_text.substring (l_newline_index + 1, l_last_break_text.count)
				Result := count_leading ('%T', l_last_break_line)
			else
				Result := 0
			end
		end

	next_break (a_node: AST_EIFFEL): BREAK_AS
		require
			next_is_break: match_list.valid_index (a_node.index + 1) and then attached {BREAK_AS} match_list [a_node.index + 1]
		do
			if attached {BREAK_AS} match_list [a_node.index + 1] as l_next_break then
				Result := l_next_break
			end
		end

	skipping_until_position: INTEGER
			-- What is the end index of the current/last skipped section?

	skipped_section_indentation: INTEGER
			-- With how many tabs should the skipped section considered to be indented?

	blank_line_inserted: BOOLEAN
			-- Did we already insert a blank line for the current skipping section?

feature {NONE} -- Implementation

	oracle: AT_HINTER_PROCESSING_ORACLE
		-- Oracle containing all the logic about what should be hidden and what not.

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

	put_string (a_as: LEAF_AS)
			-- Puts the text of `a_as' to the context.
		do
			blank_line_inserted := False
			Precursor (a_as)
		end

	options: AT_OPTIONS
			-- The AutoTeach options.

	make_with_options (a_options: AT_OPTIONS)
			-- Initialize Current
		do
			make_with_default_context
			options := a_options
			create oracle.make_with_options (a_options)
			oracle.set_message_output_action (agent print_message)
			reset
		end

	message_output_action: detachable PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]
			-- The action to be called for outputting messages.

	print_message (a_string: READABLE_STRING_GENERAL)
			-- Prints a line to output, if a message output action has been specified.
		do
			if attached message_output_action as l_message_output_action then
				l_message_output_action.call (a_string + "%N")
			end
		end

feature {AST_EIFFEL} -- Visitors

	process_feature_as (l_as: FEATURE_AS)
		do
			process_leading_leaves (l_as.first_token (match_list).index)

			oracle.begin_process_feature

			if oracle.must_skip_feature then
					-- Totally skip it, as if it never existed.
				skip (l_as, False)
			else
				Precursor (l_as)
			end

			oracle.end_process_feature
		end

	process_formal_argu_dec_list_as (a_as: FORMAL_ARGU_DEC_LIST_AS)
			-- Process `a_as'.
		do
			oracle.begin_process_routine_arguments

			if not oracle.must_hide_routine_arguments then
				safe_process (a_as.lparan_symbol (match_list))
				safe_process (a_as.arguments)
				safe_process (a_as.rparan_symbol (match_list))
			else
				if attached a_as.arguments as l_arguments and then not l_arguments.is_empty then
					skip (a_as, True)
					put_string_to_context (at_strings.arguments_placeholder)
				end
			end

			oracle.end_process_routine_arguments
		end

	process_local_dec_list_as (a_as: LOCAL_DEC_LIST_AS)
			-- Process `a_as'
		do
			oracle.begin_process_locals

			safe_process (a_as.local_keyword (match_list))
			if not oracle.must_hide_locals then
				safe_process (a_as.locals)
			else
				skipped_section_indentation := indentation (a_as.local_keyword (match_list)) + 1
				skip (a_as, False)
			end

			oracle.end_process_locals
		end

	process_require_as (a_as: REQUIRE_AS)
			-- Process `a_as'.
		local
			l_indentation: INTEGER
		do
			oracle.begin_process_precondition

			safe_process (a_as.require_keyword (match_list))
			if attached {REQUIRE_ELSE_AS} a_as as l_ensure_then_as then
				safe_process (l_ensure_then_as.else_keyword (match_list))
			end
			if not oracle.must_hide_precondition then
				safe_process (a_as.full_assertion_list)
			else
				if attached a_as.assertions as l_assertions then
					skipped_section_indentation := indentation (l_assertions)
					skip (a_as, False)
				else
					l_indentation := indentation (a_as.require_keyword (match_list))
					skipped_section_indentation := l_indentation + 1

						-- See comments in `process_do_as'.
					skip (next_break (a_as), False)
					put_string_to_context ("%N" + tab_string (l_indentation))
				end
			end

			oracle.end_process_precondition
		end

	process_require_else_as (a_as: REQUIRE_ELSE_AS)
			-- Process `a_as'.
		do
			process_require_as (a_as)
		end

	process_do_once_as (a_as: INTERNAL_AS)
			-- Process `a_as'.
		require
			is_do_or_once: attached {DO_AS} a_as or attached {ONCE_AS} a_as
		local
			l_indentation: INTEGER
			l_next_leaf: LEAF_AS
			l_do_once_keyword: KEYWORD_AS
		do
			oracle.begin_process_routine_body

			if attached {DO_AS} a_as as l_do_as then
				l_do_once_keyword := l_do_as.do_keyword (match_list)
			elseif attached {ONCE_AS} a_as as l_once_as then
				l_do_once_keyword := l_once_as.once_keyword (match_list)
			end


				-- We want to process the 'do' or 'once' keyword in any case.
			safe_process (l_do_once_keyword)
			if not oracle.must_hide_routine_body then
				safe_process (a_as.compound)
			else
				if attached a_as.compound as l_compound then
					skipped_section_indentation := indentation (l_compound)
					skip (a_as, False)
				else
					l_indentation := indentation (l_do_once_keyword)
					skipped_section_indentation := l_indentation + 1

						-- Empty routine! This is a mess, because `a_as.start_position' and
						-- `a_as.end_position' will return respectively 0 and -1 (meaningless).
						-- `a_as.text (match_list)' will return "do". However, we still want to make
						-- sure that we skip the whole routine body, because it might contain comments
						-- or other whitespace that should not be output.
						-- That's why we need to do the following:
					skip (next_break (a_as), False)

						-- Fix indentation.
					put_string_to_context ("%N" + tab_string (l_indentation))
				end
			end

			oracle.end_process_routine_body
		end

	process_do_as (a_as: DO_AS)
			-- Process `a_as'.
		do
			process_do_once_as (a_as)
		end

	process_once_as (a_as: ONCE_AS)
			-- Process `a_as'.
		do
			process_do_once_as (a_as)
		end

	process_ensure_as (a_as: ENSURE_AS)
			-- Process `a_as'.
		local
			l_indentation: INTEGER
		do
			oracle.begin_process_postcondition

			safe_process (a_as.ensure_keyword (match_list))
			if attached {ENSURE_THEN_AS} a_as as l_ensure_then_as then
				safe_process (l_ensure_then_as.ensure_keyword (match_list))
			end
			if not oracle.must_hide_postcondition then
				safe_process (a_as.full_assertion_list)
			else
				if attached a_as.assertions as l_assertions then
					skipped_section_indentation := indentation (l_assertions)
					skip (a_as, False)
				else
					l_indentation := indentation (a_as.ensure_keyword (match_list))
					skipped_section_indentation := l_indentation + 1

						-- See comments in `process_do_as'.
					skip (next_break (a_as), False)
					put_string_to_context ("%N" + tab_string (l_indentation))
				end
			end

			oracle.end_process_postcondition
		end

	process_ensure_then_as (a_as: ENSURE_THEN_AS)
			-- Process `a_as'.
		do
			process_ensure_as (a_as)
		end

	process_invariant_as (a_as: invariant_as)
			-- Process `a_as'.
		local
			l_indentation: INTEGER
		do
			oracle.begin_process_class_invariant

			safe_process (a_as.invariant_keyword (match_list))
			if not oracle.must_hide_class_invariant then
				safe_process (a_as.full_assertion_list)
			else
				if attached a_as.assertion_list as l_assertions then
					skipped_section_indentation := indentation (l_assertions)
					skip (a_as, False)
				else
					l_indentation := indentation (a_as.invariant_keyword (match_list))
					skipped_section_indentation := l_indentation + 1

						-- See comments in `process_do_as'.
					skip (next_break (a_as), False)
					put_string_to_context ("%N" + tab_string (l_indentation))
				end
			end

			oracle.end_process_class_invariant
		end

end

		--feature {AST_EIFFEL} -- Instructions visitors

		--	process_elseif_as (a_as: ELSIF_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_assign_as (a_as: ASSIGN_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_reverse_as (a_as: REVERSE_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_assigner_call_as (a_as: ASSIGNER_CALL_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_case_as (a_as: CASE_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_check_as (a_as: CHECK_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_creation_as (a_as: CREATION_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_create_creation_as (a_as: CREATE_CREATION_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_bang_creation_as (a_as: BANG_CREATION_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_debug_as (a_as: DEBUG_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_guard_as (a_as: GUARD_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_if_as (a_as: IF_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_inspect_as (a_as: INSPECT_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_instr_call_as (a_as: INSTR_CALL_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_interval_as (a_as: INTERVAL_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_loop_as (a_as: LOOP_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end

		--	process_retry_as (a_as: RETRY_AS)
		--			-- Process `a_as'.
		--		do
		--			if no_skipping then
		--				Precursor (a_as)
		--			else
		--				skip (a_as)
		--			end
		--		end
