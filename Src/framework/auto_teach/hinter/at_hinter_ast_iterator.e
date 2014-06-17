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
			default_create,
			reset,
			process_leading_leaves,
			process_trailing_leaves,
			process_break_as,
			put_string,

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

feature -- Status management

	reset
		do
			Precursor
			skipping_until_index := 0
			last_break_text := ""
		end

feature -- Comments processing

	process_break_as (a_break_as: BREAK_AS)
		local
			l_text: STRING
			l_process_it, l_need_new_line: BOOLEAN
		do
			-- No call to precursor.
			l_text := a_break_as.text (match_list)

			-- Under Windows, the text will contain %R%N for every new line, and we don't want this.
			l_text.prune_all ('%R')

			if not in_skipped_section (a_break_as) then
				l_process_it := true
			else
				-- We are in a "censored" section.
				-- We will only process comments in here

				if a_break_as.has_comment then
					l_process_it := True
					l_need_new_line := True
				end

--				-- and allow for one blank line.
--				if not a_break_as.has_comment and then l_text.has ('%N') then
--					if flag then
--						l_skip_it := True
--					else
--						flag := True
--					end
--				end
			end

			if l_process_it then
				put_string_to_context (l_text)
				last_break_text := l_text
			end

			if l_need_new_line then
				put_string_to_context ("%N")
			end

		end

	flag: BOOLEAN

	-- last_break: BREAK_AS

	last_break_text: STRING
--		do
--			Result := last_break.text (match_list)
--		end

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

feature {NONE} -- Implementation - skipping

	skip (a_node: AST_EIFFEL)
		local
			l_newline_index: INTEGER
			l_last_break_line: STRING
		do
			if in_skipped_section (a_node) then
				-- Do nothing. Also, calling in_skipped_section checks that the node is *entirely*
				-- in the skipped section, so we don't even need to update skipping_until_index.
			else
				-- Stop! We are starting to skip an instruction (or a block). Let us
				-- save the numbers of tabs we have before this instruction by checking the last break.
				l_newline_index := last_break_text.last_index_of ('%N', last_break_text.count)
				if l_newline_index = 0 then
					-- We are probably in some weird situation (e.g. the first instruction being skipped
					-- is not on a new line). Let's stay safe.
					skipped_section_indentation := 0
				else
					l_last_break_line := last_break_text.substring (l_newline_index + 1, last_break_text.count)
					skipped_section_indentation := count_leading ('%T', l_last_break_line)
				end
				-- last_break_line := last_break_text.substring (start_index, end_index: INTEGER_32)

					-- Just do nothing for now, but record where the skipped region ends.
					-- We might need this information in processing comments in the skipped region.
				skipping_until_index := a_node.end_position

				if not blank_line_inserted then
					put_string_to_context ("%N")
					blank_line_inserted := True
				end
			end
		end

	in_skipped_section (a_node: AST_EIFFEL): BOOLEAN
		do
			if a_node.start_position <= skipping_until_index then
				check a_node.end_position <= skipping_until_index end

				-- TODO
				if not (a_node.end_position <= skipping_until_index) then
					(create {DEVELOPER_EXCEPTION}).raise
				end
				Result := True
			end
		end

	skipping_until_index: INTEGER

	skipped_section_indentation: INTEGER

	blank_line_inserted: BOOLEAN

	no_skipping: BOOLEAN = False

feature {NONE} -- Implementation

	process_leading_leaves (ind: INTEGER_32)
			-- Redefinition: only processes BREAK_AS leaves and skips the others.
		local
			i: INTEGER_32
			l_text: STRING
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
							l_text := l_break.text (match_list)
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
			l_text: STRING
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
							l_text := l_break.text (match_list)
							l_break.process (Current)
						end
						last_index := last_index + 1
					end
				end
			end
		end

	default_create
		do
			make_with_default_context
			last_break_text := "" -- We need to do this here because it is attached
			reset
		end

	put_string_to_context (a_string: STRING)
		do
			blank_line_inserted := False
			context.add_string (a_string)
		end

	put_string (l_as: LEAF_AS)
		do
			blank_line_inserted := False
			Precursor (l_as)
		end

end
