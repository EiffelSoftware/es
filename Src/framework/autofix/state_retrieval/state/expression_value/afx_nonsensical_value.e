note
	description: "Summary description for {AFX_NON_SENSICAL_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_NONSENSICAL_VALUE

inherit
	AFX_EXPRESSION_VALUE
		redefine
			is_nonsensical
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := none_type
		end

	item: STRING
			-- Value item in current
		do
			Result := {AUT_SHARED_CONSTANTS}.nonsensical
		end

feature -- Status report

	is_nonsensical: BOOLEAN is True
			-- Is current a nonsensical value?

feature -- Process

	process (a_visitor: AFX_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_nonsensical_value (Current)
		end

end
