note
	description: "Summary description for {AFX_ASSERTION_VIOLATION_SIGNATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_ASSERTION_VIOLATION_SIGNATURE

inherit
	AFX_EXCEPTION_SIGNATURE

	EPA_UTILITY
		undefine is_equal end

feature -- Access

	violated_assertion_tag: STRING
			-- Tag of the violated assertion.

feature{AFX_ASSERTION_VIOLATION_SIGNATURE} -- Implementation

	analyze_exception_condition
			-- <Precursor>
		local
			l_assertion: TUPLE[tag: STRING; assertion: EPA_EXPRESSION]
		do
			l_assertion := assertion_at (exception_class, exception_feature, exception_breakpoint)
			set_violated_assertion_tag (l_assertion.tag)
			set_exception_condition (l_assertion.assertion)
		end

	analyze_exception_condition_in_recipient
			-- <Precursor>
		do
			set_exception_condition_in_recipient (exception_condition)
		end

feature{AFX_ASSERTION_VIOLATION_SIGNATURE} -- Stauts set

	set_violated_assertion_tag (a_tag: STRING)
			-- Set `violated_assertion_tag'.
		require
			tag_attached: a_tag /= Void
		do
			violated_assertion_tag := a_tag.twin
		end

end
