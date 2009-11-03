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
			item,
			is_nonsensical
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := none_type
		end

	item: STRING is "nonsensical"
			-- Value item in current

feature -- Status report

	is_nonsensical: BOOLEAN is True
			-- Is current a nonsensical value?

end
