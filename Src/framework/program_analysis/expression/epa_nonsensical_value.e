note
	description: "Summary description for {AFX_NON_SENSICAL_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_NONSENSICAL_VALUE

inherit
	EPA_EXPRESSION_VALUE
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
			Result := nonsensical
		end

	nonsensical: STRING
			-- Nonsensical value
		do
			Result := once "nonsensical"
		end

feature -- Status report

	is_nonsensical: BOOLEAN is True
			-- Is current a nonsensical value?

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_nonsensical_value (Current)
		end

end
