note
	description: "Custom AST iterator which does the actual comment parsing."
	author: "Paolo Antonucci"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_AST_ITERATOR

inherit

	AST_ROUNDTRIP_PRINTER_VISITOR
		rename
			process_case_as as process_inspect_case_as
		redefine
			reset,
			process_leading_leaves,
			process_trailing_leaves,
			process_break_as,
			put_string_to_context,
			process_class_as,

				-- Features
			process_feature_as,
			process_routine_as,

				-- Routine arguments
			process_formal_argu_dec_list_as,

				-- Routine bodies
			process_do_as,
			process_once_as,

				-- Locals
			process_local_dec_list_as,

				-- Argument and local declarations,
			process_type_dec_as,

				-- Contracts
			process_require_as,
			process_require_else_as,
			process_ensure_as,
			process_ensure_then_as,
			process_invariant_as,

				-- Assertions
			process_tagged_as,

				-- Instructions
			process_assign_as,
			process_assigner_call_as,
			process_check_as,
			process_creation_as,
			process_create_creation_as,
			process_bang_creation_as,
			process_debug_as,
			process_guard_as,
			process_instr_call_as,
			process_retry_as,
			process_reverse_as,

				-- Complex instructions
			process_if_as,
			process_elseif_as,
			process_inspect_as,
			process_inspect_case_as,
			process_loop_as,

				-- Workaround for named tuples
			process_named_tuple_type_as
		end

	AT_COMMON
		undefine
			default_create
		end

create
	make_with_options

feature -- Interface

	set_options (a_options: AT_OPTIONS)
			-- Sets the options to `a_options'.
		do
			options := a_options.twin
			oracle.set_options (options)
		end

	set_message_output_action (a_action: PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]])
			-- Set `a_action' as the action to be called for outputting messages.
		do
			message_output_action := a_action
		end

	process_class (a_class_as: CLASS_AS; a_match_list: LEAF_AS_LIST)
		require
			clean: not has_run
		do
			setup (a_class_as, a_match_list, True, True)
			process_ast_node (a_class_as)
		end

	has_run: BOOLEAN
		-- Did the `Current' process a class?

	reset
			-- Reset the status of Current
		do
				-- The following conditions should always hold when the iterator is "idle",
			check oracle_clean: oracle.block_type_call_stack.is_empty end
			check auxiliary_flags_clean: not processing_named_tuple not processing_arguments and not processing_locals end
			Precursor
			current_indentation := 0
			blank_line_inserted := False
			has_run := False
		end

feature {NONE} -- Implementation - skipping and handling of breaks

	process_leading_leaves (ind: INTEGER_32)
			-- Redefinition: only processes BREAK_AS leaves and skips the others.
		local
			i: INTEGER_32
		do
			if will_process_leading_leaves and then ind > last_index + 1 then
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

	must_print_breaks: BOOLEAN
			-- Should we print breaks we encounter in the current state?
		do
			Result := oracle.output_enabled and (oracle.current_content_visibility /= Tri_false or oracle.inside_atomic_block or processing_feature_comment)
		end

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
					print_hint (l_last_hint)
				end
			else
					-- Remember: comments/breaks visibility in a region depends on its content visibility.
					-- However, if we are inside an atomic block or if we are processing a feature comment,
					-- then `oracle.output_enabled' is sufficient.
				if must_print_breaks then
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

	last_unprinted_break_line: STRING
			-- The text of the last break that was encountered and not printed.
			-- If it consists of multiple line, only the last line is stored here.

	print_last_unprinted_break
			-- Prints `last_unprinted_break_line' and resets it.
			-- To be called when resuming printing after a hidden section.
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

				if hidden_region_indentation = -1 then
						-- We are entering a new hidden region.
					hidden_region_indentation := current_indentation
				else
						-- We are already in a hidden region, otherwise `hidden_region_indentation'
						-- would be -1. Keep that indentation.
				end

				l_new_line_with_tabs := tab_string (hidden_region_indentation)
				l_new_line_with_tabs.prepend ("%N")
				blank_line_inserted := True

			else
					-- Fake blank line, actually an empty string
				l_new_line_with_tabs := ""
			end

			if a_placeholder_type /= enum_placeholder.Ph_none and not placeholder_inserted then
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
				l_placeholder := enum_placeholder.Ph_none
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
			if attached a_node then
				l_index := a_node.last_token (match_list).index + 1
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

	hidden_region_indentation: INTEGER
			-- What is the base indentation of the region currently being hidden?
			-- -1 if we currently are not inside a hidden region.
			-- (used for the placeholder and for textual hints)


feature {NONE} -- Implementation - printing

	print_hint (a_line: STRING)
			-- Prints the specified hint to output, with the correct indentation.
		require
			single_return_terminated_line: a_line.ends_with ("%N") and a_line.occurrences ('%N') = 1
		local
			l_line: STRING
			l_hint_level: INTEGER
			l_indentation: INTEGER
		do
			l_line := a_line.twin

				-- Remove both the initial tabs and the final return character.
			l_line.adjust

			if must_print_breaks then
					-- We are in a region where breaks are printed, and most likely
					-- the surrounding code is printed as well.
					-- Keep the original indentation of the hint line.
				l_indentation := count_leading ('%T', a_line)
			else
					-- We are in a hidden region, use the indentation of the current
					-- region for indenting the hint.
				l_indentation := if hidden_region_indentation >= 0 then hidden_region_indentation else current_indentation end
			end

				-- This is necessary, otherwise we might not be on a new line.
			print_last_unprinted_break
			put_string_forced (tab_string (l_indentation), False)
			put_string_forced (l_line, False)

				-- The following should always work. It is necessary because we need to leave
				-- everything on a blank line (everywhere, including here, we assume we are
				-- already on a new line), but we should not print it immediately, it might
				-- be that a placeholder must be inserted afterwards and in this case it will
				-- not be printed.
				-- It should not be considered a hack, because there was indeed a new line
				-- character at the end of a_line (or there should have been), but we ate it
				-- when we called l_line.adjust.
			last_unprinted_break_line := "%N"

				-- If more code is hidden after the hint, we want another placeholder.
			blank_line_inserted := False
			placeholder_inserted := False
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
				hidden_region_indentation := -1
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


feature {NONE} -- Implementation - miscellanea

	oracle: AT_PROCESSING_ORACLE
			-- Oracle containing all the logic about what should be hidden and what not.

	options: AT_OPTIONS
			-- The AutoTeach options.

	message_output_action: detachable PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]
			-- The action to be called for outputting messages.

	print_message (a_string: READABLE_STRING_GENERAL)
			-- Prints a line to output, if a message output action has been specified.
		do
			if attached message_output_action as l_message_output_action then
				l_message_output_action.call (a_string + "%N")
			end
		end


feature {NONE} -- Initialization

	make_with_options (a_options: AT_OPTIONS)
			-- Initialize Current
		do
			make_with_default_context
			options := a_options.twin

			hidden_region_indentation := -1

			create oracle.make_with_options (a_options)
			oracle.set_message_output_action (agent print_message)

			reset
		end


feature {NONE} -- Auxiliary location flags

	processing_feature_comment: BOOLEAN
			-- Are we currently processing a feature comment?

	processing_named_tuple: BOOLEAN
			-- Are we currently processing a named tuple?

	processing_arguments: BOOLEAN
			-- Are we currently processing some routine arguments?

	processing_locals: BOOLEAN
			-- Are we currently processing the local declarations of some routine?

	is_at_most_one_auxiliary_flag_set: BOOLEAN
		local
			l_value: INTEGER
		do
			l_value := l_value + processing_feature_comment.to_integer
			l_value := l_value + processing_named_tuple.to_integer
			l_value := l_value + processing_arguments.to_integer
			l_value := l_value + processing_locals.to_integer

			Result := (l_value <= 1)
		end

feature {AST_EIFFEL} -- Visitors

	process_class_as (a_as: CLASS_AS)
			-- Process `a_as'.
		do
			oracle.begin_process_class
			Precursor (a_as)
			oracle.end_process_class
		end

	process_require_else_as (a_as: REQUIRE_ELSE_AS)
			-- Process `a_as'.
		do
			process_require_as (a_as)
		end


	process_routine_as (a_as: ROUTINE_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)

				-- The routine-specific clauses are about to begin, time to reset this flag.
			processing_feature_comment := False
			Precursor (a_as)
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
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_feature)

			current_indentation := indentation (a_as.feature_name.first_token (match_list))

				-- We set the `processing_feature_comment' flag to true a bit earlier than we
				-- should, but this saves us from overriding other features from the parent
				-- class just for setting this.
			processing_feature_comment := True
			Precursor (a_as)

				-- If this feature is a routine, this should already have been reset in `process_routine_as'.
				-- If not, we do it here.
			processing_feature_comment := False

			oracle.end_process_block (enum_block_type.Bt_feature)
		end

	process_named_tuple_type_as (a_as: NAMED_TUPLE_TYPE_AS)
			-- Process `a_as'.
		do
				-- We need to know if we are currently processing a named tuple so that we don't
				-- mishandle occurrences of `FORMAL_ARGU_DEC_LIST_AS' as routine arguments.
			processing_named_tuple := True
			Precursor (a_as)
			processing_named_tuple := False
		end

	process_formal_argu_dec_list_as (a_as: FORMAL_ARGU_DEC_LIST_AS)
			-- Process `a_as'.
		local
			l_placeholder: AT_PLACEHOLDER
		do
			if processing_named_tuple then
					-- These are not routine arguments.
				Precursor (a_as)
			else
				process_leading_leaves (a_as.first_token (match_list).index)
				oracle.begin_process_block (enum_block_type.Bt_arguments)

				safe_process (a_as.lparan_symbol (match_list))

				-- current_indentation := indentation (a_as.lparan_symbol (match_list)) + 1

				processing_arguments := True
				safe_process (a_as.arguments)
				processing_arguments := False

				if attached a_as.rparan_symbol (match_list) as l_parenthesis then
						-- Hack in order to prevent the last break contained in the original arguments
						-- (usually a space character) from being printed. We don't need a space before
						-- a closed parenthesis.
					process_leading_leaves (l_parenthesis.index)
					last_unprinted_break_line := Void
				end

				safe_process (a_as.rparan_symbol (match_list))

				oracle.end_process_block (enum_block_type.Bt_arguments)
			end
		end

	process_local_dec_list_as (a_as: LOCAL_DEC_LIST_AS)
			-- Process `a_as'.
		local
			l_indentation: INTEGER
			l_local_keyword: KEYWORD_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_locals)

			l_indentation := indentation (a_as.local_keyword (match_list))

			l_local_keyword := a_as.local_keyword (match_list)
			safe_process (l_local_keyword)

			current_indentation := l_indentation + 1

			if attached {BREAK_AS} match_list [l_local_keyword.index + 1] as l_first_break then
				process_break_as (l_first_break)
			end

			processing_locals := True
			safe_process (a_as.locals)
			processing_locals := False

			oracle.end_process_block (enum_block_type.Bt_locals)
		end

	process_type_dec_as (a_as: TYPE_DEC_AS)
			-- Process `a_as'
		local
			l_block_type: AT_BLOCK_TYPE
		do
			check arguments_nand_locals: not (processing_arguments and processing_locals) end

			if not (processing_arguments or processing_locals) then
				Precursor (a_as)
			else
				if processing_arguments then
					l_block_type := enum_block_type.Bt_argument_declaration
				elseif processing_locals then
					l_block_type := enum_block_type.Bt_local_declaration
				end

				process_leading_leaves (a_as.first_token (match_list).index)
				oracle.begin_process_block (l_block_type)

				Precursor (a_as)

				process_next_break (a_as)
				oracle.end_process_block (l_block_type)
			end
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
			oracle.begin_process_block (enum_block_type.Bt_routine_body)

			if attached {DO_AS} a_as as l_do_as then
				l_do_once_keyword := l_do_as.do_keyword (match_list)
			elseif attached {ONCE_AS} a_as as l_once_as then
				l_do_once_keyword := l_once_as.once_keyword (match_list)
			end
			current_indentation := indentation (l_do_once_keyword) + 1
			safe_process (l_do_once_keyword)
			safe_process (a_as.compound)

			oracle.end_process_block (enum_block_type.Bt_routine_body)
		end

	process_require_as (a_as: REQUIRE_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_precondition)

			safe_process (a_as.require_keyword (match_list))
			if attached {REQUIRE_ELSE_AS} a_as as l_as then
				safe_process (l_as.else_keyword (match_list))
			end
			current_indentation := indentation (a_as.require_keyword (match_list)) + 1
			safe_process (a_as.full_assertion_list)

			oracle.end_process_block (enum_block_type.Bt_precondition)
		end

	process_ensure_as (a_as: ENSURE_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_postcondition)

			safe_process (a_as.ensure_keyword (match_list))
			if attached {ENSURE_THEN_AS} a_as as l_as then
				safe_process (l_as.then_keyword (match_list))
			end
			current_indentation := indentation (a_as.ensure_keyword (match_list)) + 1
			safe_process (a_as.full_assertion_list)

			oracle.end_process_block (enum_block_type.Bt_postcondition)
		end

	process_invariant_as (a_as: INVARIANT_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_class_invariant)

			safe_process (a_as.invariant_keyword (match_list))
			current_indentation := indentation (a_as.invariant_keyword (match_list)) + 1
			safe_process (a_as.full_assertion_list)

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_class_invariant)
		end

	process_tagged_as (a_as: TAGGED_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_assertion)

			Precursor (a_as)

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_assertion)
		end

feature {AST_EIFFEL} -- Instructions visitors

	instruction_pre (a_as: AST_EIFFEL)
			-- To be called before each instruction visiting routine.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_instruction)

			if attached a_as then
				current_indentation := indentation (a_as)
			end
		end

	instruction_post (a_as: AST_EIFFEL)
			-- To be called after each instruction visiting routine.
		do
			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_instruction)
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

	process_instr_call_as (a_as: INSTR_CALL_AS)
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

feature {AST_EIFFEL} -- Complex instructions visitors

	process_if_as (a_as: IF_AS)
			-- Process `a_as'.
		local
			l_then_keyword, l_else_keyword: detachable KEYWORD_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_if)

			safe_process (a_as.if_keyword (match_list))

			process_expression_as (a_as.condition, enum_block_type.Bt_if_condition)

			l_then_keyword := a_as.then_keyword (match_list)
			check attached l_then_keyword end
			if attached l_then_keyword then
				process_compound_as (l_then_keyword, a_as.compound, enum_block_type.Bt_if_branch)
			end

			safe_process (a_as.elsif_list)

			l_else_keyword := a_as.else_keyword (match_list)
			if attached l_else_keyword then
				process_compound_as (l_else_keyword, a_as.else_part, enum_block_type.Bt_if_branch)
			end

			safe_process (a_as.end_keyword)
			if attached a_as.end_keyword as l_keyword then
				current_indentation := indentation (a_as.end_keyword)
			else
				current_indentation := current_indentation - 1
			end


			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_if)
		end

	process_elseif_as (a_as: ELSIF_AS)
			-- Process `a_as'.
		local
			l_then_keyword: detachable KEYWORD_AS
		do
			safe_process (a_as.elseif_keyword (match_list))

			process_expression_as (a_as.expr, enum_block_type.Bt_if_condition)

			l_then_keyword := a_as.then_keyword (match_list)
			check attached l_then_keyword end
			if attached l_then_keyword then
				process_compound_as (l_then_keyword, a_as.compound, enum_block_type.Bt_if_branch)
			end
		end

	process_expression_as (a_as: EXPR_AS; a_block_type: AT_BLOCK_TYPE)
			-- Process `a_as', which is a block of type of type `a_block_type'.
		do
				-- Don't call `process_leading_leaves', it would have the undesired side effect
				-- of treating comment at the beginning of this compound according to the previous
				-- content visibility policy.
			oracle.begin_process_block (a_block_type)

			safe_process (a_as)

			process_next_break (a_as)
			oracle.end_process_block (a_block_type)
		end

	process_compound_as (a_keyword: KEYWORD_AS; a_as: detachable EIFFEL_LIST [INSTRUCTION_AS]; a_block_type: AT_BLOCK_TYPE)
			-- Process an instruction block (`a_as'), of type `a_block_type'.
		do
			process_leading_leaves (a_keyword.first_token (match_list).index)

			oracle.begin_process_block (a_block_type)

			current_indentation := indentation (a_keyword)
			safe_process (a_keyword)

			if attached a_as then
				current_indentation := indentation (a_as)
			else
				current_indentation := current_indentation + 1
			end
			safe_process (a_as)

			process_next_break (a_as)
			oracle.end_process_block (a_block_type)
		end

	process_loop_as (a_as: LOOP_AS)
			-- Process `a_as'.
		local
			l_until_keyword, l_loop_keyword: detachable KEYWORD_AS
			l_variant_processing_after: BOOLEAN
			l_variant_part: detachable VARIANT_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_loop)

			current_indentation := indentation (a_as)

				-- The 'across' section.
				-- It is treated as a part of the loop itself and cannot be hidden.
			safe_process (a_as.iteration)

			if attached a_as.from_keyword (match_list) as l_from_keword then
				process_compound_as (l_from_keword, a_as.from_part, enum_block_type.Bt_loop_initialization)
			end

			if attached a_as.invariant_keyword (match_list) as l_invariant_keyword then
				oracle.begin_process_block (enum_block_type.bt_loop_invariant)

				current_indentation := indentation (l_invariant_keyword)
				safe_process (l_invariant_keyword)

				current_indentation := current_indentation + 1
				safe_process (a_as.full_invariant_list)

				oracle.end_process_block (enum_block_type.bt_loop_invariant)
			else
				check no_invariant_if_no_invariant_keyword: not attached a_as.full_invariant_list end
			end

				-- Special code to handle the old or new ordering of the `variant'
				-- clause in a loop.
			l_until_keyword := a_as.until_keyword (match_list)
			l_variant_part := a_as.variant_part
			if l_until_keyword = Void then
					-- Must be across loop
				l_variant_processing_after := True
			elseif l_variant_part /= Void then
				if l_variant_part.start_position > l_until_keyword.start_position then
					l_variant_processing_after := True
				else
					process_loop_variant_as (l_variant_part)
				end
			end

			if attached l_until_keyword then
				current_indentation := indentation (l_until_keyword)
				safe_process (l_until_keyword)

				current_indentation := current_indentation + 1
				process_expression_as (a_as.stop, enum_block_type.Bt_loop_termination_condition)
			end

			l_loop_keyword := a_as.loop_keyword (match_list)
			check attached l_loop_keyword end
			if attached l_loop_keyword then
				process_compound_as (l_loop_keyword, a_as.compound, enum_block_type.Bt_loop_body)
			end

			if l_variant_part /= Void and l_variant_processing_after then
				process_loop_variant_as (l_variant_part)
			end
			safe_process (a_as.end_keyword)
			if attached a_as.end_keyword as l_keyword then
				current_indentation := indentation (a_as.end_keyword)
			else
				current_indentation := current_indentation - 1
			end

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_loop)
		end

		process_loop_variant_as (a_as: VARIANT_AS)
			-- Process `a_as', which is a loop invariant block.
		local
			l_variant_keyword: detachable KEYWORD_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.bt_loop_variant)

			l_variant_keyword := a_as.variant_keyword (match_list)

			check attached l_variant_keyword end
			if attached l_variant_keyword then
				current_indentation := indentation (l_variant_keyword)
				safe_process (l_variant_keyword)
				 process_next_break (l_variant_keyword)
			end

			current_indentation := current_indentation + 1

				-- See the long comment in `process_local_dec_list_as'.
			if oracle.output_enabled and oracle.current_content_visibility /= Tri_false then
				safe_process (a_as.tag)
				safe_process (a_as.colon_symbol (match_list))
				safe_process (a_as.expr)
			else
				skip_with_current_placeholder
			end

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.bt_loop_variant)
		end

	process_inspect_as (a_as: INSPECT_AS)
			-- Process `a_as'.
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_inspect)

			current_indentation := indentation (a_as)

			safe_process (a_as.inspect_keyword (match_list))
			safe_process (a_as.switch)
			safe_process (a_as.case_list)

			if attached a_as.else_keyword (match_list) as l_else_keyword then
				oracle.begin_process_block (enum_block_type.Bt_inspect_branch)

				current_indentation := indentation (l_else_keyword)
				safe_process (a_as.else_keyword (match_list))

				current_indentation := current_indentation + 1
				safe_process (a_as.else_part)
				process_next_break (a_as.else_part)

				oracle.end_process_block (enum_block_type.Bt_inspect_branch)
			end

			current_indentation := indentation (a_as.end_keyword)
			safe_process (a_as.end_keyword)
			if attached a_as.end_keyword as l_keyword then
				current_indentation := indentation (a_as.end_keyword)
			else
				current_indentation := current_indentation - 1
			end

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_inspect)
		end

	process_inspect_case_as (a_as: CASE_AS)
			-- Process `a_as'.
		local
			l_when_keyword: detachable KEYWORD_AS
		do
			process_leading_leaves (a_as.first_token (match_list).index)
			oracle.begin_process_block (enum_block_type.Bt_inspect_branch)

			l_when_keyword := a_as.when_keyword (match_list)
			check attached l_when_keyword end
			if attached l_when_keyword then
				current_indentation := indentation (l_when_keyword)
			end

			safe_process (a_as.when_keyword (match_list))
			safe_process (a_as.interval)
			safe_process (a_as.then_keyword (match_list))
			safe_process (a_as.compound)

			process_next_break (a_as)
			oracle.end_process_block (enum_block_type.Bt_inspect_branch)
		end

invariant
	at_most_one_disambiguation_flag: is_at_most_one_auxiliary_flag_set

end
