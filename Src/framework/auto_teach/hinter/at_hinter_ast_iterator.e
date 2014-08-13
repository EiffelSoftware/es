note
	description: "Custom AST iterator which does the actual comment parsing."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_HINTER_AST_ITERATOR

inherit

	AST_ROUNDTRIP_PRINTER_VISITOR
		redefine
			reset,
			process_leading_leaves,
			process_trailing_leaves,
			process_break_as,
			put_string_to_context,

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
			process_invariant_as,

				-- Assertions
			process_tagged_as,

				-- Instructions
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

inherit {NONE}

	AT_COMMON
		undefine
			default_create
		end

create
	make_with_options

feature -- Interface

	reset
			-- Reset the status of Current
		do
			Precursor
			current_indentation := 0
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
			l_line_start, l_line_end, i: INTEGER
			l_lines: ARRAYED_LIST [STRING]
			l_in_skipped_section: BOOLEAN
		do
				-- No call to precursor.

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

			from
				i := 1
			until
				i > l_lines.count
			loop
				process_break_line (l_lines [i], i = 1)
				i := i + 1
			end
			last_index := a_break_as.index
		end

	process_break_line (a_break_line: STRING; a_inline: BOOLEAN)
			-- Process a single line of a break.
			-- If `a_inline' is False, `a_break_line' is supposed to start on a new line.
		do
			if oracle.is_meta_command (a_break_line) then
				oracle.process_meta_command (a_break_line)
				if attached oracle.last_command_output as l_last_hint then
					output_hint (l_last_hint)
				end
			else
					-- Remember: comments/breaks visibility in a region depends on its content visibility.
				if oracle.output_enabled and oracle.current_content_visibility /= Tri_false then
					put_string_to_context (a_break_line)
					last_unprinted_break_line := Void
				else
					if a_inline then
						last_unprinted_break_line := a_break_line
					else
						last_unprinted_break_line := "%N" + a_break_line
					end
				end
			end
		end

feature {NONE} -- Hint processing

	output_hint (a_line: STRING)
			-- Outputs the specified hint with the correct indentation.
		require
			single_return_terminated_line: a_line.ends_with ("%N") and a_line.occurrences ('%N') = 1
		local
			l_line: STRING
			l_hint_level: INTEGER
			l_indentation: INTEGER

				-- The following variable means: are we currently in a region where breaks are processed?
			l_breaks_are_processed: BOOLEAN
		do
			l_line := a_line.twin

				-- Remove both the initial tabs and the final return character.
			l_line.adjust
			l_breaks_are_processed := not oracle.current_content_visibility.is_false
			if l_breaks_are_processed then
					-- We are in a region were breaks are normally printed.
					-- The return character at the end of the previous line
					-- should have been printed. We are on a new line,
					-- no need to print a return characted by ourselves.

					-- Keep the original indentation of the hint line.
				l_indentation := count_leading ('%T', a_line)
			else
					-- We are in a region were breaks are not printed.
					-- The last return character was not printed, but it
					-- should have been stored in `last_unprinted_break'.
					-- Leave it where it is and print one manually.
				put_string_forced ("%N", False)

					-- Use the indentation of the current section for indenting the hint.
				l_indentation := current_indentation
			end
			put_string_forced (tab_string (l_indentation), False)
			put_string_forced (l_line, False)

			if l_breaks_are_processed then
					-- We were (most likely) on a new line, we must restore the same state.
				put_string_forced ("%N", False)
			end
		end

feature {NONE} -- Implementation - skipping

	last_unprinted_break_line: STRING

	print_last_unprinted_break
		do
			if attached last_unprinted_break_line as l_break_line then
					-- If we are resuming to print something after skipping a region,
					-- we need at least to print the last break line (including the return character),
					-- or the formatting might be incorrect (e.g. an 'end' keyword not on a new line).
					-- This should be true even in case of inline skipping of a region: in this case we
					-- might only insert a single space, but we still must do it after inserting,
					-- for example, an inline placeholder for an if condition.
				context.add_string (l_break_line)
				last_unprinted_break_line := Void
			end
		end

	skip (a_insert_blank_line: BOOLEAN; a_placeholder_type: AT_PLACEHOLDER)
			-- Insert a blank line with the correct indentation for the current location, and possibly a placeholder.
		local
			l_new_line_with_tabs: STRING
		do
			if a_insert_blank_line and not blank_line_inserted then
					-- Prepare it for real
				l_new_line_with_tabs := tab_string (current_indentation)
				l_new_line_with_tabs.prepend ("%N")
				blank_line_inserted := True
			else
					-- Fake blank line, actually an empty string
				l_new_line_with_tabs := ""
			end

			if a_placeholder_type /= enum_placeholder_type.ph_none and not placeholder_inserted then
					-- Insert placeholder
				put_string_forced (l_new_line_with_tabs + a_placeholder_type.text + l_new_line_with_tabs, True)
				placeholder_inserted := True
			else
					-- No placeholder
				put_string_forced (l_new_line_with_tabs, False)
			end
		end

	skip_with_current_placeholder
			-- Skips the current section by inserting a blank line (if appropriate and not already inserted)
			-- with the current indentation and the proper placeholder (if enabled and not already inserted)
			-- for the current section.
		local
			l_placeholder: AT_PLACEHOLDER
		do
			if options.insert_code_placeholder then
				l_placeholder := oracle.current_placeholder_type
			else
				l_placeholder := enum_placeholder_type.ph_none
			end
			skip (not oracle.current_placeholder_type.is_inline, l_placeholder)
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
					l_last_break_text := l_this_break.text (match_list)
					if not l_last_break_text.has ('%N') then
						l_last_break_text := Void
					end
				end
				i := i - 1
			end
			if attached l_last_break_text then
				l_newline_index := l_last_break_text.last_index_of ('%N', l_last_break_text.count)

					-- We checked before that this break contains a newline character.
				check
					newline_found: l_newline_index > 0
				end
				l_last_break_line := l_last_break_text.substring (l_newline_index + 1, l_last_break_text.count)
				Result := count_leading ('%T', l_last_break_line)
			else
				Result := 0
			end
		end

	process_next_break (a_node: detachable AST_EIFFEL)
			-- Process the break immediately following `a_node' (if any),
			-- as if it were a part of the last processed block.
			-- Set `last_index' accordingly.
		local
			l_index: INTEGER
		do
			if attached a_node as l_node then
				l_index := l_node.last_token (match_list).index + 1
				if last_index < l_index and then match_list.valid_index (l_index) and then attached {BREAK_AS} match_list [l_index] as l_break then
						-- I don't expect two consecutive breaks. I also expect the next leaf to be attached.
					check
						next_next_leaf_is_not_break: attached match_list [l_index + 1] implies not attached {BREAK_AS} match_list [l_index + 1]
					end
					process_break_as (l_break)
					last_index := l_index + 1
				end
			end
		end

	current_indentation: INTEGER
			-- With how many tabs should the current section be considered to be indented?

	blank_line_inserted: BOOLEAN
			-- Did we already insert a blank line for the current skipping section?

	placeholder_inserted: BOOLEAN
			-- Did we already insert a placeholder for the current skipping section?

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
			if oracle.output_enabled then
				print_last_unprinted_break
				context.add_string (a_string)
				blank_line_inserted := False
				placeholder_inserted := False
			else
				skip_with_current_placeholder
			end
		end

	put_string_forced (a_string: STRING; a_print_last_unprinted_break: BOOLEAN)
			-- Puts `a_string' to the context without checking the oracle flag.
		do
			if a_print_last_unprinted_break then
				print_last_unprinted_break
			end
			context.add_string (a_string)
		end

	options: AT_OPTIONS
			-- The AutoTeach options.

	make_with_options (a_options: AT_OPTIONS)
			-- Initialize Current
		do
			make_with_default_context
			options := a_options

			create {ARRAYED_STACK [BOOLEAN]} if_as_complex_stack.make (8)

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

	process_require_else_as (a_as: REQUIRE_ELSE_AS)
			-- Process `a_as'.
		do
			process_require_as (a_as)
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

	process_ensure_then_as (a_as: ENSURE_THEN_AS)
			-- Process `a_as'.
		do
			process_ensure_as (a_as)
		end

	process_feature_as (a_as: FEATURE_AS)
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_feature)
			current_indentation := indentation (a_as.feature_name.first_token (match_list))
			Precursor (a_as)
			oracle.end_process_block (enum_block_type.bt_feature)
		end

	process_formal_argu_dec_list_as (a_as: FORMAL_ARGU_DEC_LIST_AS)
			-- Process `a_as'.
		local
			l_placeholder: AT_PLACEHOLDER
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_arguments)
			safe_process (a_as.lparan_symbol (match_list))

				-- We would normally never skip any part of the syntax tree.
				-- So one would expect that we call "safe_process (a_as.arguments)"
				-- here, and just rely on the oracle to prevent the arguments from being
				-- actually output. So why aren't we doing this?
				-- Assume we are in the case where the existence of arguments is shown,
				-- (in practice this just means that the parentheses are printed),
				-- and we only have to hide the arguments inside. In this case, at this point
				-- oracle.output_enabled is True, in order to let us print the parentheses.
				-- Well, there is nothing preventing the arguments from being printed as well.
				-- Right now the effective content visibility is False, but, as arguments declarations
				-- are not explicitly processed by this iterator, nobody checks for it.
				-- We will never notify the oracle that we are beginning to process one specific
				-- argument, so that it can disable the output entirely.
				-- Same story for locals, as local declarations are also not processed singularly.
				-- With pre/postconditions it's different, because assertions are explicitly processed
				-- by this class, and the oracle is notified whenever a single assertion starts being processed.
				-- So this long digression was to explain why here, exceptionally, we have to skip
				-- a part of the syntax tree.
			if oracle.output_enabled and then oracle.current_content_visibility /= Tri_false then
				safe_process (a_as.arguments)
			else
				skip_with_current_placeholder
			end

			if attached a_as.rparan_symbol (match_list) as l_parenthesis then
					-- Hack in order to prevent the last break contained in the original arguments
					-- (usually a space character) from being printed. We don't need a space before
					-- a closed parenthesis.
				process_leading_leaves (l_parenthesis.index)
				last_unprinted_break_line := Void

				safe_process (l_parenthesis)
			end



			oracle.end_process_block (enum_block_type.bt_arguments)
		end

	process_local_dec_list_as (a_as: LOCAL_DEC_LIST_AS)
			-- Process `a_as'
		local
			l_indentation: INTEGER
			l_local_keyword: KEYWORD_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_locals)

			l_indentation := indentation (a_as.local_keyword (match_list))

			l_local_keyword := a_as.local_keyword (match_list)
			safe_process (l_local_keyword)

			if (attached {BREAK_AS} match_list [l_local_keyword.index + 1] as l_first_break) then
				process_break_as (l_first_break)
			end

			current_indentation := l_indentation + 1
			if oracle.output_enabled and oracle.current_content_visibility /= Tri_false then
				safe_process (a_as.locals)
			else
				skip_with_current_placeholder
			end
			oracle.end_process_block (enum_block_type.bt_locals)
		end

	process_do_once_as (a_as: INTERNAL_AS)
			-- Process `a_as'.
		require
			is_do_or_once: attached {DO_AS} a_as or attached {ONCE_AS} a_as
		local
			l_next_leaf: LEAF_AS
			l_do_once_keyword: KEYWORD_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_routine_body)
			if attached {DO_AS} a_as as l_do_as then
				l_do_once_keyword := l_do_as.do_keyword (match_list)
			elseif attached {ONCE_AS} a_as as l_once_as then
				l_do_once_keyword := l_once_as.once_keyword (match_list)
			end
			current_indentation := indentation (l_do_once_keyword) + 1
			safe_process (l_do_once_keyword)
			safe_process (a_as.compound)
			oracle.end_process_block (enum_block_type.bt_routine_body)
		end

	process_require_as (a_as: REQUIRE_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_precondition)
			safe_process (a_as.require_keyword (match_list))
			current_indentation := indentation (a_as.require_keyword (match_list)) + 1
			safe_process (a_as.full_assertion_list)
			oracle.end_process_block (enum_block_type.bt_precondition)
		end

	process_ensure_as (a_as: ENSURE_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_postcondition)
			safe_process (a_as.ensure_keyword (match_list))
			current_indentation := indentation (a_as.ensure_keyword (match_list)) + 1
			safe_process (a_as.full_assertion_list)
			oracle.end_process_block (enum_block_type.bt_postcondition)
		end

	process_invariant_as (a_as: INVARIANT_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_class_invariant)
			safe_process (a_as.invariant_keyword (match_list))
			current_indentation := indentation (a_as.invariant_keyword (match_list)) + 1
			safe_process (a_as.full_assertion_list)
			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_class_invariant)
		end

	process_tagged_as (a_as: TAGGED_AS)
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_assertion)
			Precursor (a_as)
			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_assertion)
		end

feature {AST_EIFFEL} -- Instructions visitors

	instruction_pre (a_as: AST_EIFFEL)
			-- To be called before each instruction visiting routine.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_instruction)

			if attached a_as as l_as then
				current_indentation := indentation (l_as)
			end
		end

	instruction_post (a_as: AST_EIFFEL)
			-- To be called after each instruction visiting routine.
		do
			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_instruction)
		end


	process_assign_as (a_as: ASSIGN_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_reverse_as (a_as: REVERSE_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_assigner_call_as (a_as: ASSIGNER_CALL_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_case_as (a_as: CASE_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_check_as (a_as: CHECK_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_creation_as (a_as: CREATION_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_create_creation_as (a_as: CREATE_CREATION_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_bang_creation_as (a_as: BANG_CREATION_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_debug_as (a_as: DEBUG_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_guard_as (a_as: GUARD_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_if_as (a_as: IF_AS)
			-- Process `a_as'.
		local
			l_treat_as_complex: BOOLEAN
		do
			-- TODO: set `l_treat_as_complex'

			l_treat_as_complex := True

			if_as_complex_stack.put (l_treat_as_complex)

			if l_treat_as_complex then
				process_if_as_complex (a_as)
			else
				instruction_pre (a_as)
				Precursor (a_as)
				instruction_post (a_as)
			end

			if_as_complex_stack.remove
		ensure then
			if_as_complex_stack_restored: if_as_complex_stack.count = old if_as_complex_stack.count
		end

	if_as_complex_stack: STACK [BOOLEAN]
		-- Stack corresponding to nested if instructions.
		-- The top value corresponds to the innermost if instruction being analyzed.
		-- If no if instruction is currently being processed, the stack is empty.
		-- Values indicate whether the corresponding if instruction should be treated
		-- as a complex block (True) or as a simple instruction (False).

	process_elseif_as (a_as: ELSIF_AS)
			-- Process `a_as'.
		do
			check if_as_complex_stack_not_empty: not if_as_complex_stack.is_empty end

			if if_as_complex_stack.item then
				process_elseif_as_complex (a_as)
			else
					-- Process as instruction
				instruction_pre (a_as)
				Precursor (a_as)
				instruction_post (a_as)
			end
		end

	process_inspect_as (a_as: INSPECT_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_instr_call_as (a_as: INSTR_CALL_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_interval_as (a_as: INTERVAL_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_loop_as (a_as: LOOP_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

	process_retry_as (a_as: RETRY_AS)
			-- Process `a_as'.
		do
			instruction_pre (a_as)
			Precursor (a_as)
			instruction_post (a_as)
		end

feature {AST_EIFFEL} -- Complex block processing

	process_if_as_complex (a_as: IF_AS)
			-- Process `a_as' as a complex block.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_if)

			safe_process (a_as.if_keyword (match_list))

			process_if_condition (a_as.condition)

			safe_process (a_as.then_keyword (match_list))

			process_if_branch (a_as.compound)

			safe_process (a_as.elsif_list)
			safe_process (a_as.else_keyword (match_list))

			process_if_branch (a_as.else_part)

			safe_process (a_as.end_keyword)

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_if)
		end

	process_elseif_as_complex (a_as: ELSIF_AS)
			-- Process `a_as' as a complex block.
		do
			safe_process (a_as.elseif_keyword (match_list))

			process_if_condition (a_as.expr)

			safe_process (a_as.then_keyword (match_list))

			process_if_branch (a_as.compound)
		end

	process_if_condition (a_as: EXPR_AS)
			-- Process `a_as', which is an if condition.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_if_condition)

			safe_process (a_as)

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_if_condition)
		end

	process_if_branch (a_as: EIFFEL_LIST [INSTRUCTION_AS])
			-- Process `a_as', which is the body of an if branch.
		do
			if attached a_as as l_as then
				process_leading_leaves (l_as.first_token (match_list).index)
				current_indentation := indentation (a_as)
			end
			oracle.begin_process_block (enum_block_type.bt_if_branch)

			safe_process (a_as)

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_if_branch)
		end

end
