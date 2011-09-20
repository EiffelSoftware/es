note
	description: "Summary description for {AFX_INVARIANT_VIOLATION_SIGNATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_INVARIANT_VIOLATION_SIGNATURE

inherit
	AFX_ASSERTION_VIOLATION_SIGNATURE
		redefine
			initialize_id,
			analyze_exception_condition
		end

	EPA_CONTRACT_EXTRACTOR
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_assertion_tag: STRING; a_recipient_class: CLASS_C; a_recipient_feature: FEATURE_I)
			-- Initialization.
			-- After executing `a_recipient_class'.`a_recipient_feature',
			-- the invariant with `a_assertion_tag' is violated.
		do
			set_exception_code ({EXCEP_CONST}.class_invariant)
			set_violated_assertion_tag (a_assertion_tag)

			fixme ("Exception breakpoint information is not exact, but enough for fixing.")
			set_exception_breakpoint (breakpoint_count (recipient_feature))

			make_common (a_recipient_class, a_recipient_class.invariant_feature,
					0, 0,
					a_recipient_class, a_recipient_feature,
					0, 0)
		end

feature{AFX_INVARIANT_VIOLATION_SIGNATURE} -- Implementation

	initialize_id
			-- Initialize `id'.
		do
			Precursor
			id.append (".")
			id.append (violated_assertion_tag)
		end

	analyze_exception_condition
			-- <Precursor>
		do
			set_exception_condition (assertion_with_tag (invariant_of_class (recipient_class), violated_assertion_tag))
		end

feature{NONE} -- Implementation

	assertion_with_tag (a_assertions: LIST [EPA_EXPRESSION]; a_tag: STRING): EPA_EXPRESSION
			-- Assertion from `a_assertions' with tag `a_tag'
		local
			l_cursor: CURSOR
			l_expression: EPA_EXPRESSION
			l_done: BOOLEAN
		do
			l_cursor := a_assertions.cursor
			from
				a_assertions.start
			until
				a_assertions.after or else l_done
			loop
				l_expression := a_assertions.item_for_iteration
				if l_expression.tag ~ a_tag then
					l_done := True
					Result := l_expression
				end
				a_assertions.forth
			end
			a_assertions.go_to (l_cursor)
		end

end
