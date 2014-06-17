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
			default_create,
			reset,
			process_leading_leaves,
			process_trailing_leaves,
			process_break_as,

				-- Instructions:
			process_elseif_as,
			process_assign_as,
			process_assigner_call_as,
			process_case_as,
			process_check_as,
			process_creation_as,
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
		end

feature -- Comments processing

	process_break_as (a_break_as: BREAK_AS)
		local
			l_text: STRING
		do
			Precursor (a_break_as)
			l_text := a_break_as.text (match_list)
			io.put_string (l_text)
			flag := true
		end

	flag: BOOLEAN

feature {AST_EIFFEL} -- Instructions visitors

	process_elseif_as (l_as: ELSIF_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_assign_as (l_as: ASSIGN_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_assigner_call_as (l_as: ASSIGNER_CALL_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_case_as (l_as: CASE_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_check_as (l_as: CHECK_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_creation_as (l_as: CREATION_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_debug_as (l_as: DEBUG_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_guard_as (l_as: GUARD_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_if_as (l_as: IF_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_inspect_as (l_as: INSPECT_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_interval_as (l_as: INTERVAL_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_loop_as (l_as: LOOP_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_retry_as (l_as: RETRY_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

	process_reverse_as (l_as: REVERSE_AS)
			-- Process `l_as'.
		do
			skip (l_as)
		end

feature {NONE} -- Implementation - skipping

	skip (a_node: AST_EIFFEL)
		do
				-- Just do nothing for now, but record where the skipped region ends.
				-- We might need this information in processing comments in the skipped region.
			skipping_until_index := a_node.end_position
		end

	skipping_until_index: INTEGER

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
							last_break_text := l_text
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
							last_break_text := l_text
						end
						last_index := last_index + 1
					end
				end
			end
		end

	default_create
		do
			make_with_default_context
			last_break_text := ""
			skipping_until_index := 0
		end

	last_break_text: attached STRING

end
