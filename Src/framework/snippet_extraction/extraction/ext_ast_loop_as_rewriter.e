note
	description: "Simplifying and rewriting 'loop' statements with emtpy body."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_LOOP_AS_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			make_with_output,
			process_loop_as
		end

	EXT_AST_UTILITY

create
	make_with_output

feature {NONE} -- Creation

	make_with_output (a_output: like output)
			-- Make with `a_output'.
		do
			Precursor (a_output)
		end

feature -- Configuration

	variable_context: EXT_VARIABLE_CONTEXT
		assign set_variable_context
			-- Contextual information about relevant variables.

	set_variable_context (a_context: EXT_VARIABLE_CONTEXT)
			-- Sets `variable_context' to `a_context'	
		require
			attached a_context
		do
			variable_context := a_context
		end

feature {NONE} -- Implementation

	process_loop_as (l_as: LOOP_AS)
		local
			l_use_from_part, l_use_stop, l_use_compound: BOOLEAN
		do
				-- l_as.iteration not handled.

			if attached l_as.from_part as l_from_part_as then
				l_use_from_part := is_ast_eiffel_using_variable_of_interest (l_from_part_as, variable_context)
			end

			if attached l_as.stop as l_stop_as then
				l_use_stop := is_ast_eiffel_using_variable_of_interest (l_stop_as, variable_context)
			end

				-- l_as.invariant not handled.
				-- l_as.variant not handled.
				-- l_as.variant_part not handled.

			if attached l_as.compound as l_compound_as then
				l_use_compound := is_ast_eiffel_using_variable_of_interest (l_compound_as, variable_context)
			end

				-- Decide on processing.
			if l_use_from_part and not l_use_stop and not l_use_compound then
				process_loop_as_only_from_part_used	(l_as)
			else
				Precursor (l_as)
			end
		end

feature {NONE} -- Helpers

	process_loop_as_only_from_part_used (l_as: LOOP_AS)
			-- Replaces a 'loop' statement with the `{LOOP_AS}.from_part' instructions if
			-- neither the expression nor the body use variables of interest.
		do
			safe_process (l_as.from_part)
		end

end
