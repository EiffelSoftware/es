note
	description: "Summary description for {EPA_CALLEE_STATEMENT_REWRITER_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CALLER_CONTEXT

inherit
	REFACTORING_HELPER

create
	make,
	make_with_callee

feature{NONE} -- Initialization

	make (a_operands: like operands; a_target_type: like target_type)
			-- Initialize Current.
		do
			create operands.make (a_operands.count)
			across a_operands as l_opds loop
				operands.force (l_opds.item, l_opds.key)
			end

			target_type := a_target_type
		end

	make_with_callee (a_operands: like operands; a_target_type: like target_type; a_calee_name: STRING)
			-- Initialize Current.
		do
			make (a_operands, a_target_type)
			set_callee_name (a_calee_name)
		end

	make_with_call_as (a_call_as: CALL_AS; a_target_type: like target_type)
			-- Initialize Current.
		do
			fixme ("To implement in the future to construct a context directly from a CALL_AS, to make client's life easier. Jasonw 05.07.2011.")
		end

feature -- Access

	operands: HASH_TABLE [STRING, INTEGER]
			-- Operands of the caller feature call
			-- Keys are 0-based operand indices, 0 is the target,
			-- 1 is the first argument, and so on. Result is at index
			-- (arg_count + 1) where arg_count is the number of arguments
			-- of the callee feature (if available).
			-- Values are the operand expression seen in the caller site.
			-- Values define how the callee site names are rewritten into
			-- caller site names.

	target_type: TYPE_A
			-- Type of the target operand.
			-- This should be the static type of the target operand in caller site.

	callee_name: detachable STRING
			-- Name of the called feature seen from the caller site
			-- A Void value indicates that current context does not include
			-- a feature call. This is useful in case you want to rewrite
			-- a some class invariant expressions of an object in an outer
			-- level, then you don't have any feature name to specify.

	callee_argument_count: INTEGER
			-- Number of formal arguments of the callee feature
		require
			has_callee: has_callee
		do
			Result := callee.argument_count
		end

	callee: FEATURE_I
			-- Feature representation of the callee
		require
			has_callee: has_callee
		do
			Result := target_type.associated_class.feature_named_32 (callee_name)
		end

	callee_written_class: CLASS_C
			-- Written class of the callee feature
		require
			has_callee: has_callee
		do
			Result := callee.written_class
		end

feature -- Status report

	has_callee: BOOLEAN
			-- Does current context contain a callee feature name?
		do
			Result := attached callee_name
		end

feature -- Setting

	set_callee_name (a_name: STRING)
			-- Set `callee_name' with `a_name'.
		do
			callee_name := a_name.twin
		ensure
			callee_name_set: callee_name ~ a_name
		end

invariant
	operands_has_target: operands.has (0) and then not operands.item (0).is_empty
	target_type_valid: target_type.has_associated_class

end
