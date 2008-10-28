indexing
	description: "A version of AST_DECORATED_OUTPUT_STRATEGY used for computing the type of an expression, modified a bit"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_AST_TYPE_INFERER

inherit
	AST_DECORATED_OUTPUT_STRATEGY

create
	make, make_for_inline_agent


feature -- Additions

	reset_locals is
			-- Reset the local variables.
		do
			locals_for_current_feature.wipe_out
		end

	set_processing_locals (a_value: BOOLEAN) is
			-- Set `processing_locals' to `a_value'.
		do
			processing_locals := a_value
		ensure
			value_set: processing_locals = a_value
		end

end

